import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../common/theme/AppPallete.dart';

Widget dangerZone(BuildContext context) {
  return Container(
    width: double.infinity,
    padding: EdgeInsets.all(15),
    decoration: BoxDecoration(
      color: Color(0xFF1A0E0E), // dark red tint background
      borderRadius: BorderRadius.circular(10),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "DANGER ZONE",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            letterSpacing: 1.2,
            color: AppPallete.textSecondary,
          ),
        ),
        const SizedBox(height: 10),
        // Sign Out
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(Icons.logout, color: AppPallete.expenseRed),
          title: Text(
            "Sign Out",
            style: GoogleFonts.poppins(
              color:AppPallete.expenseRed,
              fontSize: 18,
            ),
          ),
          
          onTap: () {
            // sign out logic here
          },
        ),
        Divider(color: AppPallete.expenseRed.withOpacity(0.2), thickness: 1),
        // Delete Account
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(Icons.delete_outline, color: AppPallete.expenseRed),
          title: Text(
            "Delete Account",
            style: GoogleFonts.poppins(
              color: AppPallete.expenseRed ,
              fontSize: 18,
            ),
          ),
          onTap: () {
            // delete logic here
          },
        ),
      ],
    ),
  );
}