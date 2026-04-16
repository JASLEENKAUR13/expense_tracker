import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import 'ExpenseListProvider.dart';

final selectedWeekProvider = StateProvider<DateTime>((ref) {
  final now = DateTime.now();
  return now.subtract(Duration(days: now.weekday - 1));
});

final weeklySpendingProvider = Provider.family<Map<String, int>, DateTime>((ref, weekStart) {
  final list = ref.watch(ItemListProvider);

  final Map<String, int> dailySpending = {
    'Mon': 0, 'Tue': 0, 'Wed': 0,
    'Thu': 0, 'Fri': 0, 'Sat': 0, 'Sun': 0,
  };

  final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  for (final expense in list) {
    if (expense.is_credited) continue;

    final diff = expense.created_at.difference(weekStart).inDays;
    if (diff >= 0 && diff <= 6) {
      final dayLabel = days[expense.created_at.weekday - 1];
      dailySpending[dayLabel] = (dailySpending[dayLabel] ?? 0) + expense.amount;
    }
  }

  return dailySpending;
});