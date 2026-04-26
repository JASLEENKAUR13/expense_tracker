import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:riverpod/src/framework.dart';

import '../../../../common/theme/AppPallete.dart';
import '../../provider/ExpenseListProvider.dart';
import '../../provider/weeklySpendingProvider.dart';

class WeeklyBarChart extends ConsumerWidget {
   WeeklyBarChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    String _monthName(int month) {
       const months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      return months[month - 1];
    }

    final weekStart = ref.watch(selectedWeekProvider);
    final weekend = weekStart.add(Duration(days: 6));
    final weeklyData = ref.watch(weeklySpendingProvider(weekStart));
    final now = DateTime.now();
    final isFutureWeek = weekStart.add(Duration(days: 7)).isAfter(now);
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    final maxY = weeklyData.values.isEmpty
        ? 1000.0
        : weeklyData.values
        .reduce((a, b) => a > b ? a : b)
        .toDouble() *
        1.2; // 20% headroom above highest bar

    final bars = days.asMap().entries.map((entry) {
      final index = entry.key;
      final day = entry.value;
      final amount = weeklyData[day] ?? 0;

      return BarChartGroupData(
        x: index,

        barRods: [
          BarChartRodData(
            toY: amount.toDouble(),
            color: AppPallete.primaryBlue,
            width: 14.w,
            borderRadius: BorderRadius.circular(6.r),
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
            "Weekly Spending",
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold , fontSize: 14.sp,),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [




              IconButton(
                onPressed: () {
                  ref.read(selectedWeekProvider.notifier).state =
                      weekStart.subtract(Duration(days: 7));
                },
                icon: Icon(Icons.arrow_back_ios),
              ),

              Text(
                "${weekStart.day} ${_monthName(weekStart.month)} - "
                    "${weekend.day} ${_monthName(weekend.month)}",


                style: GoogleFonts.poppins(
                    fontSize: 12.sp, // add this
                    fontWeight: FontWeight.bold
                ),

              ),


              IconButton(
                onPressed: () { isFutureWeek ? null :
                  ref.read(selectedWeekProvider.notifier).state =
                      weekStart.add(Duration(days: 7));
                },
                icon: Icon(Icons.arrow_forward_ios),
              ),





            ],
          ),

           SizedBox(height: 12.h),
          SizedBox(
            height: 200.h,
            child: BarChart(
              BarChartData(
                maxY: maxY,
                barGroups: bars,
                gridData: FlGridData(show: false),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          days[value.toInt()],
                          style: GoogleFonts.poppins(
                            fontSize: 12.sp,
                            color: AppPallete.textPrimary,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        '₹${rod.toY.toInt()}',
                        GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

