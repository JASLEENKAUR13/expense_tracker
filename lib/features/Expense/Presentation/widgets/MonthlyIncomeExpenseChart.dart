import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../common/theme/AppPallete.dart';
import '../../provider/montlyIncomeExpensedata.dart';

class MonthlyIncomeExpenseChart extends ConsumerWidget {
  const MonthlyIncomeExpenseChart({super.key});

  final months = const [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(monthlyIncomeExpenseProvider);

    double maxY = 0;

    final barGroups = months.asMap().entries.map((entry) {
      final index = entry.key;
      final month = entry.value;

      final income = data[month]!['income']!;
      final expense = data[month]!['expense']!;

      maxY = [
        maxY,
        income.toDouble(),
        expense.toDouble()
      ].reduce((a, b) => a > b ? a : b);

      return BarChartGroupData(
        x: index,
        barsSpace: 4.w,
        barRods: [
          // 💚 Income
          BarChartRodData(
            toY: income.toDouble(),
            color: AppPallete.incomeGreen,
            width: 8.w,
            borderRadius: BorderRadius.circular(4.r),
          ),

          // ❤️ Expense
          BarChartRodData(
            toY: expense.toDouble(),
            color: AppPallete.expenseRed,
            width: 8.w,
            borderRadius: BorderRadius.circular(4.r),
          ),
        ],
      );
    }).toList();

    return Container(
      padding:  EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppPallete.surface,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Monthly Income vs Expense",
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppPallete.textPrimary,
            ),
          ),
         SizedBox(height: 12.h),

           Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Container(width: 10.w, height: 10.h, color: AppPallete.incomeGreen),
                    SizedBox(width: 4.w),
                    Text("Income"),
                  ],
                ),
                SizedBox(width: 16.sp),
                Row(
                  children: [
                    Container(width: 10.w, height: 10.h, color: AppPallete.expenseRed),
                    SizedBox(width: 4.w),
                    Text("Expense"),
                  ],
                ),
              ],
            ),


          SizedBox(
            height: 220,
            child: BarChart(
              BarChartData(
                maxY: maxY * 1.2,
                gridData: FlGridData(show: false),
                borderData: FlBorderData(show: false),


                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();

                        if (index % 2 != 0) return const SizedBox();

                        return Text(
                          months[index],
                          style:  GoogleFonts.poppins(fontSize: 10.sp ,color: AppPallete.textPrimary  ),
                        );
                      },
                    ),
                  ),
                ),

                barGroups: barGroups,
              ),
            ),
          ),
        ],
      ),
    );
  }
}