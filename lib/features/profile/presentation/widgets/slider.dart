import 'package:expense_tracker/common/theme/AppPallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class MySlider extends ConsumerWidget {
  final double myvalue;
  final Function(double) onchanged;

  const MySlider({super.key, required this.myvalue, required this.onchanged});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 6,
            activeTrackColor: AppPallete.primaryBlue,
            inactiveTrackColor: AppPallete.cardWhite,
            thumbColor: AppPallete.primaryBlue,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
            trackShape: const RoundedRectSliderTrackShape(),
          ),
          child: Slider(
            min: 0,
            max: 50,
            value: myvalue,
            onChanged: onchanged,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("0%", style: _labelStyle()),
              Text("25%", style: _labelStyle()),
              Text("50%", style: _labelStyle()),
            ],
          ),
        ),
      ],
    );
  }

  TextStyle _labelStyle() => GoogleFonts.poppins(
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
    color: AppPallete.textPrimary,
  );
}