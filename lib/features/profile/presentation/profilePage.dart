import 'package:expense_tracker/common/functions/CurrencyFormater.dart';
import 'package:expense_tracker/common/theme/AppPallete.dart';
import 'package:expense_tracker/features/profile/presentation/widgets/customizedRow.dart';
import 'package:expense_tracker/features/profile/presentation/widgets/dangerZone.dart';
import 'package:expense_tracker/features/profile/provider/profile_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  final user = Supabase.instance.client.auth.currentUser;
  late final avatarurl = user?.userMetadata?['avatar_url'];
  late final username = user?.userMetadata?['name'] ?? "Unknown" ;
  late final email = user?.email;

  String getInitials(String? name, String? email) {
    if (username != null && username.isNotEmpty
        && username != "Unknown") {
      final parts = username.trim().split(' ');
      if (parts.length >= 2) {
        return '${parts[0][0]}${parts[1][0]}'.toUpperCase(); // "AK"
      }
      return parts[0][0].toUpperCase(); // single name → "A"
    }
    return email?[0].toUpperCase() ?? '?'; // fallback to email first letter
  }

  late final profileasync = ref.watch(profileProvider);










  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title : Text("Profile" , style: GoogleFonts.poppins(
            fontSize: 25 , fontWeight: FontWeight.w500 ,
            color : AppPallete.textPrimary
        ),),
        centerTitle: true,
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.edit))

        ],
      ),

      body: Padding(padding: EdgeInsets.all(8) ,

          child: SingleChildScrollView(
            child: SizedBox(
              width: double.infinity,
              //height: double.infinity,
              child: Column(
            
                crossAxisAlignment: CrossAxisAlignment.center,
            
                children: [
                  SizedBox(height: 17,),
                  CircleAvatar(
                radius: 40,
                backgroundImage: avatarurl != null?
                NetworkImage(avatarurl) : null,
            
                backgroundColor: AppPallete.primaryBlue,
                child: avatarurl == null ? Text(
                getInitials(username, email) , style: GoogleFonts.poppins(
                fontSize: 25 , fontWeight: FontWeight.w500 ,
                ) ): null,
            
            
            
                  ) ,
                  SizedBox(height: 5,),
                   Text(username ?? "Unknown" , style: GoogleFonts.poppins(
                      fontSize: 24 , fontWeight: FontWeight.w500 ,
                      color : AppPallete.textPrimary
                  ),)  ,
                  SizedBox(height: 8,),
                  Text(email! , style: GoogleFonts.poppins(
                      fontSize: 18 , fontWeight: FontWeight.w400 ,
                      color : AppPallete.textPrimary
                  ), ) ,
                  SizedBox(height: 35,),
                 Container(
                   width: double.infinity,
                   padding: EdgeInsets.all(15),
                   decoration: BoxDecoration(
                     color: AppPallete.surface,
                     borderRadius: BorderRadius.circular(10)

                   ),
                   child: Column(
                     //mainAxisAlignment: MainAxisAlignment.start,
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Text("Personal Info" , style: GoogleFonts.poppins(
                         fontWeight: FontWeight.w500 , fontSize: 20 ,
                         color: AppPallete.textPrimary.withOpacity(0.7)

                       ),) ,
                       const SizedBox(height: 5,),
                       CustomizedRow("Name", username, Icons.person) ,
                       Divider(color: AppPallete.textSecondary , thickness: 1) ,
                       CustomizedRow("Email", email! , Icons.email) ,
                       Divider(color: AppPallete.textSecondary , thickness: 1) ,
                       CustomizedRow("Phone", "+91 9876543210", Icons.phone) ,






                     ],
                   ),

                 ) ,



                  SizedBox(height: 15,),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        color: AppPallete.surface,
                        borderRadius: BorderRadius.circular(10)

                    ),
                    child: Column(

                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Finances" , style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500 , fontSize: 20 ,
                            color: AppPallete.textPrimary.withOpacity(0.7)

                        ),) ,
                        const SizedBox(height: 7,),
                        profileasync.when(data: (profile) => Column(
                          children: [
                            CustomizedRow("Monthly Income", CurrencyFormatter.format(profile!.income_montly), Icons.account_balance_wallet) ,
                            Divider(color: AppPallete.textSecondary , thickness: 1) ,
                            CustomizedRow("Saving Goal Percentage", "${profile.savingsGoalPerc}%"  , Icons.savings) ,
                          ],

                        ),
                            error: (e ,_) => Text("Error loading finances"),
                            loading:() => Center(child : CircularProgressIndicator()))









                      ],
                    ),

                  ),
                  SizedBox(height: 15,),
                  dangerZone(context , ref)




                ],
            
              ),
            ),
          ),

      ),
    );
  }
}
