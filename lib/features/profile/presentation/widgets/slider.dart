import 'package:expense_tracker/common/theme/AppPallete.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MySlider extends ConsumerStatefulWidget {
  final double myvalue;
  final Function(double) onchanged;




  const MySlider({super.key, required this.myvalue, required this.onchanged});

  @override
  ConsumerState<MySlider> createState() => _MySliderState();
}

class _MySliderState extends ConsumerState<MySlider> {

  @override
  Widget build(BuildContext context) {


    return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [

    /// Title
    Text(
    "Savings Percentage",
    style: GoogleFonts.poppins(
    fontSize: 20,
    fontWeight: FontWeight.w500,
      color: AppPallete.iconBackground
    ),
    ),

    SizedBox(height: 12),

    /// Slider Theme for styling
    SliderTheme(
    data: SliderTheme.of(context).copyWith(
    trackHeight: 6,

    activeTrackColor: AppPallete.iconBackground,
    inactiveTrackColor: AppPallete.cardWhite.withOpacity(0.3),

    thumbColor:AppPallete.iconBackground,
    //overlayColor: AppPallete.cardWhite,

    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),

    trackShape: RoundedRectSliderTrackShape(),
    ),
    child: Slider(
    min: 0,
    max: 50,
    value: widget.myvalue,
    onChanged: widget.onchanged,
    ),
    ),

    /// Labels
    Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
    Text("0%" , style: GoogleFonts.poppins(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: AppPallete.iconBackground,
    ),),
    Text("50%" , style: GoogleFonts.poppins(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: AppPallete.iconBackground,
    ),),
    ],
    ),
    ],
    );


  }
}
