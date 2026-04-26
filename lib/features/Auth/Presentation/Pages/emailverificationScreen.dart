import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../authwrapper.dart';

class EmailVerificationScreen extends StatefulWidget {
   EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  bool loading = false;
  StreamSubscription<AuthState>? _authSubscription;

  @override
  void initState() {
    super.initState();

    // ✅ Auto-detect verification — no button needed
    _authSubscription =
        Supabase.instance.client.auth.onAuthStateChange.listen((event) {
          final user = event.session?.user;
          print("🔁 AUTH EVENT: ${event.event}");
          print("✅ emailConfirmedAt: ${user?.emailConfirmedAt}");

          if (user?.emailConfirmedAt != null && mounted) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) =>  AuthWrapper()),
            );
          }
        });
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }

  Future<void> refreshUser() async {
    setState(() => loading = true);

    try {
      await Supabase.instance.client.auth.refreshSession();
      final user = Supabase.instance.client.auth.currentUser;

      print("✅ emailConfirmedAt: ${user?.emailConfirmedAt}");

      if (user?.emailConfirmedAt != null && mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) =>  AuthWrapper()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(
              content: Text("Email not verified yet. Please check inbox!")),
        );
      }
    } catch (e) {
      print("Refresh error: $e");
    }

    setState(() => loading = false);
  }

  Future<void> resendEmail() async {
    final user = Supabase.instance.client.auth.currentUser;

    if (user?.email != null) {
      await Supabase.instance.client.auth.resend(
        type: OtpType.email,
        email: user!.email!,
      );

      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text("Verification email sent again")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final email =
        Supabase.instance.client.auth.currentUser?.email ?? '';

    return Scaffold(
      backgroundColor:  Color(0xFF1A1A2E),
      body: SafeArea(
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ✅ Icon with circle background
              Container(
                width: 100.w,
                height: 100.h,
                decoration: BoxDecoration(
                  color:  Color(0xFF16213E),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.blueAccent.withOpacity(0.4),
                    width: 2.w,
                  ),
                ),
                child:  Icon(
                  Icons.mark_email_read_outlined,
                  size: 44.w,
                  color: Colors.blueAccent,
                ),
              ),

              SizedBox(height: 36.h),

              Text(
                "Check Your Inbox",
                style: GoogleFonts.poppins(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),

               SizedBox(height: 12.h),

              Text(
                "We sent a verification link to",
                style: GoogleFonts.poppins(
                  fontSize: 14.sp,
                  color: Colors.white54,
                ),
              ),

               SizedBox(height: 4.h),

              Text(
                email,
                style: GoogleFonts.poppins(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.blueAccent,
                ),
              ),

               SizedBox(height: 12.h),

              Text(
                "Click the link in the email to verify your account. The app will automatically move forward once verified.",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 13.sp,
                  color: Colors.white38,
                  height: 1.6.h,
                ),
              ),

               SizedBox(height: 48.h),

              // ✅ Primary button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: loading ? null : refreshUser,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    padding:  EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    elevation: 0,
                  ),
                  child: loading
                      ?  SizedBox(
                    height: 20.h,
                    width: 20.w,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.w,
                    ),
                  )
                      : Text(
                    "I Have Verified",
                    style: GoogleFonts.poppins(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

               SizedBox(height: 16.h),

              // ✅ Resend button
              TextButton(
                onPressed: resendEmail,
                child: Text(
                  "Didn't receive it? Resend Email",
                  style: GoogleFonts.poppins(
                    fontSize: 13.sp,
                    color: Colors.white54,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}