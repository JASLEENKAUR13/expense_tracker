import 'package:expense_tracker/common/theme/AppPallete.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../common/functions/filteringFunction.dart';
import '../../../Category/provider/CategoryProvider.dart';
import '../../expense.dart';
import '../../provider/ExpenseListProvider.dart';
import '../widgets/FilterSheet.dart';
import '../widgets/listcard.dart';

class AlltransactionPage extends ConsumerStatefulWidget {
  const AlltransactionPage({super.key});

  @override
  ConsumerState<AlltransactionPage> createState() => _State();
}

class _State extends ConsumerState<AlltransactionPage> {
  String selectedFilter = "All"; // ← default
  int? selectedCategory = null; // ✅ Category filter

  @override
  Widget build(BuildContext context) {
    late final list = ref.watch(ItemListProvider);
    late final categories = ref.watch(categoryProvider);
    late final groupByDate = filteringFun().groupByDate;
    late final filteredList = filteringFun().filteredList;




    // ✅ Filter by BOTH Income/Expense AND Category


    final grouped = groupByDate(filteredList (selectedFilter, selectedCategory, list));

    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text("All Transaction",
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold, fontSize: 24))),

      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ ROW 1: Income/Expense Filter Pills
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: FilterChip(
                      label: Text("All"),
                      selected: selectedFilter == "All",
                      onSelected: (_) {
                        setState(() => selectedFilter = "All");
                      },
                      selectedColor: AppPallete.primaryBlue,
                      backgroundColor: AppPallete.surface,
                      labelStyle: TextStyle(
                        color: selectedFilter == "All"
                            ? Colors.white
                            : AppPallete.textSecondary,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: FilterChip(
                      label: Text("Income"),
                      selected: selectedFilter == "Income",
                      onSelected: (_) {
                        setState(() => selectedFilter = "Income");
                      },
                      selectedColor: AppPallete.incomeGreen,
                      backgroundColor: AppPallete.surface,
                      labelStyle: TextStyle(
                        color: selectedFilter == "Income"
                            ? Colors.white
                            : AppPallete.textSecondary,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: FilterChip(
                      label: Text("Expense"),
                      selected: selectedFilter == "Expense",
                      onSelected: (_) {
                        setState(() => selectedFilter = "Expense");
                      },
                      selectedColor: AppPallete.expenseRed,
                      backgroundColor: AppPallete.surface,
                      labelStyle: TextStyle(
                        color: selectedFilter == "Expense"
                            ? Colors.white
                            : AppPallete.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // ✅ ROW 2: Category Filter Pills
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  // "All Categories" button

                  // Category pills
                  ...categories.map((category) {
                    bool isSelected = selectedCategory == category.id;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: FilterChip(
                        label: Text(category.name),
                        selected: isSelected,
                        onSelected: (_) {
                          setState(() => selectedCategory = category.id);
                        },
                        selectedColor: AppPallete.primaryBlue,
                        backgroundColor: AppPallete.surface,
                        labelStyle: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : AppPallete.textSecondary,
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // ✅ Active Filters Display
            if (selectedFilter != "All" || selectedCategory != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Wrap(
                  spacing: 8,
                  children: [
                    if (selectedFilter != "All")
                      Chip(
                        label: Text(selectedFilter),
                        deleteIcon: Icon(Icons.close, size: 16),
                        onDeleted: () =>
                            setState(() => selectedFilter = "All"),
                        backgroundColor: AppPallete.primaryBlue,
                        labelStyle: GoogleFonts.poppins(
                            color: AppPallete.textPrimary,
                            fontWeight: FontWeight.bold),
                        deleteIconColor: Colors.white,
                      ),
                    if (selectedCategory != null)
                      Chip(
                        label: Text(categories
                            .firstWhere((c) => c.id == selectedCategory)
                            .name),
                        deleteIcon: Icon(Icons.close, size: 16),
                        onDeleted: () =>
                            setState(() => selectedCategory = null),
                        backgroundColor: AppPallete.primaryBlue,
                        labelStyle: GoogleFonts.poppins(
                            color: AppPallete.textPrimary,
                            fontWeight: FontWeight.bold),
                        deleteIconColor: Colors.white,
                      ),
                  ],
                ),
              ),

            // Transaction List
            Expanded(
              child: grouped.isEmpty
                  ? Center(
                child: Text(
                  "No transactions found",
                  style: GoogleFonts.poppins(
                    color: AppPallete.textSecondary,
                    fontSize: 16,
                  ),
                ),
              )
                  : ListView.builder(
                itemCount: grouped.keys.length,
                itemBuilder: (context, index) {
                  final date = grouped.keys.elementAt(index);
                  final transactions = grouped[date]!;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Date header
                      Padding(
                        padding:
                        const EdgeInsets.symmetric(vertical: 8),
                        child: Text(date,
                            style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppPallete.textPrimary
                                    .withOpacity(0.8))),
                      ),

                      // Transactions under this date
                      ...transactions
                          .map((exp) => ListCard(currentExp: exp)),
                    ],
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}