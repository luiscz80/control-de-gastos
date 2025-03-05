import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/categories.dart';
import '../providers/categories_provider.dart';

class AddCategoryDialog extends StatefulWidget {
  @override
  _AddCategoryDialogState createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends State<AddCategoryDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _categoryNameController = TextEditingController();

  @override
  void dispose() {
    _categoryNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categoryViewModel = Provider.of<CategoriesProvider>(context);

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
