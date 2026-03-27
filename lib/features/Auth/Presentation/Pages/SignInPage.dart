

import 'package:expense_tracker/features/Auth/Presentation/Widgets/textfield.dart';

import 'package:expense_tracker/common/theme/AppPallete.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';


import '../../Services/AuthServices.dart';



class SignInPage extends ConsumerStatefulWidget {
  final VoidCallback onSwitch;
  const SignInPage({super.key, required this.onSwitch});

  @override
  ConsumerState<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends ConsumerState<SignInPage> {


  final TextEditingController signInemailcontroller = TextEditingController();
  final TextEditingController signInpasscontroller = TextEditingController();
  final auth_services = Authservices();






  void doSignInwithEmail() async {

    if(signInemailcontroller.text.isEmpty || signInpasscontroller.text.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Input Required Details !")),
      );
      return;

    }

    final email = signInemailcontroller.text.trim();
    final pass = signInpasscontroller.text.trim();

    try{

        await auth_services.signInWithEmail(email, pass);
        print("Signed in successfully!");






    }catch(e){
      print("Sign in error: $e");

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Sign in failed: $e")),
        );
      }

    }


  }

  @override
  void dispose() {
    signInemailcontroller.dispose();
    signInpasscontroller.dispose();
    super.dispose();
  }









  @override
  Widget build(BuildContext context) {

    return Scaffold(
       // resizeToAvoidBottomInset: false,
      body:GestureDetector(



        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration:const  BoxDecoration(

            color: AppPallete.textPrimary,


          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Padding(padding: EdgeInsetsGeometry.all(16),
               child : Column(
                  mainAxisAlignment:  MainAxisAlignment.center,
                 children: [
                   const SizedBox(height: 60),




                   const SizedBox(height: 40 ,) ,


                   const SizedBox(height: 40) ,
                  Align( alignment: Alignment.centerLeft ,child: Text("SIGN IN." ,
                     style: GoogleFonts.poppins(fontSize: 50 , fontWeight: FontWeight.w800 , color: AppPallete.background , height: 1.1)
                   ,),),
                   const SizedBox(height: 40) ,

                   AuthTextField(mylabel: "Enter Email", myIcon: Icons.email, controller: signInemailcontroller, isPassword: false),
                   const SizedBox(height: 20) ,
                   AuthTextField(mylabel: "Enter Password", myIcon: Icons.lock, controller: signInpasscontroller, isPassword: true),
                   const SizedBox(height: 50) ,

                   ElevatedButton(onPressed: () => doSignInwithEmail(),
                       style: ElevatedButton.styleFrom(
                         backgroundColor: AppPallete.cardWhite,
                         foregroundColor:AppPallete.textPrimary,

                         padding: EdgeInsetsGeometry.all(18),
                         shape: const CircleBorder(),
                         elevation: 10,





                       ),


                        child: const Icon(Icons.arrow_right_alt_rounded , size: 40 , fontWeight: FontWeight.bold,),
            ),

                   const SizedBox(height: 45),
                   ElevatedButton(onPressed: ()async {
                     final res = await auth_services.signInWithGoogle();
                     if (!res && mounted) {
                       ScaffoldMessenger.of(context).showSnackBar(
                         const SnackBar(content: Text("Google Authentication failed!")),
                       );
                     }

                   },
                     style: ButtonStyle(
                         backgroundColor:WidgetStatePropertyAll(AppPallete.cardWhite),
                         foregroundColor:
                         WidgetStatePropertyAll(AppPallete.textPrimary),
                         minimumSize: WidgetStatePropertyAll(const Size(double.infinity, 55)),
                         shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)))


                     ),

                     child:
                     Row(

                       mainAxisAlignment:MainAxisAlignment.spaceAround ,
                       children: [
                         Image.asset('lib/common/theme/icons/google.png' ,
                           color: AppPallete.textPrimary,),
                         Text("Continue With Google" ,
                           style: GoogleFonts.poppins(
                             fontSize: 19,
                             fontWeight: FontWeight.w700,


                           ),
                         )
                       ],
                     ),


                   ) ,

                   const SizedBox(height: 45),



                   TextButton(
                     onPressed: widget.onSwitch,
                     child: Text(
                       "New Saver? Sign Up",
                       style: GoogleFonts.poppins(
                         fontWeight: FontWeight.w600,
                         fontSize: 18,
                         color: AppPallete.cardWhite
                       ),
                     ),
                   ),












                 ]
                )

                  ,
                  ),
            ),
          ),
        ),
      ));
  }
}
