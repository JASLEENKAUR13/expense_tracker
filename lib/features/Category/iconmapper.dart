import 'package:flutter/material.dart';

/// Maps icon_name strings to actual Flutter IconData
class IconMapper {
  static IconData getIcon(String iconName) {
    switch (iconName.toLowerCase()) {
    // Category icons
      case 'restaurant':
        return Icons.restaurant;
      case 'shopping_bag':
        return Icons.shopping_bag;
      case 'directions_car':
        return Icons.directions_car;
      case 'payments':
        return Icons.payments;
      case 'movie':
        return Icons.movie;
      case 'category':
        return Icons.category;

    // Add more icons as needed
      default:
        return Icons.category; // Fallback icon
    }
  }
}