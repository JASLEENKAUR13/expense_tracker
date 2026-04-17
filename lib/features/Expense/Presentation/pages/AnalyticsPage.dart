import 'package:expense_tracker/features/Category/presentation/categoryPieChart.dart';
import 'package:expense_tracker/features/Expense/Presentation/widgets/MonthlyIncomeExpenseChart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../common/theme/AppPallete.dart';
import '../../provider/ExpenseListProvider.dart';
import '../widgets/monthlySpendingChart.dart';
import '../widgets/weeklyBarChart.dart';
import 'add_expensePage.dart';

class AnalyticsPage extends ConsumerStatefulWidget {
  const AnalyticsPage({super.key});

  @override
  ConsumerState<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends ConsumerState<AnalyticsPage> {


  @override
  @override
  Widget build(BuildContext context) {

    final expenses = ref.watch(ItemListProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Analytics",
          style: GoogleFonts.poppins(
            fontSize: 25,
            fontWeight: FontWeight.w500,
            color: AppPallete.textPrimary,
          ),
        ),
        centerTitle: true,
      ),

      body: expenses.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.analytics_outlined,
                size: 70, color: Colors.grey),

            const SizedBox(height: 16),

            Text(
              "No data to analyze",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              "Add expenses to analyze your spending 📊",
              style: GoogleFonts.poppins(color: Colors.grey),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AddExpensepage(),
                  ),
                );
              },
              child: const Text("Add Expense"),
            ),
          ],
        ),
      )
          : Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const SizedBox(height: 15),

              WeeklyBarChart(),

              const SizedBox(height: 8),

              Text(
                "Category Spending",
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                  color: AppPallete.textPrimary,
                ),
              ),

              const SizedBox(height: 35),

              CategoryPieChart(),

              const SizedBox(height: 35),

              MonthlySpendingChart(),

              const SizedBox(height: 35),

              MonthlyIncomeExpenseChart(),
            ],
          ),
        ),
      ),
    );
  }
}
