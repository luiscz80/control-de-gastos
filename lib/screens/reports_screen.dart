import 'package:control_gastos/providers/expenses_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReportsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Informes de Gastos',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            _buildReportCard(
              context,
              title: 'Gastos Semanales',
              description: 'Resumen semanal de gastos por semana.',
              icon: Icons.calendar_view_week,
              onTap: () async {
                final expensesProvider =
                    Provider.of<ExpensesProvider>(context, listen: false);
                List<Map<String, dynamic>> weeklyExpenses =
                    await expensesProvider.getWeeklyExpenses();
                _showWeeklyExpensesDialog(
                    context, 'Gastos Semanales', weeklyExpenses);
              },
            ),
            _buildReportCard(
              context,
              title: 'Gastos Mensuales',
              description: 'Resumen mensual de gastos por mes.',
              icon: Icons.calendar_view_month,
              onTap: () async {
                final expensesProvider =
                    Provider.of<ExpensesProvider>(context, listen: false);
                List<Map<String, dynamic>> monthlyExpenses =
                    await expensesProvider.getMonthlyExpenses();
                _showMonthlyExpensesDialog(
                    context, 'Gastos Mensuales', monthlyExpenses);
              },
            ),
            _buildReportCard(
              context,
              title: 'Gastos Anuales',
              description: 'Resumen anual de gastos por año.',
              icon: Icons.dashboard_customize_outlined,
              onTap: () async {
                final expensesProvider =
                    Provider.of<ExpensesProvider>(context, listen: false);
                List<Map<String, dynamic>> yearlyExpenses =
                    await expensesProvider.getYearlyExpenses();
                _showYearlyExpensesDialog(
                    context, 'Gastos Anuales', yearlyExpenses);
              },
            ),
            _buildSectionTitle('Filtrar por Fecha'),
            _buildDateFilterButton(
              context,
              title: 'Fecha Personalizada',
              description: 'Filtrar gastos por fecha personalizada.',
              icon: Icons.date_range_outlined,
              onTap: () {
                _showDateRangePicker(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildReportCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(
                icon,
                size: 40,
                color: Color.fromARGB(255, 6, 206, 178),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor),
                    ),
                    SizedBox(height: 8),
                    Text(description),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateFilterButton(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    required String description,
  }) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(
                icon,
                size: 40,
                color: Color.fromARGB(255, 6, 206, 178),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor),
                    ),
                    SizedBox(height: 8),
                    Text(description),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showDateRangePicker(BuildContext context) async {
    final initialDate = DateTime.now();
    final firstDate = DateTime(initialDate.year - 1);
    final lastDate = DateTime(initialDate.year + 1);
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );
    if (picked != null) {
      final expensesProvider =
          Provider.of<ExpensesProvider>(context, listen: false);
      List<Map<String, dynamic>> dailyExpenses =
          await expensesProvider.getDailyExpenses(picked);

      double totalAmount = 0;
      for (var expense in dailyExpenses) {
        totalAmount += expense['amount'];
      }

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
                'Gastos del ${picked.day}/${picked.month}/${picked.year}',
                style: TextStyle(fontSize: 20.0)),
            content: Container(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height:
                        250, // Puedes ajustar esta altura según sea necesario
                    child: Scrollbar(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: dailyExpenses.length +
                            1, // +1 para el icono de scroll
                        itemBuilder: (BuildContext context, int index) {
                          if (index == dailyExpenses.length) {
                            return Center(
                              child: Icon(Icons.arrow_downward),
                            );
                          }
                          var expense = dailyExpenses[index];
                          return ListTile(
                            title: Text(expense['title']),
                            subtitle: Text('Monto: ${expense['amount']} Bs'),
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Total de gastos: $totalAmount Bs',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cerrar'),
              ),
            ],
          );
        },
      );
    }
  }

  void _showWeeklyExpensesDialog(
      BuildContext context, String title, List<Map<String, dynamic>> expenses) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: expenses.isEmpty
              ? Text('Total: 0.0 Bs')
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: expenses.length,
                      itemBuilder: (BuildContext context, int index) {
                        String week = _getWeekYear(expenses[index]['week']);
                        double totalAmount = expenses[index]['total_amount'];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Semana:',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(width: 4),
                                Text(week),
                              ],
                            ),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  'Total:',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(width: 4),
                                Text('$totalAmount Bs'),
                              ],
                            ),
                            Divider(),
                          ],
                        );
                      },
                    ),
                  ],
                ),
          actions: <Widget>[
            TextButton(
              child: Text('Cerrar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  String _getWeekYear(String weekYear) {
    List<String> parts = weekYear.split("-");
    String year = parts[0];
    String week = parts[1];

    return 'Semana $week del $year';
  }

  void _showMonthlyExpensesDialog(
      BuildContext context, String title, List<Map<String, dynamic>> expenses) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: expenses.isEmpty
              ? Text('Total: 0.0 Bs')
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: expenses.length,
                      itemBuilder: (BuildContext context, int index) {
                        String month = _getMonthYear(expenses[index]['month']);
                        double totalAmount = expenses[index]['total_amount'];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Mes:',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(width: 4),
                                Text(month),
                              ],
                            ),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  'Total:',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(width: 4),
                                Text('$totalAmount Bs'),
                              ],
                            ),
                            Divider(),
                          ],
                        );
                      },
                    ),
                  ],
                ),
          actions: <Widget>[
            TextButton(
              child: Text('Cerrar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  String _getMonthYear(String monthYear) {
    List<String> parts = monthYear.split("-");
    String year = parts[0];
    String month = parts[1];

    String monthName = '';
    switch (int.parse(month)) {
      case 1:
        monthName = 'Enero';
        break;
      case 2:
        monthName = 'Febrero';
        break;
      case 3:
        monthName = 'Marzo';
        break;
      case 4:
        monthName = 'Abril';
        break;
      case 5:
        monthName = 'Mayo';
        break;
      case 6:
        monthName = 'Junio';
        break;
      case 7:
        monthName = 'Julio';
        break;
      case 8:
        monthName = 'Agosto';
        break;
      case 9:
        monthName = 'Septiembre';
        break;
      case 10:
        monthName = 'Octubre';
        break;
      case 11:
        monthName = 'Noviembre';
        break;
      case 12:
        monthName = 'Diciembre';
        break;
      default:
        monthName = 'Mes Desconocido';
        break;
    }

    return '$monthName de $year';
  }

  void _showYearlyExpensesDialog(
      BuildContext context, String title, List<Map<String, dynamic>> expenses) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: expenses.isEmpty
              ? Text('Total: 0.0 Bs')
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: expenses.length,
                      itemBuilder: (BuildContext context, int index) {
                        String year = expenses[index]['year'];
                        double totalAmount = expenses[index]['total_amount'];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Año:',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(width: 4),
                                Text(
                                  year,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  'Total:',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(width: 4),
                                Text('$totalAmount Bs'),
                              ],
                            ),
                            Divider(),
                          ],
                        );
                      },
                    ),
                  ],
                ),
          actions: <Widget>[
            TextButton(
              child: Text('Cerrar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
