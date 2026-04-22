import 'package:expense_tracker/common/theme/AppPallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../Widgets/_buildPage.dart';

class OnboardingScreen extends StatefulWidget {
  final VoidCallback onFinished;
  const OnboardingScreen({super.key, required this.onFinished});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _pages = const [
    {
      'title': 'Do You Know?',
      'quote': '60% of people lose track of their cash',
      'imgPath': 'lib/common/theme/icons/money_analysis.json',
    },
    {
      'title': 'Track & Grow',
      'quote': 'Small changes make a big difference',
      'imgPath': 'lib/common/theme/icons/CollectingMoney.json',
    },
    {
      'title': 'Save',
      'quote': 'Master your money, master your life',
      'imgPath': 'lib/common/theme/icons/Money.json',
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() => _currentPage = page);
  }

  void _skipToEnd() {
    _pageController.animateToPage(
      _pages.length - 1,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      widget.onFinished();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(                          // ✅ ONE Scaffold here only
      backgroundColor: AppPallete.textPrimary,
      body: SafeArea(                         // ✅ ONE SafeArea here only
        child: Column(
          children: [
            // Skip button
            if (_currentPage < _pages.length - 1)
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 16.h,          // ✅ reduced from 32 to avoid waste
                  ),
                  child: TextButton(
                    onPressed: _skipToEnd,
                    style: TextButton.styleFrom(
                      foregroundColor:
                      AppPallete.iconBackground.withOpacity(0.7),
                    ),
                    child: Text(
                      'Skip',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),
                ),
              )
            else
              SizedBox(height: 52.h),

            // PageView — takes all remaining space
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return OnboardingPage(
                    title: _pages[index]['title']!,
                    quote: _pages[index]['quote']!,
                    imgPath: _pages[index]['imgPath']!,
                  );
                },
              ),
            ),

            // Bottom section — fixed, never scrolls
            Padding(
              padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 24.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,  // ✅ only takes what it needs
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                          (index) => _buildIndicator(index == _currentPage),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  SizedBox(
                    width: double.infinity,
                    height: 56.h,
                    child: ElevatedButton(
                      onPressed: _nextPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppPallete.iconBackground,
                        foregroundColor: AppPallete.textPrimary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                      ),
                      child: Text(
                        _currentPage == _pages.length - 1
                            ? 'Get Started'
                            : 'Next',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIndicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      height: 8.h,
      width: isActive ? 24.w : 8.w,
      decoration: BoxDecoration(
        color: isActive
            ? AppPallete.iconBackground
            : AppPallete.iconBackground.withOpacity(0.3),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}