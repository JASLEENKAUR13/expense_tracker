import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../common/theme/AppPallete.dart';
import '../provider/CategoryProvider.dart';
import '../../Expense/provider/ExpenseListProvider.dart';
import '../provider/catrgorySpendingProvider.dart';

class CategoryPieChart extends ConsumerWidget {
  const CategoryPieChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categorySpending = ref.watch(categorySpendingProvider); // map {id: amount}
    final categories = ref.watch(categoryProvider);               // list of Category objects

    if (categorySpending.isEmpty) {
      return const Center(child: Text("No expenses yet"));
    }

    // Build pie sections
    final sections = categorySpending.entries.map((entry) {
      final category = categories.firstWhere(
            (c) => c.id == entry.key,
        orElse: () => categories.first,
      );

      final total = categorySpending.values.fold(0, (a, b) => a + b);
      final percentage = (entry.value / total) * 100;

      return PieChartSectionData(
        value: entry.value.toDouble(),
        title: '${percentage.toStringAsFixed(1)}%',
        radius: 80,
        titleStyle: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        color: Color(int.parse('0xFF${category.color_hex.replaceAll('#', '')}')),
      );
    }).toList();

    // Build legend
    final legend = categorySpending.entries.map((entry) {
      final category = categories.firstWhere(
            (c) => c.id == entry.key,
        orElse: () => categories.first,
      );

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4 , horizontal: 8),
        child: Row(
          children: [
            Container(
              width: 12, height: 12,
              decoration: BoxDecoration(
                color: Color(int.parse('0xFF${category.color_hex.replaceAll('#', '')}')),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(category.name,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: AppPallete.textPrimary,
                )),
            const Spacer(),
            Text('₹${entry.value}',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppPallete.textPrimary,
                )),
          ],
        ),
      );
    }).toList();

    return Column(
      children: [
        SizedBox(
          height: 220,
          child: PieChart(PieChartData(
            sections: sections,
            sectionsSpace: 2,
            centerSpaceRadius: 40,
          )),
        ),
        const SizedBox(height: 20),
        ...legend,
      ],
    );
  }
}