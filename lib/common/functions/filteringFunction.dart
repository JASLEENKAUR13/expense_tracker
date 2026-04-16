import 'package:intl/intl.dart';

import '../../features/Expense/expense.dart';



class filteringFun{

  Map<String, List<Expense>> groupByDate(List<Expense> expenses) {
    final Map<String, List<Expense>> grouped = {};

    for (final expense in expenses) {
      final key = DateFormat('d MMM yyyy').format(expense.created_at);

      if (grouped[key] == null) grouped[key] = [];
      grouped[key]!.add(expense);
    }

    return grouped;
  }

  List<Expense> filteredList(selectedFilter, selectedCategory, list) {
    return list.where((e) {
      // Filter by Income/Expense
      bool passesStatusFilter = selectedFilter == "All" ||
          (selectedFilter == "Income" ? e.is_credited : !e.is_credited);

      // Filter by Category
      bool passesCategoryFilter =
          selectedCategory == null || e.category_id == selectedCategory;

      // Return true only if BOTH filters pass
      return passesStatusFilter && passesCategoryFilter;
    }).toList();
  }


}