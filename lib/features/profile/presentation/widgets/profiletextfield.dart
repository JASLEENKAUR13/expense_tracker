import 'package:expense_tracker/common/theme/AppPallete.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class  ProfileTextfield extends StatelessWidget {


  final TextEditingController mycontroller;
  final String label;
  const ProfileTextfield({ required this.mycontroller, required this.label});




  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: mycontroller,
      keyboardType: TextInputType.number,
      style: GoogleFonts.poppins(color: AppPallete.cardWhite),

      decoration: InputDecoration(
        labelText: label ,
        labelStyle: GoogleFonts.poppins(fontSize: 19 ,
            color: AppPallete.iconBackground) ,
        floatingLabelBehavior: FloatingLabelBehavior.always,
       // filled: true,





        filled: true,
        fillColor: AppPallete.cardWhite.withOpacity(0.05),


        contentPadding: EdgeInsets.symmetric(horizontal: 16 , vertical: 20) ,
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12) ,
            borderSide: BorderSide(
              color : AppPallete.iconBackground,
              width: 2,
            )
        ) ,
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12) ,
            borderSide: BorderSide(
              color : AppPallete.iconBackground,
              width: 2,
            )
        ) ,


      ),





    );

  }
}
