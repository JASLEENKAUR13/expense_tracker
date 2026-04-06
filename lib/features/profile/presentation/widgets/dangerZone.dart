import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../common/Widgets/AlertDialogBox.dart';
import '../../../../common/theme/AppPallete.dart';
import '../../../Auth/Presentation/authwrapper.dart';
import '../../../Expense/provider/ExpenseListProvider.dart';
import '../../Services/profile_services.dart';
import '../../provider/profile_provider.dart';

Container dangerZone(BuildContext context ,WidgetRef ref ) {
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
          
          onTap: ()  async {
            // sign out logic here

            final confirm = await AlertDialogBox(
              context,
              "Sign Out",
              "Are you sure you want to sign out?",
              "Sign Out"

            );
            if(confirm == true){
              await Supabase.instance.client.auth.signOut();
              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const AuthWrapper()),
                      (route) => false, // 👈 removes ALL routes below
                );
              }

              print("Logged out!");

            }



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
          onTap: ()  async{
            final confirm = await AlertDialogBox(
                context,
                "Delete Account",
                "Are you sure you want to Delete your account?",
                "Delete"

            );

            if (confirm == true) {
              // 2. delete everything
              await ProfileServices().deleteAccount();
              await Supabase.instance.client.auth.signOut();

              // 3. clear navigation stack → go to auth
              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const AuthWrapper()),
                      (route) => false,
                );
              }

              print("account deleted");
            }




          },
        ),
      ],
    ),
  );
}