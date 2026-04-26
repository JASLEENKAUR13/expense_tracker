import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../common/theme/AppPallete.dart';
/// 🔹 Row Widget (Professional)
Widget row(String title, String info, IconData icon) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 8.h),
    child: Row(
      children: [
        Container(
          height: 38.h,
          width: 38.h,
          decoration: BoxDecoration(
            color: AppPallete.primaryBlue.withOpacity(0.12),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(
            icon,
            color: AppPallete.primaryBlue,
            size: 20.sp,
          ),
        ),

        SizedBox(width: 14.w),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: AppPallete.textSecondary,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                info,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: AppPallete.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
