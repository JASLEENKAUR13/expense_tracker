import 'package:expense_tracker/common/functions/CurrencyFormater.dart';
import 'package:expense_tracker/common/theme/AppPallete.dart';
import 'package:expense_tracker/features/Category/provider/CategoryProvider.dart';
import 'package:expense_tracker/features/Expense/Presentation/pages/editingPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../Category/category.dart';
import '../../../Category/iconmapper.dart';
import '../../expense.dart';

class ListCard extends ConsumerWidget {
  final Expense currentExp;
  const ListCard({super.key, required this.currentExp});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoryProvider);

    final Category? matchedCategory = categories
        .where((c) => c.id == currentExp.category_id)
        .isNotEmpty
        ? categories.firstWhere((c) => c.id == currentExp.category_id)
        : null;

    final categoryIcon = matchedCategory != null
        ? IconMapper.getIcon(matchedCategory.icon_name)
        : Icons.category_rounded;

    final categoryColor = matchedCategory?.color_hex != null
        ? Color(int.parse(matchedCategory!.color_hex.replaceFirst('#', '0xff')))
        : AppPallete.primaryBlue;

    final isCredited = currentExp.is_credited;

    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => EditingPage(exp: currentExp)),
      ),
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: AppPallete.cardWhite,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          children: [

            // ── Icon ───────────────────────────────
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: categoryColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Icon(categoryIcon, color: categoryColor, size: 22.sp),
            ),

            SizedBox(width: 14.w),

            // ── Title + subtitle ───────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currentExp.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: AppPallete.textPrimary,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.w, vertical: 2.h),
                        decoration: BoxDecoration(
                          color: categoryColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Text(
                          matchedCategory?.name ?? "Other",
                          style: GoogleFonts.poppins(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w500,
                            color: categoryColor,
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        DateFormat('d MMM').format(currentExp.created_at),
                        style: GoogleFonts.poppins(
                          fontSize: 11.sp,
                          color: AppPallete.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(width: 12.w),

            // ── Amount ─────────────────────────────
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  (isCredited ? "+" : "-") +
                      CurrencyFormatter.compact(currentExp.amount),
                  style: GoogleFonts.poppins(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: isCredited
                        ? AppPallete.incomeGreen
                        : AppPallete.expenseRed,
                  ),
                ),
                SizedBox(height: 3.h),
                Container(
                  padding:
                  EdgeInsets.symmetric(horizontal: 7.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: isCredited
                        ? AppPallete.incomeGreen.withOpacity(0.12)
                        : AppPallete.expenseRed.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    isCredited ? "Income" : "Expense",
                    style: GoogleFonts.poppins(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w500,
                      color: isCredited
                          ? AppPallete.incomeGreen
                          : AppPallete.expenseRed,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}