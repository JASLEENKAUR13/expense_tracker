import 'package:expense_tracker/common/theme/AppPallete.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class  textField extends StatelessWidget {

  final String placeholder;
  final TextEditingController mycontroller;
  final bool isString ;
  final IconData icon ;
  final  int maxLines ;
  final int minLines ;


  const textField({required this.placeholder ,
    required this.mycontroller , required this.isString, required this.icon,this.maxLines = 1 , this.minLines = 1,
    super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: mycontroller,
      keyboardType:  isString? TextInputType.text : TextInputType.number,
      maxLines: maxLines,
      minLines: minLines,



    );

  }
}
