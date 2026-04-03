import 'package:expense_tracker/common/functions/CurrencyFormater.dart';
import 'package:expense_tracker/common/theme/AppPallete.dart';
import 'package:expense_tracker/features/Expense/Presentation/pages/editingPage.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../expense.dart';
class ListCard extends StatelessWidget {

  final Expense currentExp;

  const ListCard({super.key , required this.currentExp});



  @override
  Widget build(BuildContext context) {
    return   Card(

          color: AppPallete.cardWhite,
          elevation: 1,
          margin: EdgeInsets.all(8),
         shape: RoundedRectangleBorder(

           borderRadius: BorderRadiusGeometry.circular(10)
         ),
      child: InkWell(
        onTap: () => Navigator.push(context ,
            MaterialPageRoute(builder: (context) => EditingPage( exp: currentExp,))),
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
            child :Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                Container(
                  child : Row (
                children: [
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: AppPallete.primaryBlue.withOpacity(0.25),
                      shape: BoxShape.circle,
                    ),
                    child:

                      currentExp.is_credited? Icon(Icons.arrow_upward_sharp ,color: AppPallete.incomeGreen , size : 20 , fontWeight: FontWeight.bold ):
                      Icon(Icons.arrow_downward_sharp , color : AppPallete.expenseRed, size: 20,fontWeight: FontWeight.bold,),


                  ),

                  const SizedBox(width: 10,) ,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                     Column(
                         mainAxisAlignment: MainAxisAlignment.center,
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [

                       Text(currentExp.title ,
                          style: GoogleFonts.poppins(fontSize: 20 ,
                              fontWeight: FontWeight.w600
                              )),

                       Row(
                         children: [
                           Text( DateFormat('d MMM yyyy').format(currentExp.created_at), style: GoogleFonts.poppins(fontSize: 11 ,
                               fontWeight: FontWeight.w500 , color: AppPallete.textPrimary),) ,


                         ]
                       )






                     ])
                    ],

                  )



              ],
            )




                )  ,


                currentExp.is_credited? Text("+"+ CurrencyFormatter.compact(currentExp.amount), style: GoogleFonts.poppins(fontSize: 20 ,
                    fontWeight: FontWeight.w700 , color : AppPallete.incomeGreen )) :
                Text("-" + CurrencyFormatter.compact(currentExp.amount) ,
                    style: GoogleFonts.poppins(fontSize: 20 ,
                    fontWeight: FontWeight.w700 , color :  AppPallete.expenseRed))
              ],
            )),
      ),





    )

      ;

  }
}
