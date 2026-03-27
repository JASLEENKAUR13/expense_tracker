import 'package:flutter/material.dart';

Future<DateTime?> pickDate({
  required BuildContext context,
  DateTime? initialDate,

}) async{


  return await showDatePicker(context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(2000), lastDate: DateTime.now());

}