
import 'package:expense_tracker/common/theme/AppPallete.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

Widget CustomizedRow(
    String title,
    String info ,
    IconData icon,
    ){

  return Row(

    children: [
      Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10 ) ,
          color : AppPallete.primaryBlue,

        ),

        child: Icon(icon , color: AppPallete.background, size: 24,),



      ) ,
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title , style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500 , fontSize: 14 ,
              color: AppPallete.textPrimary.withOpacity(0.8)


            ),) ,
            Text(info ,  style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500 , fontSize: 20 ,
                color: AppPallete.textPrimary


            ),)
          ],
        ),
      )
    ]


  );

}