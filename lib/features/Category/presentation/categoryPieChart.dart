import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../common/theme/AppPallete.dart';
import '../../Expense/Services/BudgetPeriod.dart';
import '../../profile/provider/profile_provider.dart';
import '../provider/CategoryProvider.dart';
import '../provider/catrgorySpendingProvider.dart';
import '../category.dart';

class CategoryPieChart extends ConsumerWidget {
  CategoryPieChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categorySpending = ref.watch(categorySpendingProvider);
    final categories = ref.watch(categoryProvider);

    // ✅ Period label — calculated ONCE here, not inside loop
    final profileAsync = ref.watch(profileProvider);
    final periodLabel = profileAsync.when(
      data: (profile) {
        if (profile == null) return '';
        final period = getCurrentBudgetPeriod(profile.salary_day);
        return DateFormat('MMMM yyyy').format(period.start).toUpperCase();
      },
      loading: () => '',
      error: (_, __) => '',
    );

    if (categories.isEmpty) {
      return Center(child: Text("No categories available"));
    }

    if (categorySpending.isEmpty) {
      return Center(child: Text("Add expense to analyze your spending"));
    }

    final total = categorySpending.values.fold(0, (a, b) => a + b);

    if (total == 0) {
      return Center(child: Text("No meaningful data"));
    }

    Category getCategory(int id) {
      try {
        return categories.firstWhere((c) => c.id == id);
      } catch (_) {
        return Category(
          id: -1,
          name: "Other",
          icon_name: "default",
          color_hex: "#888888",
          created_at: DateTime.now(),
        );
      }
    }

    final sections = categorySpending.entries.map((entry) {
      final category = getCategory(entry.key);
      final percentage = (entry.value / total) * 100;

      return PieChartSectionData(
        value: entry.value.toDouble(),
        title: '${percentage.toStringAsFixed(1)}%',
        radius: 50.r,
        titleStyle: GoogleFonts.poppins(
          fontSize: 12.sp,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        color: Color(
          int.parse('0xFF${category.color_hex.replaceAll('#', '')}'),
        ),
      );
    }).toList();

    final legend = categorySpending.entries.map((entry) {
      final category = getCategory(entry.key);

      return Padding(
        padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
        child: Row(
          children: [
            Container(
              width: 12.w,
              height: 12.h,
              decoration: BoxDecoration(
                color: Color(
                  int.parse('0xFF${category.color_hex.replaceAll('#', '')}'),
                ),
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                category.name,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  fontSize: 13.sp,
                  color: AppPallete.textPrimary,
                ),
              ),
            ),
            Text(
              '₹${entry.value}',
              style: GoogleFonts.poppins(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: AppPallete.textPrimary,
              ),
            ),
          ],
        ),
      );
    }).toList();

    return Column(
      children: [

        // ✅ Period label row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Category Spending",
              style: GoogleFonts.poppins(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppPallete.textPrimary,
              ),
            ),
            if (periodLabel.isNotEmpty)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppPallete.iconBackground,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  periodLabel,
                  style: GoogleFonts.poppins(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white54,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
          ],
        ),

        SizedBox(height: 16.h),

        // ✅ Pie chart
        SizedBox(
          height: 180.h,
          child: PieChart(
            PieChartData(
              sections: sections,
              sectionsSpace: 2.w,
              centerSpaceRadius: 36.r,
            ),
          ),
        ),

        SizedBox(height: 20.h),

        // ✅ Legend
        ...legend,
      ],
    );
  }
}