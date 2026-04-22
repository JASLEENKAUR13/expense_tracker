import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../common/theme/AppPallete.dart';

class FilterSheet extends ConsumerStatefulWidget {
  final String currentFilter; //
  const FilterSheet({super.key, required this.currentFilter});

  @override
  ConsumerState<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends ConsumerState<FilterSheet> {
  late String selectedType = widget.currentFilter;


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Filters", style: GoogleFonts.poppins(
              fontSize: 22.sp, fontWeight: FontWeight.w600,
              color: AppPallete.textPrimary
          )),
          SizedBox(height: 20.h),
          Row(
            children: ["All", "Income", "Expense"].map((type) {
              final isSelected = selectedType == type;
              return GestureDetector(
                onTap: () => setState(() => selectedType = type),
                child: Container(
                  margin: EdgeInsets.only(right: 8.w),
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: isSelected ? AppPallete.primaryBlue : AppPallete.surface,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(type, style: GoogleFonts.poppins(
                    fontSize: 13.sp, fontWeight: FontWeight.w500,
                    color: isSelected ? Colors.white : AppPallete.textPrimary,
                  )),
                ),
              );
            }).toList(),
          ),

          SizedBox(height: 30.h),

          // Apply button
          SizedBox(
            width: double.infinity,
            height: 50.h,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context, selectedType),

              style: ElevatedButton.styleFrom(
                  backgroundColor: AppPallete.primaryBlue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r))
              ),
              child: Text("Apply", style: GoogleFonts.poppins(
                  color: Colors.white, fontWeight: FontWeight.w600
              )),
            ),
          ),
          SizedBox(height: 20.h),

        ],
      ),
    );
  }
}