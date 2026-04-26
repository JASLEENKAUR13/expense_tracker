import 'package:expense_tracker/common/theme/AppPallete.dart';
import 'package:expense_tracker/features/Auth/Presentation/Pages/emailverificationScreen.dart';
import 'package:expense_tracker/features/Auth/Presentation/Widgets/textfield.dart';
import 'package:expense_tracker/features/Auth/Services/AuthServices.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../authwrapper.dart';

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
    if (signInemailcontroller.text.isEmpty || signInpasscontroller.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Input Required Details!")),
      );
      return;
    }

    final email = signInemailcontroller.text.trim();
    final pass = signInpasscontroller.text.trim();

    try {
      await auth_services.signInWithEmail(email, pass);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const AuthWrapper(),
        ),
      );
    } catch (e) {
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
      backgroundColor: AppPallete.textPrimary,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
            child: Column(

              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 32.h),

                Text(
                  "SIGN IN.",
                  style: GoogleFonts.poppins(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w800,
                    color: AppPallete.background,
                    height: 1.1,
                  ),
                ),

                SizedBox(height: 28.h),

                AuthTextField(
                  mylabel: "Enter Email",
                  myIcon: Icons.email,
                  controller: signInemailcontroller,
                  isPassword: false,
                ),

                SizedBox(height: 20.h),

                AuthTextField(
                  mylabel: "Enter Password",
                  myIcon: Icons.lock,
                  controller: signInpasscontroller,
                  isPassword: true,
                ),

                SizedBox(height: 28.h),

                // Arrow button centered
                Center(
                  child: ElevatedButton(
                    onPressed: doSignInwithEmail,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppPallete.cardWhite,
                      foregroundColor: AppPallete.textPrimary,
                      padding: EdgeInsets.all(14.w),
                      shape: const CircleBorder(),
                      elevation: 10,
                    ),
                    child: Icon(Icons.arrow_right_alt_rounded, size: 28.sp),
                  ),
                ),

                SizedBox(height: 28.h),

                // Google button
                ElevatedButton(
                  onPressed: () async {
                    final res = await auth_services.signInWithGoogle();
                    if (!res && mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Google Authentication failed!")),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppPallete.cardWhite,
                    foregroundColor: AppPallete.textPrimary,
                    minimumSize: Size(double.infinity, 48.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.r),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'lib/common/theme/icons/google.png',
                        height: 24.h,
                        color: AppPallete.textPrimary,
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        "Continue With Google",
                        style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20.h),

                Center(
                  child: TextButton(
                    onPressed: widget.onSwitch,
                    child: Text(
                      "New Saver? Sign Up",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 13.sp,
                        color: AppPallete.cardWhite,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}