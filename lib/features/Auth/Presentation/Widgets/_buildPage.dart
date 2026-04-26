import 'package:expense_tracker/common/theme/AppPallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class OnboardingPage extends StatefulWidget {
  final String title;
  final String quote;
  final String imgPath;

  const OnboardingPage({
    super.key,
    required this.title,
    required this.quote,
    required this.imgPath,
  });

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.title,
                style: GoogleFonts.inter(
                  color: AppPallete.iconBackground,
                  fontSize: 24.sp,        // ✅ .sp scales with screen
                  fontWeight: FontWeight.w300,
                  letterSpacing: -0.5,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 16.h),     // ✅ .h scales with screen height

              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: AppPallete.iconBackground.withOpacity(0.05),
                  shape: BoxShape.circle,
                ),
                child: Lottie.asset(
                  widget.imgPath,
                  height: 150.h,          // ✅ reduced from 260.h
                  width: 150.w,           // ✅ reduced from 260.w
                  fit: BoxFit.contain,
                ),
              ),

              SizedBox(height: 24.h),     // ✅ reduced from 48.h

              Text(
                widget.quote,
                style: GoogleFonts.inter(
                  color: AppPallete.iconBackground.withOpacity(0.9),
                  fontSize: 15.sp,        // ✅ .sp scales with screen
                  fontWeight: FontWeight.w600,
                  height: 1.4,
                  letterSpacing: 0.2,
                ),
                textAlign: TextAlign.center,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}