import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../provider/MontlySpendingProvider.dart';
import '../../../../common/theme/AppPallete.dart';

class MonthlySpendingChart extends ConsumerStatefulWidget {
  const MonthlySpendingChart({super.key});

  @override
  ConsumerState<MonthlySpendingChart> createState() =>
      _MonthlySpendingChartState();
}

class _MonthlySpendingChartState
    extends ConsumerState<MonthlySpendingChart> {

  final months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];

  @override
  Widget build(BuildContext context) {
    final monthlyData = ref.watch(monthlySpendingProvider);

    final spots = months.asMap().entries.map((entry) {
      final index = entry.key;
      final month = entry.value;
      final amount = monthlyData[month] ?? 0;

      return FlSpot(index.toDouble(), amount.toDouble());
    }).toList();

    final maxY = monthlyData.values.isEmpty
        ? 1000
        : monthlyData.values.reduce((a, b) => a > b ? a : b) * 1.2;

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
            "Monthly Spending",
            style: GoogleFonts.poppins(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: AppPallete.textPrimary,
            ),
          ),
          SizedBox(height: 20.h),

          SizedBox(
            height: 220,
            child: LineChart(
              LineChartData(
                minY: -maxY * 0.1, // 🔥 FIX: bottom spacing
                maxY: maxY.toDouble(),

                clipData: FlClipData.all(),
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
                      reservedSize: 28.w,
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();

                        if (index % 2 != 0) return const SizedBox();

                        return Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            months[index],
                            style: GoogleFonts.poppins(
                              fontSize: 10.sp,
                              color: AppPallete.textPrimary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                lineTouchData: LineTouchData(
                  handleBuiltInTouches: true,
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipItems: (spots) {
                      return spots.map((spot) {
                        return LineTooltipItem(
                          '₹${spot.y.toInt()}',
                          const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),

                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    curveSmoothness: 0.35,
                    color: AppPallete.primaryBlue,
                    barWidth: 3,

                    // 🔥 Hide zero dots
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        if (spot.y == 0) {
                          return FlDotCirclePainter(radius: 0);
                        }

                        return FlDotCirclePainter(
                          radius: 4.r,
                          color: AppPallete.primaryBlue,
                          strokeWidth: 1.w,
                          strokeColor: Colors.white,
                        );
                      },
                    ),

                    // 🔥 Softer gradient
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          AppPallete.primaryBlue.withOpacity(0.15),
                          Colors.transparent,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}