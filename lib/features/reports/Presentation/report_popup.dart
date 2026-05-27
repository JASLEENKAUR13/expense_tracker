import 'package:expense_tracker/common/theme/AppPallete.dart';
import 'package:expense_tracker/features/reports/Presentation/report_bottomSheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Services/report_services.dart';


class ReportPopup extends StatelessWidget {
  final int reportId;
  final String htmlContent;
  final String weekStart;
  final String weekEnd;

  const ReportPopup({
    super.key,
    required this.reportId,
    required this.htmlContent,
    required this.weekStart,
    required this.weekEnd,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppPallete.textPrimary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      title:  Row(
        children: [
          Icon(Icons.bar_chart_rounded, color: AppPallete.cardWhite),
          SizedBox(width: 8.w),
          Text('Weekly Report Ready' , style: GoogleFonts.poppins(color: AppPallete.cardWhite , fontSize: 15.sp ,
              fontWeight: FontWeight.w400),),
        ],
      ),
      content: Text(
        'Your expense report for $weekStart – $weekEnd is ready to view.',
        style:  GoogleFonts.poppins(fontSize: 13.sp , color: AppPallete.cardWhite),
      ),
      actions: [
        // Later button — snooze until tomorrow
        TextButton(
          onPressed: () async {
            await snoozeReportUntilTomorrow();
            if (context.mounted) Navigator.of(context).pop();
          },
          child:  Text('Later', style: GoogleFonts.poppins(color: AppPallete.cardWhite)),
        ),

        // View Report button — open bottom sheet
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppPallete.iconBackground,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop(); // close dialog
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => ReportBottomSheet(
                reportId: reportId,
                htmlContent: htmlContent,
              ),
            );
          },
          child: Text(
            'View Report',
            style: GoogleFonts.poppins(color: AppPallete.textPrimary),
          ),
        ),
      ],
    );
  }
}