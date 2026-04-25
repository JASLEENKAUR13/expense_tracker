import 'package:expense_tracker/common/functions/money_textfield.dart';
import 'package:expense_tracker/common/functions/CurrencyFormater.dart';
import 'package:expense_tracker/common/theme/AppPallete.dart';
import 'package:expense_tracker/features/profile/presentation/widgets/slider.dart';
import 'package:expense_tracker/features/profile/provider/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class ProfileSetUp extends ConsumerStatefulWidget {
  ProfileSetUp({super.key});

  @override
  ConsumerState<ProfileSetUp> createState() => _ProfileSetUpState();
}

class _ProfileSetUpState extends ConsumerState<ProfileSetUp>
    with TickerProviderStateMixin {
  final TextEditingController income_cont = TextEditingController();
  final TextEditingController name_cont = TextEditingController();
  final TextEditingController phone_cont = TextEditingController();
  final TextEditingController salaryDayCont = TextEditingController();

  double _value = 25;
  int _step = 0;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnim = CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);
    _fadeController.forward();

    income_cont.addListener(() => setState(() {}));
    salaryDayCont.text = '1';

    final user = Supabase.instance.client.auth.currentUser;
    final googleName = user?.userMetadata?['name'] ?? '';
    if (googleName.isNotEmpty) name_cont.text = googleName;
  }

  @override
  void dispose() {
    _fadeController.dispose();
    income_cont.dispose();
    name_cont.dispose();
    phone_cont.dispose();
    salaryDayCont.dispose();
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
    if (_value < 20) return "Good start!";
    if (_value < 35) return "You're doing great";
    return "Financially smart 🎯";
  }

  void _goToNextStep() {
    if (name_cont.text.trim().isEmpty || phone_cont.text.trim().isEmpty) {
      _showSnack("Please fill in your name and phone number!");
      return;
    }
    setState(() => _step = 1);
    _fadeController.reset();
    _fadeController.forward();
  }

  Future<void> _saveProfile() async {
    if (income_cont.text.isEmpty || _value == 0) {
      _showSnack("Please fill in your income and savings goal!");
      return;
    }
    final salaryDay = int.tryParse(salaryDayCont.text) ?? 1;
    final phoneInt = int.tryParse(
        phone_cont.text.trim().replaceAll(RegExp(r'\D'), ''));
    if (phoneInt == null) {
      _showSnack("Please enter a valid phone number!");
      return;
    }

    await ref.read(profileProvider.notifier).updateProfile(
      userName: name_cont.text.trim(),
      phoneNo: phoneInt,
      monthlyIncome: income.toInt(),
      savingsGoalPerc: _value.toInt(),
      salary_day: salaryDay,
    );
    ref.invalidate(profileProvider);
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg,
            style: GoogleFonts.poppins(fontSize: 13.sp, color: Colors.white)),
        backgroundColor: const Color(0xFF252850),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final savings = income * (_value / 100);

    return Scaffold(
      backgroundColor: AppPallete.background,
      body: Stack(
        children: [
          // ── Background decorative circles ──
          Positioned(
            top: -80.h,
            right: -60.w,
            child: Container(
              width: 220.w,
              height: 220.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppPallete.primaryBlue.withOpacity(0.08),
              ),
            ),
          ),
          Positioned(
            bottom: 100.h,
            left: -80.w,
            child: Container(
              width: 180.w,
              height: 180.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppPallete.primaryBlue.withOpacity(0.05),
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 32.h),

                  // ── Step indicator ──
                  _buildStepIndicator(),

                  SizedBox(height: 28.h),

                  // ── Header ──
                  FadeTransition(
                    opacity: _fadeAnim,
                    child: _step == 0
                        ? _buildHeader("Who are you?", "Let's get to know you")
                        : _buildHeader("Your Finances", "Set your money goals"),
                  ),

                  SizedBox(height: 28.h),

                  // ── Content ──
                  Expanded(
                    child: FadeTransition(
                      opacity: _fadeAnim,
                      child: _step == 0
                          ? _PersonalStep(
                        nameCont: name_cont,
                        phoneCont: phone_cont,
                      )
                          : _FinanceStep(
                        incomeCont: income_cont,
                        sliderValue: _value,
                        onSliderChanged: (val) =>
                            setState(() => _value = val),
                        savings: savings,
                        savingsEmoji: getSavingsEmoji(),
                        savingsMessage: getSavingsMessage(),
                        salaryDayCont: salaryDayCont,
                      ),
                    ),
                  ),

                  SizedBox(height: 16.h),

                  // ── Buttons ──
                  _buildButtons(),

                  SizedBox(height: 28.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Row(
      children: [
        _StepDot(active: _step == 0, done: _step > 0, label: "1"),
        Expanded(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            height: 2.h,
            margin: EdgeInsets.symmetric(horizontal: 8.w),
            decoration: BoxDecoration(
              gradient: _step > 0
                  ? LinearGradient(colors: [
                AppPallete.primaryBlue,
                AppPallete.primaryBlue.withOpacity(0.4)
              ])
                  : null,
              color: _step > 0 ? null : Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
        ),
        _StepDot(active: _step == 1, done: false, label: "2"),
      ],
    );
  }

  Widget _buildHeader(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 28.sp,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            height: 1.2,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          subtitle,
          style: GoogleFonts.poppins(
            fontSize: 14.sp,
            color: Colors.white38,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildButtons() {
    if (_step == 0) {
      return _PrimaryButton(label: "Continue →", onTap: _goToNextStep);
    }
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            setState(() => _step = 0);
            _fadeController.reset();
            _fadeController.forward();
          },
          child: Container(
            height: 54.h,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.06),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Center(
              child: Text(
                "← Back",
                style: GoogleFonts.poppins(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white60,
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _PrimaryButton(label: "Start Tracking 🚀", onTap: _saveProfile),
        ),
      ],
    );
  }
}

// ─── Primary Button ────────────────────────────────────────────────────────

class _PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _PrimaryButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 54.h,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppPallete.primaryBlue,
              AppPallete.primaryBlue.withOpacity(0.7),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: AppPallete.primaryBlue.withOpacity(0.3),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Step Dot ─────────────────────────────────────────────────────────────

class _StepDot extends StatelessWidget {
  final bool active;
  final bool done;
  final String label;

  const _StepDot({
    super.key,
    required this.active,
    required this.done,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 36.w,
      height: 36.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: (active || done)
            ? AppPallete.primaryBlue
            : Colors.white.withOpacity(0.06),
        border: Border.all(
          color: (active || done)
              ? AppPallete.primaryBlue
              : Colors.white.withOpacity(0.15),
          width: 2,
        ),
        boxShadow: (active || done)
            ? [
          BoxShadow(
            color: AppPallete.primaryBlue.withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, 3),
          )
        ]
            : [],
      ),
      child: Center(
        child: done
            ? Icon(Icons.check_rounded, size: 16.sp, color: Colors.white)
            : Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 13.sp,
            fontWeight: FontWeight.w700,
            color: active ? Colors.white : Colors.white30,
          ),
        ),
      ),
    );
  }
}

