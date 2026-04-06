import 'package:flutter/material.dart';


import '../../../../common/theme/AppPallete.dart';

class AuthTextField extends StatelessWidget {
  final String mylabel;
  final IconData myIcon;
  final TextEditingController controller;
  final bool isPassword;

  const AuthTextField({super.key, required this.mylabel,
    required this.myIcon, required this.controller,
    required this.isPassword});

  @override
  Widget build(BuildContext context) {
    return TextField(



      controller: controller,
      obscureText: isPassword? true : false,
      style: const TextStyle(color: Colors.white,
          fontSize: 19 , fontWeight: FontWeight.w500),
      cursorColor: AppPallete.textPrimary,

      decoration: InputDecoration(
        hintText: mylabel,
        prefixIcon: Icon(myIcon),
      ),



    );
  }
}
