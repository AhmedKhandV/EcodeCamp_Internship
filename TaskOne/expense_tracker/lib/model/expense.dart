import 'dart:convert';

class Expense {
  final int? id;
  final String title;
  final double amount;
  final DateTime date;
  final String category;
  final String? description; // Description field added

  Expense({
    this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
    this.description, // Constructor parameter for description
  });

  Expense copyWith({
    int? id,
    String? title,
    double? amount,
    DateTime? date,
    String? category,
    String? description, // Add this line to copyWith method
  }) {
    return Expense(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      category: category ?? this.category,
      description: description ?? this.description, // Add this line
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'date': date.toIso8601String(),
      'category': category,
      'description': description, // Add description to map
    };
  }

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'],
      title: map['title'],
      amount: map['amount'],
      date: DateTime.parse(map['date']),
      category: map['category'],
      description: map['description'], // Add description from map
    );
  }

  String toJson() => json.encode(toMap());

  factory Expense.fromJson(String source) => Expense.fromMap(json.decode(source));
}