// ─── Input Field Widget ────────────────────────────────────────────────────

class _InputField extends StatelessWidget {
  final String label;
  final Widget child;
  final IconData? icon;

  const _InputField({
    required this.label,
    required this.child,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white38,
            letterSpacing: 0.8,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: Colors.white.withOpacity(0.08)),
          ),
          child: child,
        ),
      ],
    );
  }
}

// ─── Step 1: Personal ─────────────────────────────────────────────────────

class _PersonalStep extends StatelessWidget {
  final TextEditingController nameCont;
  final TextEditingController phoneCont;

  const _PersonalStep({
    super.key,
    required this.nameCont,
    required this.phoneCont,
  });

  InputDecoration _dec(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.poppins(
        color: Colors.white24,
        fontSize: 14.sp,
      ),
      prefixIcon: Icon(icon, color: Colors.white24, size: 20.sp),
      border: InputBorder.none,
      contentPadding:
      EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _InputField(
          label: "FULL NAME",
          child: TextField(
            controller: nameCont,
            style: GoogleFonts.poppins(
                color: Colors.white, fontSize: 15.sp),
            decoration: _dec("Your full name", Icons.person_outline_rounded),
          ),
        ),
        SizedBox(height: 20.h),
        _InputField(
          label: "PHONE NUMBER",
          child: TextField(
            controller: phoneCont,
            keyboardType: TextInputType.phone,
            style: GoogleFonts.poppins(
                color: Colors.white, fontSize: 15.sp),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: _dec("10-digit number", Icons.phone_outlined),
          ),
        ),
      ],
    );
  }
}

// ─── Step 2: Finance ──────────────────────────────────────────────────────

class _FinanceStep extends StatelessWidget {
  final TextEditingController incomeCont;
  final double sliderValue;
  final ValueChanged<double> onSliderChanged;
  final double savings;
  final String savingsEmoji;
  final String savingsMessage;
  final TextEditingController salaryDayCont;

  const _FinanceStep({
    super.key,
    required this.incomeCont,
    required this.sliderValue,
    required this.onSliderChanged,
    required this.savings,
    required this.savingsEmoji,
    required this.savingsMessage,
    required this.salaryDayCont,
  });

