import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CurrencyModel {
  final String code;
  final String symbol;
  final String name;
  final double rateToUsd; // Exchange rate relative to USD

  CurrencyModel({
    required this.code,
    required this.symbol,
    required this.name,
    required this.rateToUsd,
  });
}

class SettingsProvider with ChangeNotifier {
  static final List<CurrencyModel> currencies = [
    CurrencyModel(code: 'KES', symbol: 'KSh', name: 'Kenyan Shilling', rateToUsd: 155.0),
    CurrencyModel(code: 'USD', symbol: '\$', name: 'US Dollar', rateToUsd: 1.0),
    CurrencyModel(code: 'EUR', symbol: '€', name: 'Euro', rateToUsd: 0.92),
    CurrencyModel(code: 'GBP', symbol: '£', name: 'British Pound', rateToUsd: 0.79),
    CurrencyModel(code: 'JPY', symbol: '¥', name: 'Japanese Yen', rateToUsd: 148.0),
    CurrencyModel(code: 'NGN', symbol: '₦', name: 'Nigerian Naira', rateToUsd: 900.0),
  ];

  CurrencyModel _selectedCurrency = currencies[0]; // Default to KES
  String _userName = 'Financial Wizard';
  String? _profileImagePath;
  int _primaryColorValue = 0xFF98DA27; // Default secondary/accent color

  CurrencyModel get selectedCurrency => _selectedCurrency;
  String get userName => _userName;
  String? get profileImagePath => _profileImagePath;
  int get primaryColorValue => _primaryColorValue;
  Color get primaryColor => Color(_primaryColorValue);

  void setCurrency(String code) {
    _selectedCurrency = currencies.firstWhere((c) => c.code == code);
    notifyListeners();
  }

  void updateProfile({String? name, String? imagePath, int? colorValue}) {
    if (name != null) _userName = name;
    if (imagePath != null) _profileImagePath = imagePath;
    if (colorValue != null) _primaryColorValue = colorValue;
    notifyListeners();
  }

  String formatAmount(double amount) {
    // amount is stored in base currency (let's assume USD for database, 
    // but the user might have entered it in KES)
    // For now, let's treat the database 'amount' as being in the 'selected' currency
    // or provide conversion methods.
    
    final format = NumberFormat.currency(symbol: _selectedCurrency.symbol, decimalDigits: 2);
    return format.format(amount);
  }

  double convert(double amount, String fromCode, String toCode) {
    final from = currencies.firstWhere((c) => c.code == fromCode);
    final to = currencies.firstWhere((c) => c.code == toCode);
    
    // amount / fromRate = USD amount
    // USD amount * toRate = to amount
    return (amount / from.rateToUsd) * to.rateToUsd;
  }
}
