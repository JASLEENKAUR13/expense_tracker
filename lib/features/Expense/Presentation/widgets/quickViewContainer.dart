
import 'package:expense_tracker/features/Expense/Presentation/widgets/quickViewCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../common/functions/CurrencyFormater.dart';

import '../../../../common/theme/AppPallete.dart';
import '../../Services/BudgetPeriod.dart';
import '../../provider/ExpenseListProvider.dart';
import '../../../../features/profile/provider/profile_provider.dart';

class QuickViewContainer extends ConsumerWidget {
  const QuickViewContainer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expenses = ref.watch(currentExpenseProvider);
    final balance = ref.watch(currentBudgetProvider);
    final income = ref.watch(currentIncomeProvider);
    final profileAsync = ref.watch(profileProvider);

    // ✅ Get current period label e.g. "APRIL 2025"
    final periodLabel = profileAsync.when(
      data: (profile) {
        if (profile == null) return '';
        final period = getCurrentBudgetPeriod(profile.salary_day);
        return DateFormat('MMMM yyyy').format(period.start).toUpperCase();
      },
      loading: () => '',
      error: (_, __) => '',
    );

    final isNegative = balance < 0;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(22.w),
      decoration: BoxDecoration(
        color: AppPallete.iconBackground,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: Colors.white.withOpacity(0.07),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ── Period label + indicator ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  periodLabel,
                  style: GoogleFonts.poppins(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white54,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              Container(
                width: 8.w,
                height: 8.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isNegative
                      ? AppPallete.expenseRed
                      : AppPallete.incomeGreen,
                  boxShadow: [
                    BoxShadow(
                      color: (isNegative
                          ? AppPallete.expenseRed
                          : AppPallete.incomeGreen)
                          .withOpacity(0.5),
                      blurRadius: 6,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          // ── Label ──
          Text(
            "Total Balance",
            style: GoogleFonts.poppins(
              fontSize: 13.sp,
              color: Colors.white38,
              fontWeight: FontWeight.w500,
            ),
          ),

          SizedBox(height: 4.h),

          Text(
            isNegative
                ? "You've exceeded your budget by"
                : "You're within budget",
            style: GoogleFonts.poppins(
              fontSize: 12.sp,
              color: isNegative
                  ? AppPallete.expenseRed.withOpacity(0.8)
                  : Colors.white30,
            ),
          ),

          SizedBox(height: 4.h),

          // ── Balance ──
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Flexible(
                child: Text(
                  CurrencyFormatter.compact(balance.abs()),
                  style: GoogleFonts.poppins(
                    fontSize: 40.sp,
                    fontWeight: FontWeight.w700,
                    color: isNegative
                        ? AppPallete.expenseRed
                        : Colors.white,
                    height: 1.1,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),



          // ── Status message ──


          SizedBox(height: 20.h),

          // ── Divider ──
          Container(
            height: 1,
            color: Colors.white.withOpacity(0.07),
          ),

          SizedBox(height: 20.h),

          // ── Income & Spent ──
          Row(
            children: [
              Expanded(
                child: QuickViewCard(
                  'Income',
                   income,
                   Icons.arrow_upward_rounded,
                   AppPallete.incomeGreen,
                ),
              ),
              Container(
                width: 1,
                height: 44.h,
                color: Colors.white.withOpacity(0.07),
              ),
              Expanded(
                child: QuickViewCard(
                  'Spent',
                  expenses,
                  Icons.arrow_downward_rounded,
                   AppPallete.expenseRed,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