  String _getDayLabel(int day) {
    if (day >= 11 && day <= 13) return "${day}th";
    switch (day % 10) {
      case 1: return "${day}st";
      case 2: return "${day}nd";
      case 3: return "${day}rd";
      default: return "${day}th";
    }
  }

  void _showSalaryDayPicker(BuildContext context) {
    int selectedDay = int.tryParse(salaryDayCont.text) ?? 1;

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0F1123),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 32.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // handle
                  Container(
                    width: 36.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: Colors.white12,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    "Salary Day",
                    style: GoogleFonts.poppins(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    "Which day do you get paid?",
                    style: GoogleFonts.poppins(
                        fontSize: 13.sp, color: Colors.white38),
                  ),
                  SizedBox(height: 20.h),

                  SizedBox(
                    height: 160.h,
                    child: ListWheelScrollView.useDelegate(
                      itemExtent: 48.h,
                      perspective: 0.003,
                      diameterRatio: 1.6,
                      physics: const FixedExtentScrollPhysics(),
                      controller: FixedExtentScrollController(
                          initialItem: selectedDay - 1),
                      onSelectedItemChanged: (index) {
                        setModalState(() => selectedDay = index + 1);
                      },
                      childDelegate: ListWheelChildBuilderDelegate(
                        childCount: 31,
                        builder: (context, index) {
                          final day = index + 1;
                          final isSelected = day == selectedDay;
                          return Center(
                            child: Text(
                              _getDayLabel(day),
                              style: GoogleFonts.poppins(
                                fontSize: isSelected ? 22.sp : 15.sp,
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w400,
                                color: isSelected
                                    ? AppPallete.primaryBlue
                                    : Colors.white24,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  SizedBox(height: 20.h),

                  GestureDetector(
                    onTap: () {
                      salaryDayCont.text = selectedDay.toString();
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: double.infinity,
                      height: 50.h,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppPallete.primaryBlue,
                            AppPallete.primaryBlue.withOpacity(0.7)
                          ],
                        ),
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      child: Center(
                        child: Text(
                          "Confirm ${_getDayLabel(selectedDay)}",
                          style: GoogleFonts.poppins(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedDay = int.tryParse(salaryDayCont.text) ?? 1;

    return SingleChildScrollView(
      child: Column(
        children: [
          // ── Monthly Income ──
          _InputField(
            label: "MONTHLY INCOME",
            child: MoneyTextField(
              controller: incomeCont,
              label: "Enter amount",
            ),
          ),

          SizedBox(height: 20.h),

          // ── Savings Goal ──
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "SAVINGS GOAL",
                    style: GoogleFonts.poppins(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white38,
                      letterSpacing: 0.8,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 10.w, vertical: 3.h),
                    decoration: BoxDecoration(
                      color: AppPallete.primaryBlue.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                          color: AppPallete.primaryBlue.withOpacity(0.3)),
                    ),
                    child: Text(
                      "${sliderValue.toInt()}%",
                      style: GoogleFonts.poppins(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                        color: AppPallete.primaryBlue,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              MySlider(
                onchanged: onSliderChanged,
                myvalue: sliderValue,
              ),


            ],
          ),

          SizedBox(height: 20.h),

          // ── Salary Day ──
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "SALARY DAY",
                style: GoogleFonts.poppins(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white38,
                  letterSpacing: 0.8,
                ),
              ),
              SizedBox(height: 8.h),
              GestureDetector(
                onTap: () => _showSalaryDayPicker(context),
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 16.w, vertical: 16.h),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(14.r),
                    border:
                    Border.all(color: Colors.white.withOpacity(0.08)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.calendar_month_outlined,
                              color: AppPallete.primaryBlue, size: 20.sp),
                          SizedBox(width: 12.w),
                          Text(
                            "Every ${_getDayLabel(selectedDay)} of the month",
                            style: GoogleFonts.poppins(
                              fontSize: 14.sp,
                              color: Colors.white70,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Icon(Icons.chevron_right_rounded,
                          color: Colors.white24, size: 20.sp),
                    ],
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 20.h),

          // ── Savings summary ──
          if (incomeCont.text.isNotEmpty && sliderValue > 0)
            Container(
              padding:
              EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              decoration: BoxDecoration(
                color: AppPallete.primaryBlue.withOpacity(0.08),
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(
                    color: AppPallete.primaryBlue.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Text(savingsEmoji,
                      style: TextStyle(fontSize: 28.sp)),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          savingsMessage,
                          style: GoogleFonts.poppins(
                            fontSize: 12.sp,
                            color: Colors.white54,
                          ),
                        ),
                        Text(
                          "Saving ${CurrencyFormatter.compact(savings)} / month",
                          style: GoogleFonts.poppins(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: AppPallete.primaryBlue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}