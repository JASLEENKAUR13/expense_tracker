
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../common/theme/AppPallete.dart';

class FieldCard extends StatelessWidget {
  final String label;
  final Widget child;
  final Widget? trailing;

  FieldCard({
    required this.label,
    required this.child,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:  EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: AppPallete.cardWhite.withOpacity(0.08),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: AppPallete.cardWhite.withOpacity(0.12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: AppPallete.background.withOpacity(0.5),
                  letterSpacing: 0.5.w,
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
          SizedBox(height: 10.h),
          child,
        ],
      ),
    );
  }
}