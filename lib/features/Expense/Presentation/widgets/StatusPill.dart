import 'package:flutter/material.dart';
import 'package:expense_tracker/common/theme/AppPallete.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class StatusPill extends StatelessWidget {
  final bool isCredited;
  final Function(bool) onChanged;

  const StatusPill({
    super.key,
    required this.isCredited,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44.h,
      decoration: BoxDecoration(
        color: AppPallete.cardWhite,
        borderRadius: BorderRadius.circular(25.r),
      ),
      child: Row(
        children: [
          // INCOME
          Expanded(
            child: GestureDetector(
              onTap: () => onChanged(true),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: isCredited
                      ? AppPallete.incomeGreen
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(25.r),
                ),
                child: Center(
                  child: Text(
                    "Income",
                    style: GoogleFonts.poppins(
                      fontSize: 13.sp,
                      color: isCredited
                          ? Colors.white
                          : AppPallete.textSecondary,
                      fontWeight: FontWeight.bold,

                    ),
                  ),
                ),
              ),
            ),
          ),

          // EXPENSE
          Expanded(
            child: GestureDetector(
              onTap: () => onChanged(false),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: !isCredited
                      ? AppPallete.expenseRed
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(25.r),
                ),
                child: Center(
                  child: Text(
                    "Expense",
                    style: GoogleFonts.poppins(
                      fontSize: 13.sp,
                      color: !isCredited
                          ? Colors.white
                          : AppPallete.textSecondary,
                      fontWeight: FontWeight.bold,
                    ),
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