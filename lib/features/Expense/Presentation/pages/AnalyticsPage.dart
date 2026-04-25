import 'package:expense_tracker/features/Category/presentation/categoryPieChart.dart';
import 'package:expense_tracker/features/Expense/Presentation/widgets/MonthlyIncomeExpenseChart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../common/theme/AppPallete.dart';
import '../../provider/ExpenseListProvider.dart';
import '../widgets/monthlySpendingChart.dart';
import '../widgets/weeklyBarChart.dart';
import 'add_expensePage.dart';

class AnalyticsPage extends ConsumerStatefulWidget {
   AnalyticsPage({super.key});

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
            fontSize: 25.sp,
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
                size: 70.w, color: Colors.grey),

             SizedBox(height: 16.h),

            Text(
              "No data to analyze",
              style: GoogleFonts.poppins(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),

             SizedBox(height: 8.h),

            Text(
              "Add expenses to analyze your spending 📊",
              style: GoogleFonts.poppins(color: Colors.grey),
              textAlign: TextAlign.center,
            ),

             SizedBox(height: 20.h),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>  AddExpensepage(),
                  ),
                );
              },
              child:  Text("Add Expense"),
            ),
          ],
        ),
      )
          : Padding(
        padding:  EdgeInsets.all(8.0.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

               SizedBox(height: 15.h),

              WeeklyBarChart(),





               SizedBox(height: 35.h),

              CategoryPieChart(),

               SizedBox(height: 35.h),

              MonthlySpendingChart(),

               SizedBox(height: 35.h),

              MonthlyIncomeExpenseChart(),
            ],
          ),
        ),
      ),
    );
  }
}
