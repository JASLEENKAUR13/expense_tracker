// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// import '../theme/AppPallete.dart';
// import 'CurrencyFormater.dart';
// import 'currencyInputFormatter.dart';
//
// class MoneyTextField extends StatelessWidget {
//   final TextEditingController controller;
//   final String label;
//   final Function(double)? onChanged;
//
//   const MoneyTextField({
//     super.key,
//     required this.controller,
//     required this.label,
//     this.onChanged,
//   });
//
//   double _parse(String text) {
//     return CurrencyFormatter.parse(text);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return TextField(
//       controller: controller,
//       keyboardType: TextInputType.number,
//       style: GoogleFonts.poppins(color: AppPallete.cardWhite),
//
//       inputFormatters: [
//         FilteringTextInputFormatter.digitsOnly,
//         CurrencyInputFormatter(),
//       ],
//
//       onChanged: (val) {
//         if (onChanged != null) {
//           onChanged!(_parse(val));
//         }
//       },
//
//       decoration: InputDecoration(
//         prefixText: "₹ ",
//         prefixStyle: GoogleFonts.poppins(
//           color: AppPallete.iconBackground,
//           fontWeight: FontWeight.w600,
//         ),
//
//         labelText: label,
//         floatingLabelBehavior: FloatingLabelBehavior.always,
//         labelStyle: GoogleFonts.poppins(
//           fontSize: 18,
//           color: AppPallete.iconBackground,
//         ),
//
//         filled: true,
//         fillColor: AppPallete.cardWhite.withOpacity(0.05),
//
//         contentPadding:
//         const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
//
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(
//             color: AppPallete.iconBackground,
//             width: 2,
//           ),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(
//             color: AppPallete.iconBackground,
//             width: 2,
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../theme/AppPallete.dart';
import 'CurrencyFormater.dart';
import 'currencyInputFormatter.dart';

class MoneyTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;

  const MoneyTextField({
    super.key,
    required this.controller,
    required this.label,
  });

  @override
  State<MoneyTextField> createState() => _MoneyTextFieldState();
}

class _MoneyTextFieldState extends State<MoneyTextField> {

  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        final value = CurrencyFormatter.parse(widget.controller.text); // get number from text
        final formatted = NumberFormat('#,##,###', 'en_IN').format(value); // format it
        widget.controller.text = formatted; // put back without ₹
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(

      controller: widget.controller,
      focusNode: _focusNode,
      keyboardType: TextInputType.number,
      style: GoogleFonts.poppins(color: AppPallete.textPrimary),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,  // only allow numbers
        CurrencyInputFormatter(),                // format as they type
      ],
      decoration: InputDecoration(
        prefixText: "₹ ",
            prefixStyle: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,fontSize: 20 )
      )





    );
  }
}