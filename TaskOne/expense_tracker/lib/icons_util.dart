import 'package:flutter/material.dart';

class IconsUtil {
  static IconData getIconForCategory(String category) {
    switch (category) {
      case 'Bills':
        return Icons.account_balance;
      case 'Groceries':
        return Icons.shopping_cart;
      case 'Entertainment':
        return Icons.movie;
      case 'Other':
        return Icons.star;
      default:
        return Icons.help; 
    }
  }
}
