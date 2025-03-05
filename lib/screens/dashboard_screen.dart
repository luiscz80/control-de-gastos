import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/expenses_provider.dart';
import '../providers/categories_provider.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final expensesProvider = Provider.of<ExpensesProvider>(context);
    final categoriesProvider = Provider.of<CategoriesProvider>(context);

    // Calcular el total de todos los gastos
    final totalAmount = expensesProvider.expenses.fold(
      0.0,
      (sum, expense) => sum + expense.amount,
    );

    // Preparar los datos para el gráfico de barras
    final categoryTotals = categoriesProvider.categories.map((category) {
      final totalAmountForCategory = expensesProvider.expenses
          .where((expense) => expense.categoryId == category.id)
          .fold(0.0, (sum, expense) => sum + expense.amount);

      return {
        'name': category.name,
        'total':
            totalAmountForCategory.toStringAsFixed(2), // Convertir a String
      };
    }).toList();

    // Ordenar las categorías por la suma de montos y tomar las 5 primeras
    categoryTotals.sort((a, b) {
      final totalA = double.tryParse(a['total'] ?? '');
      final totalB = double.tryParse(b['total'] ?? '');

      if (totalA != null && totalB != null) {
        return totalB.compareTo(totalA);
      } else if (totalA != null) {
        return -1;
      } else if (totalB != null) {
        return 1;
      } else {
        return 0;
      }
    });

    final top5Categories = categoryTotals.take(5).toList();

    double maxTotal = 0.0;
    if (categoryTotals.isNotEmpty) {
      maxTotal = categoryTotals
          .map((data) => double.parse(data['total']!))
          .reduce((max, current) => max > current ? max : current);
    }

    // Definir el valor máximo del eje y como ligeramente mayor que el máximo total
    final maxY = maxTotal * 1.2; // Ajusta el factor según tus necesidades

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
                    'Resumen de Gastos',
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: maxTotal > 0
                  ? Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey[200],
                      ),
                      child: top5Categories.isEmpty
                          ? Center(
                              child: Text(
                                'Aún no hay datos disponibles',
                                style:
                                    TextStyle(fontSize: 16, color: Colors.grey),
                              ),
                            )
                          : BarChart(
                              BarChartData(
                                alignment: BarChartAlignment.spaceAround,
                                maxY: maxY,
                                barGroups:
                                    top5Categories.asMap().entries.map((entry) {
                                  final index = entry.key;
                                  final data = entry.value;
                                  return BarChartGroupData(
                                    x: index,
                                    barRods: [
                                      BarChartRodData(
                                        y: double.parse(data['total']!),
                                        colors: [
                                          Theme.of(context).primaryColor
                                        ],
                                        width: 16,
                                        borderRadius: BorderRadius.zero,
                                      )
                                    ],
                                    showingTooltipIndicators: [0],
                                  );
                                }).toList(),
                                titlesData: FlTitlesData(
                                  leftTitles: SideTitles(
                                    showTitles: true,
                                    getTextStyles: (value) => TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                    interval: 1000,
                                    reservedSize: 20,
                                    margin: 8,
                                    getTitles: (value) {
                                      if (value % 1000 == 0) {
                                        return '${(value ~/ 1000)}k';
                                      } else if (value >= 1000000) {
                                        return '${(value ~/ 1000000)}M';
                                      } else {
                                        return '${value.toInt()}';
                                      }
                                    },
                                  ),
                                  bottomTitles: SideTitles(
                                    showTitles: true,
                                    getTextStyles: (value) => TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11,
                                      fontFamily: 'Poppins',
                                    ),
                                    margin: 2,
                                    getTitles: (value) {
                                      final index = value.toInt();
                                      if (index >= 0 &&
                                          index < top5Categories.length) {
                                        String categoryName =
                                            top5Categories[index]['name']
                                                .toString();
                                        return categoryName.length > 8
                                            ? categoryName.substring(0, 6) +
                                                "..."
                                            : categoryName;
                                      }
                                      return '';
                                    },
                                  ),
                                ),
                                borderData: FlBorderData(
                                  show: true,
                                  border: Border.all(
                                      color: Color.fromARGB(255, 6, 206, 178),
                                      width: 0.4),
                                ),
                                gridData: FlGridData(show: false),
                                barTouchData: BarTouchData(
                                  touchTooltipData: BarTouchTooltipData(
                                      tooltipBgColor: Color.fromARGB(255, 6,
                                          206, 178), // Fondo del tooltip
                                      tooltipMargin:
                                          2, // Esto establece el margen del tooltip
                                      tooltipPadding: EdgeInsets.only(
                                          left: 0.0,
                                          top: 4.0,
                                          right: 6.0,
                                          bottom: 1.0),
                                      getTooltipItem:
                                          (group, groupIndex, rod, rodIndex) {
                                        if (rod.y > 0) {
                                          return BarTooltipItem(
                                            rod.y.toString(),
                                            TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                            ),
                                          );
                                        } else {
                                          return null;
                                        }
                                      }),
                                ),
                              ),
                            ),
                    )
                  : Center(
                      child: Text(
                        'Aún no hay datos disponibles',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
            ),
            SizedBox(height: 4),
            Container(
              padding: EdgeInsets.all(6.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius:
                    BorderRadius.circular(8.0), // Radio de borde opcional
              ),
              child: Text(
                'Total: \Bs. ${totalAmount.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // Color del texto
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
