import 'package:expense_tracker/common/functions/money_textfield.dart';
import 'package:expense_tracker/common/functions/CurrencyFormater.dart';
import 'package:expense_tracker/common/theme/AppPallete.dart';
import 'package:expense_tracker/features/profile/presentation/widgets/slider.dart';
import 'package:expense_tracker/features/profile/provider/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileSetUp extends ConsumerStatefulWidget {
  const ProfileSetUp({super.key});

  @override
  ConsumerState<ProfileSetUp> createState() => _ProfileSetUpState();
}

class _ProfileSetUpState extends ConsumerState<ProfileSetUp> {
  final TextEditingController income_cont = TextEditingController();
  double _value = 25;

  @override
  void initState() {
    super.initState();
    income_cont.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    income_cont.dispose();
    super.dispose();
  }

  int get income => CurrencyFormatter.parse(income_cont.text);

  String getSavingsEmoji() {
    if (_value < 10) return "💡";
    if (_value < 20) return "👍";
    if (_value < 35) return "🔥";
    return "💰";
  }

  String getSavingsMessage() {
    if (income_cont.text.isEmpty) return "Enter your income above";
    if (_value == 0) return "Start saving something";
    if (_value < 10) return "Try to save more";
    if (_value < 20) return "Good start";
    if (_value < 35) return "You're doing great";
    return "Financially smart";
  }

  @override
  Widget build(BuildContext context) {
    final savings = income * (_value / 100);

    return Scaffold(
      backgroundColor: AppPallete.textPrimary,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              SizedBox(height: 40.h),

              // ── Header ──────────────────────────────
              Text(
                "Profile Setup",
                style: GoogleFonts.poppins(
                  fontSize: 32.sp,
                  fontWeight: FontWeight.w700,
                  color: AppPallete.background,
                  height: 1.1,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                "Tell us about your finances",
                style: GoogleFonts.poppins(
                  fontSize: 14.sp,
                  color: AppPallete.background.withOpacity(0.5),
                  fontWeight: FontWeight.w400,
                ),
              ),

              SizedBox(height: 40.h),

              // ── Income Card ─────────────────────────
              Container(
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: AppPallete.cardWhite.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: AppPallete.cardWhite.withOpacity(0.12),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Monthly Income",
                      style: GoogleFonts.poppins(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                        color: AppPallete.background.withOpacity(0.5),
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    MoneyTextField(
                      controller: income_cont,
                      label: "Enter Monthly Income",
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20.h),

              // ── Savings Card ────────────────────────
              Container(
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: AppPallete.cardWhite.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: AppPallete.cardWhite.withOpacity(0.12),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Savings Goal",
                          style: GoogleFonts.poppins(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                            color: AppPallete.background.withOpacity(0.5),
                            letterSpacing: 0.5,
                          ),
                        ),
                        // Live % badge
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: AppPallete.iconBackground,
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Text(
                            "${_value.toInt()}%",
                            style: GoogleFonts.poppins(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w700,
                              color: AppPallete.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    MySlider(
                      onchanged: (val) => setState(() => _value = val),
                      myvalue: _value,
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // ── Savings Summary ─────────────────────
              // ── Savings Summary ─────────────────────
              if (income_cont.text.isNotEmpty && _value > 0)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(15.w),
                  decoration: BoxDecoration(
                    color: AppPallete.iconBackground.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(
                      color: AppPallete.iconBackground.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        getSavingsEmoji(),
                        style: TextStyle(fontSize: 32.sp),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(                        // ✅ THIS is the fix — constrain the text
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              getSavingsMessage(),
                              style: GoogleFonts.poppins(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                                color: AppPallete.cardWhite.withOpacity(0.8),
                              ),
                            ),
                            Text(
                              "You save ${CurrencyFormatter.compact(savings)} / M",
                              style: GoogleFonts.poppins(
                                fontSize: 20.sp,                // ✅ slightly smaller
                                fontWeight: FontWeight.w700,
                                color: AppPallete.iconBackground,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,  // ✅ safety fallback
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

              SizedBox(height: 20.h),

              // ── Button ──────────────────────────────
              SizedBox(
                width: double.infinity,
                height: 56.h,
                child: ElevatedButton(
                  onPressed: () async {
                    if (income_cont.text.isEmpty || _value == 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Please fill all details!")),
                      );
                      return;
                    }
                    await ref
                        .read(profileServicesProvider)
                        .saveProfile(
                      monthlyincome: income.toInt(),
                      savingGoalpert: _value.toInt(),
                    );
                    ref.invalidate(profileProvider);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppPallete.cardWhite,
                    foregroundColor: AppPallete.textPrimary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                  child: Text(
                    "Start Tracking",
                    style: GoogleFonts.poppins(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}