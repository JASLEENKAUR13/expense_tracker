
import 'package:expense_tracker/features/Expense/Presentation/widgets/quickViewCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../common/functions/CurrencyFormater.dart';
import '../../provider/ExpenseListProvider.dart';
import '../../../../common/theme/AppPallete.dart';

class QuickViewContainer extends ConsumerWidget {
   QuickViewContainer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expenses = ref.watch(expenseProvider);
    final balance = ref.watch(budgetProvider);
    final income = ref.watch(incomeProvider);





    return Container(
      height: 200.h,
      width: double.infinity,
      padding:  EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppPallete.primaryBlue,
        borderRadius: BorderRadius.circular(22.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:  EdgeInsets.only(top: 5.h, left: 8.h),
            child: Text(
              "Total Balance",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 20.sp,
                color: Colors.white60,
              ),
            ),
          ),

           SizedBox(height: 7.h),

          Text(
            CurrencyFormatter.compact(balance),         // ✅ live value now
            style: GoogleFonts.poppins(
              fontSize: 42.sp,
              color: Colors.white,
            ),
          ),

           SizedBox(height: 10.h),

          Row(
            children: [
              Expanded(
                child: QuickViewcard(label: 'Income', amount: income, icon: Icons.arrow_upward_sharp,
                  color: AppPallete.incomeGreen,

                ),
              ),
              Expanded(
                child: QuickViewcard(label: "Spent", amount: expenses, icon: Icons.arrow_downward_sharp,
                  color: AppPallete.expenseRed,

                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}