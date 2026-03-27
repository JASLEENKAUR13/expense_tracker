import 'package:expense_tracker/common/theme/AppPallete.dart';
import 'package:flutter/material.dart';
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
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.height < 700;

    return Scaffold(
      backgroundColor: AppPallete.textPrimary,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.08,
            vertical: isSmallScreen ? 20 : 40,
          ),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Title
                  Text(
                    widget.title,
                    style: GoogleFonts.inter(
                      color: AppPallete.iconBackground,
                      fontSize: isSmallScreen ? 28 : 38,
                      fontWeight: FontWeight.w300,
                      letterSpacing: -0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: isSmallScreen ? 30 : 40),

                  // Lottie Animation with decorative container
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppPallete.iconBackground.withOpacity(0.05),
                      shape: BoxShape.circle,
                    ),
                    child: Lottie.asset(
                      widget.imgPath,
                      height: isSmallScreen ? 200 : 280,
                      width: isSmallScreen ? 200 : 280,
                      fit: BoxFit.contain,
                    ),
                  ),

                  SizedBox(height: isSmallScreen ? 30 : 60),

                  // Quote
                  Text(
                    widget.quote,
                    style: GoogleFonts.inter(
                      color: AppPallete.iconBackground.withOpacity(0.9),
                      fontSize: isSmallScreen ? 18 : 20,
                      fontWeight: FontWeight.w600,
                      height: 1.2,
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
        ),
      ),
    );
  }
}