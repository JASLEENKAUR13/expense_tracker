
import 'package:expense_tracker/features/Auth/Presentation/Widgets/textfield.dart';
import 'package:expense_tracker/features/Auth/Services/AuthServices.dart';

import 'package:expense_tracker/common/theme/AppPallete.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';






class SignUpPage extends ConsumerStatefulWidget {
  final VoidCallback onSwitch;

  const SignUpPage({super.key, required this.onSwitch});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  final TextEditingController signUpemailcontroller = TextEditingController();
  final TextEditingController signUppasscontroller = TextEditingController();
  final auth_services = Authservices();






  void doSignUpwithEmail() async {

    if(signUpemailcontroller.text.isEmpty || signUppasscontroller.text.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Input Required Details !")),
      );
      return;

    }

    final email = signUpemailcontroller.text.trim();
    final pass = signUppasscontroller.text.trim();

    try{

        await auth_services.signUpWithEmail(email, pass);
        print("signed Up !");

    } catch (e) {
      print("ERROR CAUGHT: $e");
  if (mounted) {

    print("ERROR CAUGHT: $e");
    if (mounted) {
      String message = "Sign up failed. Please try again.";

      if (e is AuthWeakPasswordException) {
        message = "Weak password! Use at least 6 characters with letters and numbers.";
      } else if (e.toString().contains('rate_limit') ||
          e.toString().contains('40 seconds')) {
        message = "Please wait 40 seconds before trying again.";
      } else if (e.toString().contains('already registered')) {
        message = "This email is already registered. Try signing in!";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }
  }


  }

  @override
  void dispose() {
    signUpemailcontroller.dispose();
    signUppasscontroller.dispose();
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








                        const SizedBox(height: 40) ,
                        Align( alignment: Alignment.centerLeft ,child: Text("SIGN UP." ,
                          style: GoogleFonts.poppins(fontSize: 50 , fontWeight: FontWeight.w800 , color: AppPallete.background , height: 1.1)
                          ,),),
                        const SizedBox(height: 40) ,

                        AuthTextField(mylabel: "Enter Email", myIcon: Icons.email, controller: signUpemailcontroller, isPassword: false),
                        const SizedBox(height: 20) ,
                        AuthTextField(mylabel: "Enter Password", myIcon: Icons.lock, controller: signUppasscontroller, isPassword: true),
                        const SizedBox(height: 50) ,

                        ElevatedButton(onPressed: ()=> doSignUpwithEmail(),
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
                        const Divider(),
                        const SizedBox(height: 45),
                        ElevatedButton(onPressed: () async {
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
                              shape: WidgetStatePropertyAll(
                                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)))


                          ),

                          child:
                          Row(

                            mainAxisAlignment:MainAxisAlignment.spaceAround ,
                            children: [
                              Image.asset('lib/common/theme/icons/google.png' , color: AppPallete.textPrimary,),
                              Text("Continue With Google" ,
                                style: GoogleFonts.poppins(
                                  fontSize: 19,
                                  fontWeight: FontWeight.w700,


                                ),
                              )
                            ],
                          ),


                        ) ,
                        const SizedBox(height: 40,),

                        TextButton(
                          onPressed: widget.onSwitch,
                          child: Text(
                            "Already a Saver? Sign In",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: AppPallete.cardWhite,
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
