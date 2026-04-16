import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'ExpenseListProvider.dart';

final monthlyIncomeExpenseProvider =
Provider<Map<String, Map<String, int>>>((ref) {
  final list = ref.watch(ItemListProvider);

  final Map<String, Map<String, int>> data = {};

  final months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];

  // initialize all months
  for (var month in months) {
    data[month] = {'income': 0, 'expense': 0};
  }

  for (final item in list) {
    final month = months[item.created_at.month - 1];

    if (item.is_credited) {
      data[month]!['income'] =
          data[month]!['income']! + item.amount;
    } else {
      data[month]!['expense'] =
          data[month]!['expense']! + item.amount;
    }
  }

  return data;
});