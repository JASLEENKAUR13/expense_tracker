import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../common/theme/AppPallete.dart';

Widget customizedRow(
    String title,
    String info,
    IconData icon,
    ) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 10.h),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Icon Container (better look)
        Container(
          height: 44.h,
          width: 44.h,
          decoration: BoxDecoration(
            color: AppPallete.primaryBlue.withOpacity(0.12),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(
            icon,
            color: AppPallete.primaryBlue,
            size: 22.sp,
          ),
        ),

        SizedBox(width: 14.w),

        // Text Section
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                  color: AppPallete.textSecondary,
                ),
              ),

              SizedBox(height: 2.h),

              Text(
                info,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  fontSize: 16.sp,
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