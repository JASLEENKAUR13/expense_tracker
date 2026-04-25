import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../Expense/provider/ExpenseListProvider.dart';

final categorySpendingProvider = Provider<Map<int, int>>((ref) {
  final list = ref.watch(currentPeriodExpenseProvider);

  final Map<int, int> spending = {};

  for (final expense in list) {
    if (!expense.is_credited) { // only count debits
      spending[expense.category_id] =
          (spending[expense.category_id] ?? 0) + expense.amount;
    }
  }

  return spending;
});