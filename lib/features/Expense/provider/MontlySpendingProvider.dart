import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'ExpenseListProvider.dart';

final monthlySpendingProvider = Provider<Map<String, int>>((ref) {
  final list = ref.watch(ItemListProvider);

  final Map<String, int> monthlySpending = {};

  for (final expense in list) {
    if (expense.is_credited) continue;

    final month = DateFormat('MMM').format(expense.created_at);

    monthlySpending[month] =
        (monthlySpending[month] ?? 0) + expense.amount;
  }

  return monthlySpending;
});