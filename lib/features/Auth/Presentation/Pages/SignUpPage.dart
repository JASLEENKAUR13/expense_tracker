import 'package:expense_tracker/features/Auth/Presentation/Pages/emailverificationScreen.dart';
import 'package:expense_tracker/features/Auth/Presentation/Widgets/textfield.dart';
import 'package:expense_tracker/features/Auth/Presentation/authwrapper.dart';
import 'package:expense_tracker/features/Auth/Services/AuthServices.dart';
import 'package:expense_tracker/common/theme/AppPallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

  bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  void doSignUpwithEmail() async {
    final email = signUpemailcontroller.text.trim();
    final pass = signUppasscontroller.text.trim();

    // ✅ Check empty FIRST, then format
    if (email.isEmpty || pass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Input Required Details!")),
      );
      return;
    }

    if (!isValidEmail(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter a valid email address")),
      );
      return;
    }

    try {
      final user = await auth_services.signUpWithEmail(email, pass);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Verification email sent. Please check inbox.",
          ),
        ),
      );
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const AuthWrapper()),
            (route) => false, // ✅ clears entire stack
      );




      print("Signed up! ID: ${user?.id}");
    } catch (e) {
      if (mounted) {
        String message = "Sign up failed. Please try again.";

        if (e is AuthWeakPasswordException) {
          message = "Weak password! Use at least 6 characters.";
        } else if (e.toString().contains('rate_limit') ||
            e.toString().contains('40 seconds')) {
          message = "Please wait 40 seconds before trying again.";
        } else if (e.toString().contains('already registered')) {
          message = "Email already registered. Try signing in!";
        } else if (e.toString().contains('invalid email')) {
          message = "Invalid email format.";
        } else if (e.toString().contains('invalid password')) {
          message = "Invalid Password.";
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
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
      backgroundColor: AppPallete.textPrimary,  // ✅ no Container needed
      body: SafeArea(                            // ✅ no GestureDetector needed
        child: Center(

          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
            child: Column(

              crossAxisAlignment: CrossAxisAlignment.start, // ✅ cleaner than Align
              children: [
                SizedBox(height: 60.h),

                Text(
                  "SIGN UP.",
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
                  controller: signUpemailcontroller,
                  isPassword: false,
                ),

                SizedBox(height: 20.h),

                AuthTextField(
                  mylabel: "Enter Password",
                  myIcon: Icons.lock,
                  controller: signUppasscontroller,
                  isPassword: true,
                ),

                SizedBox(height: 28.h),

                Center(
                  child: ElevatedButton(
                    onPressed: doSignUpwithEmail,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppPallete.cardWhite,
                      foregroundColor: AppPallete.textPrimary,
                      padding: EdgeInsets.all(14.w), // ✅ EdgeInsets not EdgeInsetsGeometry
                      shape: const CircleBorder(),
                      elevation: 10,
                    ),
                    child: Icon(Icons.arrow_right_alt_rounded, size: 28.sp),
                  ),
                ),

                SizedBox(height: 28.h),

                const Divider(),

                SizedBox(height: 20.h),

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
                    mainAxisAlignment: MainAxisAlignment.center, // ✅ center not spaceAround
                    children: [
                      Image.asset(
                        'lib/common/theme/icons/google.png',
                        color: AppPallete.textPrimary,
                        height: 24.h,
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
                      "Already a Saver? Sign In",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 13.sp,
                        color: AppPallete.cardWhite,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 40.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}