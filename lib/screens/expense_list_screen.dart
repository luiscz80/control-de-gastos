import 'package:control_gastos/models/categories.dart';
import 'package:control_gastos/providers/categories_provider.dart';
import 'package:control_gastos/widgets/snackbar_message.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/expenses_provider.dart';
import '../models/expense.dart';
import '../screens/edit_expense_screen.dart';

class ExpenseListScreen extends StatefulWidget {
  @override
  _ExpenseListScreenState createState() => _ExpenseListScreenState();
}

class _ExpenseListScreenState extends State<ExpenseListScreen> {
  String searchQuery = "";
  TextEditingController _searchController = TextEditingController();
  Category? selectedCategory;

  @override
  void initState() {
    super.initState();
  }

  void _unfocusSearchField() {
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer2<ExpensesProvider, CategoriesProvider>(
        builder: (context, expenseViewModel, categoriesProvider, child) {
          List<Expense> displayedExpenses = expenseViewModel.expenses
              .where((expense) =>
                  expense.title
                      .toLowerCase()
                      .contains(searchQuery.toLowerCase()) ||
                  expense.amount.toString().contains(searchQuery.toLowerCase()))
              .toList();

          if (selectedCategory != null) {
            displayedExpenses = displayedExpenses
                .where((expense) => expense.categoryId == selectedCategory!.id)
                .toList();
          }

          if (expenseViewModel.expenses.isEmpty) {
            return Center(
              child: Text(
                'Aún no hay registro de gastos',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          } else {
            final totalAmount = expenseViewModel.expenses
                .map((product) => product.amount)
                .reduce((value, element) => value + element);
            return Column(
              children: [
                SingleChildScrollView(
                  child: Container(
                    color: Theme.of(context).primaryColor,
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Monto:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Bs ${totalAmount.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 10.0),
                            hintText: 'Buscar por descripción y monto',
                            hintStyle: TextStyle(fontSize: 13),
                            border: InputBorder.none,
                            prefixIcon: Icon(
                              Icons.search,
                              color: Color.fromARGB(255, 6, 206, 178),
                            ),
                            suffixIcon: searchQuery.isNotEmpty
                                ? IconButton(
                                    icon: Icon(Icons.clear, color: Colors.grey),
                                    onPressed: () {
                                      setState(() {
                                        _searchController.clear();
                                        searchQuery = '';
                                      });
                                      _unfocusSearchField();
                                    },
                                  )
                                : null,
                          ),
                          onChanged: (value) {
                            setState(() {
                              searchQuery = value;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(width: 6.0),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: IconButton(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(25.0)),
                            ),
                            builder: (context) {
                              return SingleChildScrollView(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white, // Fondo blanco
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(25.0)),
                                  ),
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Center(
                                        child: Container(
                                          width: 50,
                                          height: 5,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[300],
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        'Filtrar por categorías',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color:
                                              Color.fromARGB(255, 6, 206, 178),
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Wrap(
                                        spacing: 8.0,
                                        runSpacing: 4.0,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                selectedCategory =
                                                    null; // Show all expenses
                                              });
                                              Navigator.pop(context);
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: selectedCategory == null
                                                    ? Theme.of(context)
                                                        .primaryColor
                                                    : Colors.grey[200],
                                                borderRadius:
                                                    BorderRadius.circular(16.0),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.5),
                                                    spreadRadius: 2,
                                                    blurRadius: 5,
                                                    offset: Offset(0, 3),
                                                  ),
                                                ],
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 12.0,
                                                  vertical: 8.0),
                                              child: Text(
                                                'Todos los gastos',
                                                style: TextStyle(
                                                  color:
                                                      selectedCategory == null
                                                          ? Colors.white
                                                          : Colors.black,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ),
                                          ...categoriesProvider
                                              .categories.reversed
                                              .map((category) {
                                            return GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  selectedCategory = category;
                                                });
                                                Navigator.pop(context);
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: selectedCategory ==
                                                          category
                                                      ? Theme.of(context)
                                                          .primaryColor
                                                      : Colors.grey[200],
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          16.0),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey
                                                          .withOpacity(0.5),
                                                      spreadRadius: 2,
                                                      blurRadius: 5,
                                                      offset: Offset(0, 3),
                                                    ),
                                                  ],
                                                ),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 12.0,
                                                    vertical: 8.0),
                                                child: Text(
                                                  category.name,
                                                  style: TextStyle(
                                                    color: selectedCategory ==
                                                            category
                                                        ? Colors.white
                                                        : Colors.black,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        icon: Icon(Icons.filter_list,
                            color: Color.fromARGB(255, 6, 206, 178)),
                      ),
                    ),
                  ],
                ),
                if ((searchQuery.isNotEmpty && displayedExpenses.isEmpty) ||
                    (selectedCategory != null && displayedExpenses.isEmpty))
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 16.0),
                    child: Text(
                      'No se encontraron resultados',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(top: 0),
                    child: ListView.builder(
                      itemCount: displayedExpenses.length,
                      itemBuilder: (context, index) {
                        final int reversedIndex =
                            displayedExpenses.length - 1 - index;
                        final Expense expense =
                            displayedExpenses[reversedIndex];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 0.0, horizontal: 8.0),
                          child: InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Center(
                                    child: Text(
                                      '${expense.title.toUpperCase()}',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromARGB(255, 6, 206, 178),
                                      ),
                                    ),
                                  ),
                                  contentPadding: EdgeInsets.only(
                                      left: 14.0,
                                      top: 0.0,
                                      right: 14.0,
                                      bottom: 4.0),
                                  content: Container(
                                    constraints: BoxConstraints(maxHeight: 280),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(height: 8),
                                          Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: InteractiveViewer(
                                              panEnabled: true,
                                              minScale: 0.1,
                                              maxScale: 4.0,
                                              child: expense.imagePath != null
                                                  ? Image.file(
                                                      expense.imagePath!,
                                                      fit: BoxFit.contain)
                                                  : Center(
                                                      child: Text(
                                                          'No hay imagen disponible')),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  actions: [
                                    Center(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          _unfocusSearchField();
                                        },
                                        child: Text('OK'),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                            child: Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            expense.title.toUpperCase(),
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            'Categoría: ${Provider.of<CategoriesProvider>(context).categories.firstWhere((category) => category.id == expense.categoryId, orElse: () => Category(id: -1, name: 'No definida')).name}',
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 14,
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            'Monto: \Bs ${expense.amount.toStringAsFixed(2)}',
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontSize: 14,
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            'Fecha y Hora: ${_formatDate(expense.date)}',
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 72,
                                            width: 72,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              image: DecorationImage(
                                                image: expense.imagePath != null
                                                    ? FileImage(
                                                        expense.imagePath!)
                                                    : AssetImage(
                                                            'assets/placeholder_image.png')
                                                        as ImageProvider,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              IconButton(
                                                icon: Icon(Icons.edit),
                                                color: Color.fromARGB(
                                                    255, 6, 206, 178),
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    PageRouteBuilder(
                                                      transitionDuration:
                                                          Duration(
                                                              milliseconds:
                                                                  600),
                                                      pageBuilder:
                                                          (_, __, ___) =>
                                                              EditExpenseScreen(
                                                        expense: expense,
                                                      ),
                                                      transitionsBuilder: (_,
                                                          animation,
                                                          __,
                                                          child) {
                                                        return SlideTransition(
                                                          position:
                                                              Tween<Offset>(
                                                            begin: Offset(0, 1),
                                                            end: Offset.zero,
                                                          ).animate(animation),
                                                          child: child,
                                                        );
                                                      },
                                                    ),
                                                  );
                                                },
                                              ),
                                              IconButton(
                                                icon: Icon(
                                                  Icons.delete,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                ),
                                                onPressed: () {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        AlertDialog(
                                                      title: Text(
                                                        'Eliminar Gasto',
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      content: RichText(
                                                        text: TextSpan(
                                                          text:
                                                              '¿Estás seguro de que deseas eliminar el gasto: ',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black),
                                                          children: <TextSpan>[
                                                            TextSpan(
                                                              text:
                                                                  '${expense.title.toUpperCase()}',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            TextSpan(
                                                              text: '?',
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                            _unfocusSearchField();
                                                          },
                                                          child:
                                                              Text('Cancelar'),
                                                        ),
                                                        TextButton(
                                                          onPressed: () {
                                                            expenseViewModel
                                                                .deleteExpense(
                                                                    expense
                                                                        .id!);
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                            _unfocusSearchField();
                                                          },
                                                          child:
                                                              Text('Eliminar'),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
      floatingActionButton: Consumer<ExpensesProvider>(
        builder: (context, expenseViewModel, child) {
          if (expenseViewModel.expenses.length > 3) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    showDeleteConfirmationDialog(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 15),
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text(
                    'Eliminar gastos',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  String _formatDate(DateTime dateTime) {
    final day = DateFormat.d().format(dateTime);
    final month = _getMonthInSpanish(dateTime);
    final year = DateFormat.y().format(dateTime);
    final hourMinute = DateFormat.Hm().format(dateTime);
    return '$day de $month de $year - $hourMinute';
  }

  String _getMonthInSpanish(DateTime dateTime) {
    switch (dateTime.month) {
      case 1:
        return 'enero';
      case 2:
        return 'febrero';
      case 3:
        return 'marzo';
      case 4:
        return 'abril';
      case 5:
        return 'mayo';
      case 6:
        return 'junio';
      case 7:
        return 'julio';
      case 8:
        return 'agosto';
      case 9:
        return 'septiembre';
      case 10:
        return 'octubre';
      case 11:
        return 'noviembre';
      case 12:
        return 'diciembre';
      default:
        return '';
    }
  }

  void showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Eliminar todos los Gastos',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('¿Estás seguro de que deseas eliminar todos los gastos?'),
              Text(
                'No podrá revertir esta acción.',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                _unfocusSearchField();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Provider.of<ExpensesProvider>(context, listen: false)
                    .deleteAllExpenses();
                Navigator.pop(dialogContext);
                _unfocusSearchField();
                showCustomSnackBar(
                    context, 'Todos los gastos han sido eliminados con éxito.');
              },
              child: Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }
}
