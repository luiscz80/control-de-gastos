import 'package:control_gastos/models/categories.dart';
import 'package:control_gastos/providers/categories_provider.dart';
import 'package:control_gastos/screens/add_category_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/expenses_provider.dart';
import '../models/expense.dart';

class EditExpenseScreen extends StatefulWidget {
  final Expense expense;

  EditExpenseScreen({required this.expense});

  @override
  _EditExpenseScreenState createState() => _EditExpenseScreenState();
}

class _EditExpenseScreenState extends State<EditExpenseScreen> {
  late String expenseTitle;
  late double? expenseAmount;
  Category? selectedCategory;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    expenseTitle = widget.expense.title;
    expenseAmount = widget.expense.amount;
    selectedCategory = Provider.of<CategoriesProvider>(context, listen: false)
        .categories
        .firstWhere((category) => category.id == widget.expense.categoryId);
    _selectedDate = widget.expense.date;
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

  @override
  Widget build(BuildContext context) {
    Provider.of<ExpensesProvider>(context);
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
                    'Editar gasto',
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (widget.expense.imagePath != null)
              Image.file(
                widget.expense.imagePath!,
                width: 100,
                height: 140,
                fit: BoxFit.cover,
              ),
            SizedBox(height: 16),
            Text('Descripción de gasto'),
            TextFormField(
              initialValue: expenseTitle,
              onChanged: (value) {
                expenseTitle = value;
              },
              decoration: InputDecoration(
                  labelText: 'Ingrese la descripción del gasto'),
            ),
            SizedBox(height: 16),
            Text('Agregar monto'),
            TextFormField(
              initialValue: expenseAmount?.toString(), // Convertir a string
              onChanged: (value) {
                expenseAmount =
                    double.tryParse(value); // Intentar analizar como double
              },
              decoration: InputDecoration(labelText: 'Monto en Bs'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            SizedBox(height: 8),
            DropdownButton<Category>(
              hint: Text(selectedCategory != null
                  ? selectedCategory!.name
                  : 'Seleccionar Categoría'),
              onChanged: (Category? newCategory) {
                setState(() {
                  selectedCategory = newCategory;
                });
              },
              items: [
                ...Provider.of<CategoriesProvider>(context)
                    .categories
                    .reversed
                    .map((Category category) {
                  return DropdownMenuItem<Category>(
                    value: category,
                    child: Text(category.name),
                  );
                }).toList(),
              ],
            ),

            SizedBox(height: 4),
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
                  icon:
                      Icon(Icons.info, color: Color.fromARGB(255, 6, 206, 178)),
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
            SizedBox(height: 8),
            Text('Fecha'),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _selectDate,
                    child: Text(
                        'Fecha: ${DateFormat.yMd().format(_selectedDate)}'),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _selectTime,
                    child:
                        Text('Hora: ${DateFormat.Hm().format(_selectedDate)}'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16), // Añadido para separación
            ElevatedButton(
              onPressed: () {
                if (expenseTitle.isNotEmpty && selectedCategory != null) {
                  final categoryId = selectedCategory!.id;
                  if (categoryId != null && expenseAmount != null) {
                    Provider.of<ExpensesProvider>(context, listen: false)
                        .updateExpense(
                      Expense(
                        id: widget.expense.id,
                        title: expenseTitle,
                        categoryId: selectedCategory!.id!,
                        amount: expenseAmount!,
                        date: _selectedDate,
                        imagePath: widget.expense.imagePath,
                      ),
                    );
                    Navigator.of(context).pop();
                    _unfocusSearchField();
                  }
                }
              },
              child: Text('Guardar cambios'),
            ),
          ],
        ),
      ),
    );
  }
}
