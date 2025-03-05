import 'dart:io';
import 'package:control_gastos/providers/categories_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../models/categories.dart';
import '../models/expense.dart';
import '../providers/expenses_provider.dart';

class AddExpenseScreen extends StatefulWidget {
  @override
  _AddExpenseScreenState createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  Category? selectedCategory;
  DateTime _selectedDate = DateTime.now();
  File? _image;
  final picker = ImagePicker();

  Future<void> _captureImage() async {
    final pickedImage = await picker.getImage(source: ImageSource.camera);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  Future<void> _selectImage() async {
    final pickedImage = await picker.getImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDate),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = DateTime(
          _selectedDate.year,
          _selectedDate.month,
          _selectedDate.day,
          picked.hour,
          picked.minute,
        );
      });
    }
  }

  void _unfocusSearchField() {
    FocusScope.of(context).unfocus();
  }

  void _addExpense() {
    final title = _titleController.text.trim();
    final amountText = _amountController.text.trim();

    if (_image == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Imagen requerida',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            content:
                Text('Por favor, capture o seleccione una imagen del gasto.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Aceptar'),
              ),
            ],
          );
        },
      );
      return;
    }

    if (title.isEmpty || amountText.isEmpty || selectedCategory == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Campos vacíos',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            content: Text('Por favor, complete todos los campos.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Aceptar'),
              ),
            ],
          );
        },
      );
      return;
    }

    final amount = double.parse(amountText);

    final newExpense = Expense(
      id: null,
      title: title,
      categoryId: selectedCategory!.id!,
      amount: amount,
      date: _selectedDate,
      imagePath: _image!,
    );

    Provider.of<ExpensesProvider>(context, listen: false)
        .addExpense(newExpense);
    Navigator.pop(context);
    _unfocusSearchField();
  }

  @override
  Widget build(BuildContext context) {
    final categoryViewModel = Provider.of<CategoriesProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/logo.png',
                    height: 34,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Registrar gasto',
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 16),
              Text('Adjuntar imagen del gasto'),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _captureImage,
                    child: Row(
                      children: [
                        Icon(
                          Icons.camera_alt_outlined,
                          color: Color.fromARGB(255, 6, 206, 178),
                        ),
                        SizedBox(width: 8),
                        Text('Capturar'),
                      ],
                    ),
                  ),
                  SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _selectImage,
                    child: Row(
                      children: [
                        Icon(
                          Icons.image_search_outlined,
                          color: Color.fromARGB(255, 6, 206, 178),
                        ),
                        SizedBox(width: 8),
                        Text('Seleccionar'),
                      ],
                    ),
                  ),
                ],
              ),
              if (_image != null)
                Image.file(
                  _image!,
                  width: 150,
                  height: 150,
                ),
              SizedBox(height: 16),
              Text('Descripción de gasto'),
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                    labelText: 'Ingrese la descripción del gasto'),
              ),
              SizedBox(height: 16),
              Text('Agregar monto'),
              TextField(
                controller: _amountController,
                decoration: InputDecoration(labelText: 'Monto en Bs'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
              SizedBox(height: 16),
              Text('Elegir categoría'),
              DropdownButton<Category>(
                hint: Text(selectedCategory != null
                    ? selectedCategory!.name
                    : 'Seleccionar Categoría'),
                value: selectedCategory,
                onChanged: (Category? newCategory) {
                  setState(() {
                    selectedCategory = newCategory;
                  });
                },
                items: categoryViewModel.categories.reversed
                    .map((Category category) {
                  return DropdownMenuItem<Category>(
                    value: category,
                    child: Text(category.name),
                  );
                }).toList(),
              ),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AddCategoryDialog(),
                      ).then((value) {
                        if (value != null && value is Category) {
                          setState(() {
                            selectedCategory = null;
                          });
                        }
                      });
                    },
                    child: Text('Agregar categoría'),
                  ),
                  SizedBox(width: 8), // Espacio entre el botón y el icono
                  IconButton(
                    icon: Icon(Icons.info,
                        color: Color.fromARGB(255, 6, 206, 178)),
                    onPressed: () {
                      // Mostrar un mensaje cuando se hace clic en el icono de información
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Información',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          content: Text(
                              'Si la categoría que buscas no existe, puedes agregarla desde Botón Agregar categoría.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Cerrar'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text('Seleccionar fecha y hora'),
              GestureDetector(
                onTap: () async {
                  await _selectDate();
                  await _selectTime();
                },
                child: Row(
                  children: [
                    Icon(Icons.calendar_today),
                    SizedBox(width: 8),
                    Text(
                      DateFormat('dd/MM/yyyy - HH:mm').format(_selectedDate),
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _addExpense,
                child: Text('Registrar gasto'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddCategoryDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final categoryViewModel = Provider.of<CategoriesProvider>(context);
    final _formKey = GlobalKey<FormState>();
    final TextEditingController _categoryNameController =
        TextEditingController();

    return AlertDialog(
      title: Text('Agregar Categoría',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _categoryNameController,
          decoration: InputDecoration(
            hintText: 'Nombre de la categoría',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'El nombre es requerido';
            }
            return null;
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final newCategory = Category(
                name: _categoryNameController.text,
              );
              categoryViewModel.addCategory(newCategory);
              Navigator.of(context).pop();
            }
          },
          child: Text('Guardar'),
        ),
      ],
    );
  }
}
