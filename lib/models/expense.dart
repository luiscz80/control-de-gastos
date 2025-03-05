import 'dart:io';

class Expense {
  final int? id;
  final String title;
  final double amount;
  final int categoryId;
  final DateTime date;
  final File? imagePath;

  Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.categoryId,
    required this.date,
    required this.imagePath,
  });

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'] as int? ?? 0,
      title: map['title'] as String? ?? '',
      amount: map['amount'] as double? ?? 0.0,
      categoryId: map['categoryId'],
      date: DateTime.parse(map['date'] as String? ?? ''),
      imagePath: map['imagePath'] != null ? File(map['imagePath']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'categoryId': categoryId,
      'date': date.toIso8601String(),
      'imagePath': imagePath?.path,
    };
  }
}
