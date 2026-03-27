import 'dart:ffi';

import 'package:expense_tracker/common/theme/AppPallete.dart';
import 'package:flutter/cupertino.dart';

class  StatusPill extends StatelessWidget {

  final bool isCredited;
  const StatusPill({super.key, required this.isCredited});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
          duration: const Duration(milliseconds: 300) ,
        height: 50 ,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color : isCredited? AppPallete.incomeGreen : AppPallete.expenseRed,

        ),
      child: Stack(
        children: [
          AnimatedAlign(alignment: isCredited? Alignment.centerLeft :
          Alignment.centerRight, duration: const Duration(milliseconds: 300),
          child: Container(
            width: 90,
            height: 35,
            margin: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
              color: AppPallete.cardWhite,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Center(
              child: Text(
                isCredited? "Credited" : "Debited",
                style: TextStyle(
                  color: isCredited? AppPallete.incomeGreen : AppPallete.expenseRed,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )

          )
)
        ],
      )
      )


      ;
  }
}
