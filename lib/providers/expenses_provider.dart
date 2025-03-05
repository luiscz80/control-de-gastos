import 'package:flutter/material.dart';

import '../models/expense.dart';
import '../utils/database_helper.dart';

class ExpensesProvider extends ChangeNotifier {
  List<Expense> _expenses = [];

  List<Expense> get expenses => _expenses;

  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  ExpensesProvider() {
    _fetchExpenses();
    _loadData();
  }

  // Método para notificar a los oyentes
  void _notifyListeners() {
    notifyListeners();
  }

  Future<void> _fetchExpenses() async {
    _expenses = await _dbHelper.getExpenses();
    _notifyListeners();
  }

  Future<void> addExpense(Expense expense) async {
    await _dbHelper.insertExpense(expense);
    _fetchExpenses();
  }

  Future<void> updateExpense(Expense expense) async {
    await _dbHelper.updateExpense(expense);
    _fetchExpenses();
  }

  Future<void> deleteExpense(int id) async {
    await _dbHelper.deleteExpense(id);
    _fetchExpenses();
  }

  Future<void> deleteAllExpenses() async {
    await _dbHelper.deleteAllExpenses();
    _fetchExpenses();
  }

  Future<void> _loadData() async {
    _expenses = await _dbHelper.getExpenses();
    _notifyListeners(); // Llamar al método para notificar a los oyentes
  }

  Future<double> getTotalExpenseAmount() async {
    double totalAmount = 0.0;

    final result = await _dbHelper.getTotalExpenseAmount();
    totalAmount = result['total_amount'] ?? 0.0;
    return totalAmount;
  }

  Future<List<Map<String, dynamic>>> getWeeklyExpenses() async {
    try {
      return await _dbHelper.getWeeklyExpenses();
    } catch (e) {
      print('Error al obtener los gastos semanales: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getMonthlyExpenses() async {
    try {
      return await _dbHelper.getMonthlyExpenses();
    } catch (e) {
      print('Error al obtener los gastos mensuales: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getYearlyExpenses() async {
    try {
      return await _dbHelper.getYearlyExpenses();
    } catch (e) {
      print('Error al obtener los gastos anuales: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getDailyExpenses(picked) async {
    try {
      return await _dbHelper.getDailyExpenses(picked);
    } catch (e) {
      print('Error al obtener los gastos: $e');
      return [];
    }
  }

  Future<void> searchExpenses(String query) async {
    _expenses = await _dbHelper.searchExpenses(query);
    notifyListeners();
  }
}
