class TransactionModel {
  final String id;
  final String type; // 'expense', 'income', 'transfer'
  final double amount;
  final String category;
  final String note;
  final DateTime date;
  final String paymentMethod;

  TransactionModel({
    required this.id,
    required this.type,
    required this.amount,
    required this.category,
    this.note = '',
    required this.date,
    this.paymentMethod = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'amount': amount,
      'category': category,
      'note': note,
      'date': date.toIso8601String(),
      'payment_method': paymentMethod,
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'],
      type: map['type'],
      amount: map['amount'],
      category: map['category'],
      note: map['note'] ?? '',
      date: DateTime.parse(map['date']),
      paymentMethod: map['payment_method'] ?? '',
    );
  }

  TransactionModel copyWith({
    String? id, String? type, double? amount,
    String? category, String? note, DateTime? date, String? paymentMethod,
  }) {
    return TransactionModel(
      id: id ?? this.id, type: type ?? this.type,
      amount: amount ?? this.amount, category: category ?? this.category,
      note: note ?? this.note, date: date ?? this.date,
      paymentMethod: paymentMethod ?? this.paymentMethod,
    );
  }

  bool get isExpense => type == 'expense';
  bool get isIncome => type == 'income';
  bool get isTransfer => type == 'transfer';
}

// Categories with icons and colors
class TransactionCategory {
  final String id;
  final String label;
  final String icon; // Material icon name mapping
  final int colorValue;

  const TransactionCategory({
    required this.id, required this.label,
    required this.icon, required this.colorValue,
  });

  static const List<TransactionCategory> all = [
    TransactionCategory(id: 'food', label: 'Food', icon: 'restaurant', colorValue: 0xFFCABEFF),
    TransactionCategory(id: 'transport', label: 'Transport', icon: 'directions_car', colorValue: 0xFF7BD0FF),
    TransactionCategory(id: 'rent', label: 'Rent', icon: 'home', colorValue: 0xFF947DFF),
    TransactionCategory(id: 'shopping', label: 'Shopping', icon: 'shopping_bag', colorValue: 0xFF98DA27),
    TransactionCategory(id: 'health', label: 'Health', icon: 'favorite', colorValue: 0xFFFFB4AB),
    TransactionCategory(id: 'entertainment', label: 'Entertainment', icon: 'movie', colorValue: 0xFF7BD0FF),
    TransactionCategory(id: 'salary', label: 'Salary', icon: 'work', colorValue: 0xFF98DA27),
    TransactionCategory(id: 'freelance', label: 'Freelance', icon: 'laptop', colorValue: 0xFF98DA27),
    TransactionCategory(id: 'other', label: 'Other', icon: 'more_horiz', colorValue: 0xFF938EA1),
  ];

  static TransactionCategory? findById(String id) {
    try {
      return all.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }
}
