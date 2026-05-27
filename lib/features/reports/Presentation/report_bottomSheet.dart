

import 'package:expense_tracker/common/theme/AppPallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';


import '../Services/report_services.dart';


class ReportBottomSheet extends StatefulWidget {
  final int reportId;
  final String htmlContent;

  const ReportBottomSheet({
    super.key,
    required this.reportId,
    required this.htmlContent,
  });

  @override
  State<ReportBottomSheet> createState() => _ReportBottomSheetState();
}

class _ReportBottomSheetState extends State<ReportBottomSheet> {


  Future<void> _markDone() async {
    await markReportAsRead(widget.reportId);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {


    return Container(
      height:   double.infinity,
      decoration: const BoxDecoration(
        color: AppPallete.cardWhite,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
           SizedBox(height: 32.h),
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: AppPallete.iconBackground,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        SizedBox(height: 12.h),

          // Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                const Icon(Icons.bar_chart_rounded, color: AppPallete.textPrimary),
                 SizedBox(width: 8.w),
                Text(
                  'Weekly Report',
                  style: GoogleFonts.poppins(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
           SizedBox(height: 12.h),
          Divider(height: 1.h),

          // HTML Report WebView
          Expanded(
            child: InAppWebView(
              initialData: InAppWebViewInitialData(
                data: widget.htmlContent,
                mimeType: 'text/html',
                encoding: 'utf-8',
              ),
              initialSettings: InAppWebViewSettings(
                javaScriptEnabled: false,
                disableHorizontalScroll: true,
                cacheEnabled: false,
                clearCache: true,
              ),
            ),
          ),

           Divider(height: 1.h),

          // Bottom buttons
               Padding(
                 padding: EdgeInsets.all(8.0.h),
                 child: TextButton(onPressed: ()=> _markDone(), child: Text("Done , I've read it" , style: GoogleFonts.poppins(
                   fontSize: 18.sp , fontWeight: FontWeight.w500 , color: AppPallete.textPrimary
                 ),)),
               )





        ],
      ),
    );
  }
}