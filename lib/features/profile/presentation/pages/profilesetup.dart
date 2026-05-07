// import 'package:expense_tracker/common/functions/money_textfield.dart';
// import 'package:expense_tracker/common/functions/CurrencyFormater.dart';
// import 'package:expense_tracker/common/theme/AppPallete.dart';
// import 'package:expense_tracker/features/profile/presentation/widgets/slider.dart';
// import 'package:expense_tracker/features/profile/provider/profile_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
//
//
// class ProfileSetUp extends ConsumerStatefulWidget {
//   ProfileSetUp({super.key});
//
//   @override
//   ConsumerState<ProfileSetUp> createState() => _ProfileSetUpState();
// }
//
// class _ProfileSetUpState extends ConsumerState<ProfileSetUp>
//     with TickerProviderStateMixin {
//   final TextEditingController income_cont = TextEditingController();
//   final TextEditingController name_cont = TextEditingController();
//   final TextEditingController phone_cont = TextEditingController();
//   final TextEditingController salaryDayCont = TextEditingController();
//
//   double _value = 25;
//   int _step = 0;
//   late AnimationController _fadeController;
//   late Animation<double> _fadeAnim;
//
//   @override
//   void initState() {
//     super.initState();
//     _fadeController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 400),
//     );
//     _fadeAnim = CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);
//     _fadeController.forward();
//
//     income_cont.addListener(() => setState(() {}));
//     salaryDayCont.text = '1';
//
//     final user = Supabase.instance.client.auth.currentUser;
//     final googleName = user?.userMetadata?['name'] ?? '';
//     if (googleName.isNotEmpty) name_cont.text = googleName;
//   }
//
//   @override
//   void dispose() {
//     _fadeController.dispose();
//     income_cont.dispose();
//     name_cont.dispose();
//     phone_cont.dispose();
//     salaryDayCont.dispose();
//     super.dispose();
//   }
//
//   int get income => CurrencyFormatter.parse(income_cont.text);
//
//   String getSavingsEmoji() {
//     if (_value < 10) return "💡";
//     if (_value < 20) return "👍";
//     if (_value < 35) return "🔥";
//     return "💰";
//   }
//
//   String getSavingsMessage() {
//     if (income_cont.text.isEmpty) return "Enter your income above";
//     if (_value == 0) return "Start saving something";
//     if (_value < 10) return "Try to save more";
//     if (_value < 20) return "Good start!";
//     if (_value < 35) return "You're doing great";
//     return "Financially smart 🎯";
//   }
//
//   void _goToNextStep() {
//     if (name_cont.text.trim().isEmpty || phone_cont.text.trim().isEmpty) {
//       _showSnack("Please fill in your name and phone number!");
//       return;
//     }
//     setState(() => _step = 1);
//     _fadeController.reset();
//     _fadeController.forward();
//   }
//
//   Future<void> _saveProfile() async {
//     if (income_cont.text.isEmpty || _value == 0) {
//       _showSnack("Please fill in your income and savings goal!");
//       return;
//     }
//     final salaryDay = int.tryParse(salaryDayCont.text) ?? 1;
//     final phoneInt = int.tryParse(
//         phone_cont.text.trim().replaceAll(RegExp(r'\D'), ''));
//     if (phoneInt == null) {
//       _showSnack("Please enter a valid phone number!");
//       return;
//     }
//
//     await ref.read(profileProvider.notifier).updateProfile(
//       userName: name_cont.text.trim(),
//       phoneNo: phoneInt,
//       monthlyIncome: income.toInt(),
//       savingsGoalPerc: _value.toInt(),
//       salary_day: salaryDay,
//     );
//     ref.invalidate(profileProvider);
//   }
//
//   void _showSnack(String msg) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(msg,
//             style: GoogleFonts.poppins(fontSize: 13.sp, color: Colors.white)),
//         backgroundColor: const Color(0xFF252850),
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final savings = income * (_value / 100);
//
//     return Scaffold(
//       backgroundColor: AppPallete.background,
//       body: Stack(
//         children: [
//           // ── Background decorative circles ──
//           Positioned(
//             top: -80.h,
//             right: -60.w,
//             child: Container(
//               width: 220.w,
//               height: 220.w,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: AppPallete.primaryBlue.withOpacity(0.08),
//               ),
//             ),
//           ),
//           Positioned(
//             bottom: 100.h,
//             left: -80.w,
//             child: Container(
//               width: 180.w,
//               height: 180.w,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: AppPallete.primaryBlue.withOpacity(0.05),
//               ),
//             ),
//           ),
//
//           SafeArea(
//             child: Padding(
//               padding: EdgeInsets.symmetric(horizontal: 24.w),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   SizedBox(height: 32.h),
//
//                   // ── Step indicator ──
//                   _buildStepIndicator(),
//
//                   SizedBox(height: 28.h),
//
//                   // ── Header ──
//                   FadeTransition(
//                     opacity: _fadeAnim,
//                     child: _step == 0
//                         ? _buildHeader("Who are you?", "Let's get to know you")
//                         : _buildHeader("Your Finances", "Set your money goals"),
//                   ),
//
//                   SizedBox(height: 28.h),
//
//                   // ── Content ──
//                   Expanded(
//                     child: FadeTransition(
//                       opacity: _fadeAnim,
//                       child: _step == 0
//                           ? _PersonalStep(
//                         nameCont: name_cont,
//                         phoneCont: phone_cont,
//                       )
//                           : _FinanceStep(
//                         incomeCont: income_cont,
//                         sliderValue: _value,
//                         onSliderChanged: (val) =>
//                             setState(() => _value = val),
//                         savings: savings,
//                         savingsEmoji: getSavingsEmoji(),
//                         savingsMessage: getSavingsMessage(),
//                         salaryDayCont: salaryDayCont,
//                       ),
//                     ),
//                   ),
//
//                   SizedBox(height: 16.h),
//
//                   // ── Buttons ──
//                   _buildButtons(),
//
//                   SizedBox(height: 28.h),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildStepIndicator() {
//     return Row(
//       children: [
//         _StepDot(active: _step == 0, done: _step > 0, label: "1"),
//         Expanded(
//           child: AnimatedContainer(
//             duration: const Duration(milliseconds: 400),
//             height: 2.h,
//             margin: EdgeInsets.symmetric(horizontal: 8.w),
//             decoration: BoxDecoration(
//               gradient: _step > 0
//                   ? LinearGradient(colors: [
//                 AppPallete.primaryBlue,
//                 AppPallete.primaryBlue.withOpacity(0.4)
//               ])
//                   : null,
//               color: _step > 0 ? null : Colors.white.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(2.r),
//             ),
//           ),
//         ),
//         _StepDot(active: _step == 1, done: false, label: "2"),
//       ],
//     );
//   }
//
//   Widget _buildHeader(String title, String subtitle) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           title,
//           style: GoogleFonts.poppins(
//             fontSize: 22.sp,
//             fontWeight: FontWeight.w700,
//             color: Colors.white,
//             height: 1.2,
//           ),
//         ),
//         SizedBox(height: 4.h),
//         Text(
//           subtitle,
//           style: GoogleFonts.poppins(
//             fontSize: 13.sp,
//             color: Colors.white38,
//             fontWeight: FontWeight.w400,
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildButtons() {
//     if (_step == 0) {
//       return _PrimaryButton(label: "Continue →", onTap: _goToNextStep);
//     }
//     return Row(
//       children: [
//         GestureDetector(
//           onTap: () {
//             setState(() => _step = 0);
//             _fadeController.reset();
//             _fadeController.forward();
//           },
//           child: Container(
//             height: 50.h,
//             padding: EdgeInsets.symmetric(horizontal: 20.w),
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(0.06),
//               borderRadius: BorderRadius.circular(16.r),
//               border: Border.all(color: Colors.white.withOpacity(0.1)),
//             ),
//             child: Center(
//               child: Text(
//                 "← Back",
//                 style: GoogleFonts.poppins(
//                   fontSize: 14.sp,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.white60,
//                 ),
//               ),
//             ),
//           ),
//         ),
//         SizedBox(width: 12.w),
//         Expanded(
//           child: _PrimaryButton(label: "Start Tracking 🚀", onTap: _saveProfile),
//         ),
//       ],
//     );
//   }
// }
//
// // ─── Primary Button ────────────────────────────────────────────────────────
//
// class _PrimaryButton extends StatelessWidget {
//   final String label;
//   final VoidCallback onTap;
//
//   const _PrimaryButton({required this.label, required this.onTap});
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         height: 54.h,
//         width: double.infinity,
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [
//               AppPallete.primaryBlue,
//               AppPallete.primaryBlue.withOpacity(0.7),
//             ],
//             begin: Alignment.centerLeft,
//             end: Alignment.centerRight,
//           ),
//           borderRadius: BorderRadius.circular(16.r),
//           boxShadow: [
//             BoxShadow(
//               color: AppPallete.primaryBlue.withOpacity(0.3),
//               blurRadius: 16,
//               offset: const Offset(0, 6),
//             ),
//           ],
//         ),
//         child: Center(
//           child: Text(
//             label,
//             style: GoogleFonts.poppins(
//               fontSize: 14.sp,
//               fontWeight: FontWeight.w700,
//               color: Colors.white,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// // ─── Step Dot ─────────────────────────────────────────────────────────────
//
// class _StepDot extends StatelessWidget {
//   final bool active;
//   final bool done;
//   final String label;
//
//   const _StepDot({
//     super.key,
//     required this.active,
//     required this.done,
//     required this.label,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 300),
//       width: 36.w,
//       height: 36.w,
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         color: (active || done)
//             ? AppPallete.primaryBlue
//             : Colors.white.withOpacity(0.06),
//         border: Border.all(
//           color: (active || done)
//               ? AppPallete.primaryBlue
//               : Colors.white.withOpacity(0.15),
//           width: 2,
//         ),
//         boxShadow: (active || done)
//             ? [
//           BoxShadow(
//             color: AppPallete.primaryBlue.withOpacity(0.4),
//             blurRadius: 10,
//             offset: const Offset(0, 3),
//           )
//         ]
//             : [],
//       ),
//       child: Center(
//         child: done
//             ? Icon(Icons.check_rounded, size: 16.sp, color: Colors.white)
//             : Text(
//           label,
//           style: GoogleFonts.poppins(
//             fontSize: 13.sp,
//             fontWeight: FontWeight.w700,
//             color: active ? Colors.white : Colors.white30,
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// // ─── Input Field Widget ────────────────────────────────────────────────────
//
// class _InputField extends StatelessWidget {
//   final String label;
//   final Widget child;
//   final IconData? icon;
//
//   const _InputField({
//     required this.label,
//     required this.child,
//     this.icon,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: GoogleFonts.poppins(
//             fontSize: 12.sp,
//             fontWeight: FontWeight.w600,
//             color: Colors.white38,
//             letterSpacing: 0.8,
//           ),
//         ),
//         SizedBox(height: 8.h),
//         Container(
//           decoration: BoxDecoration(
//             color: Colors.white.withOpacity(0.05),
//             borderRadius: BorderRadius.circular(14.r),
//             border: Border.all(color: Colors.white.withOpacity(0.08)),
//           ),
//           child: child,
//         ),
//       ],
//     );
//   }
// }
//
// // ─── Step 1: Personal ─────────────────────────────────────────────────────
//
// class _PersonalStep extends StatelessWidget {
//   final TextEditingController nameCont;
//   final TextEditingController phoneCont;
//
//   const _PersonalStep({
//     super.key,
//     required this.nameCont,
//     required this.phoneCont,
//   });
//
//   InputDecoration _dec(String hint, IconData icon) {
//     return InputDecoration(
//       hintText: hint,
//       hintStyle: GoogleFonts.poppins(
//         color: Colors.white24,
//         fontSize: 14.sp,
//       ),
//       prefixIcon: Icon(icon, color: Colors.white24, size: 20.sp),
//       border: InputBorder.none,
//       contentPadding:
//       EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         _InputField(
//           label: "FULL NAME",
//           child: TextField(
//             controller: nameCont,
//             style: GoogleFonts.poppins(
//                 color: Colors.white, fontSize: 15.sp),
//             decoration: _dec("Your full name", Icons.person_outline_rounded),
//           ),
//         ),
//         SizedBox(height: 20.h),
//         _InputField(
//           label: "PHONE NUMBER",
//           child: TextField(
//             controller: phoneCont,
//             keyboardType: TextInputType.phone,
//             style: GoogleFonts.poppins(
//                 color: Colors.white, fontSize: 15.sp),
//             inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//             decoration: _dec("10-digit number", Icons.phone_outlined),
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// // ─── Step 2: Finance ──────────────────────────────────────────────────────
//
// class _FinanceStep extends StatelessWidget {
//   final TextEditingController incomeCont;
//   final double sliderValue;
//   final ValueChanged<double> onSliderChanged;
//   final double savings;
//   final String savingsEmoji;
//   final String savingsMessage;
//   final TextEditingController salaryDayCont;
//
//   const _FinanceStep({
//     super.key,
//     required this.incomeCont,
//     required this.sliderValue,
//     required this.onSliderChanged,
//     required this.savings,
//     required this.savingsEmoji,
//     required this.savingsMessage,
//     required this.salaryDayCont,
//   });
//
//   String _getDayLabel(int day) {
//     if (day >= 11 && day <= 13) return "${day}th";
//     switch (day % 10) {
//       case 1: return "${day}st";
//       case 2: return "${day}nd";
//       case 3: return "${day}rd";
//       default: return "${day}th";
//     }
//   }
//
//   void _showSalaryDayPicker(BuildContext context) {
//     int selectedDay = int.tryParse(salaryDayCont.text) ?? 1;
//
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: const Color(0xFF0F1123),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
//       ),
//       builder: (_) {
//         return StatefulBuilder(
//           builder: (context, setModalState) {
//             return Padding(
//               padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 32.h),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   // handle
//                   Container(
//                     width: 36.w,
//                     height: 4.h,
//                     decoration: BoxDecoration(
//                       color: Colors.white12,
//                       borderRadius: BorderRadius.circular(10.r),
//                     ),
//                   ),
//                   SizedBox(height: 20.h),
//                   Text(
//                     "Salary Day",
//                     style: GoogleFonts.poppins(
//                       fontSize: 15.sp,
//                       fontWeight: FontWeight.w700,
//                       color: Colors.white,
//                     ),
//                   ),
//                   SizedBox(height: 4.h),
//                   Text(
//                     "Which day do you get paid?",
//                     style: GoogleFonts.poppins(
//                         fontSize: 13.sp, color: Colors.white38),
//                   ),
//                   SizedBox(height: 20.h),
//
//                   SizedBox(
//                     height: 160.h,
//                     child: ListWheelScrollView.useDelegate(
//                       itemExtent: 48.h,
//                       perspective: 0.003,
//                       diameterRatio: 1.6,
//                       physics: const FixedExtentScrollPhysics(),
//                       controller: FixedExtentScrollController(
//                           initialItem: selectedDay - 1),
//                       onSelectedItemChanged: (index) {
//                         setModalState(() => selectedDay = index + 1);
//                       },
//                       childDelegate: ListWheelChildBuilderDelegate(
//                         childCount: 31,
//                         builder: (context, index) {
//                           final day = index + 1;
//                           final isSelected = day == selectedDay;
//                           return Center(
//                             child: Text(
//                               _getDayLabel(day),
//                               style: GoogleFonts.poppins(
//                                 fontSize: isSelected ? 22.sp : 15.sp,
//                                 fontWeight: isSelected
//                                     ? FontWeight.w700
//                                     : FontWeight.w400,
//                                 color: isSelected
//                                     ? AppPallete.primaryBlue
//                                     : Colors.white24,
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                   ),
//
//                   SizedBox(height: 20.h),
//
//                   GestureDetector(
//                     onTap: () {
//                       salaryDayCont.text = selectedDay.toString();
//                       Navigator.pop(context);
//                     },
//                     child: Container(
//                       width: double.infinity,
//                       height: 50.h,
//                       decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                           colors: [
//                             AppPallete.primaryBlue,
//                             AppPallete.primaryBlue.withOpacity(0.7)
//                           ],
//                         ),
//                         borderRadius: BorderRadius.circular(14.r),
//                       ),
//                       child: Center(
//                         child: Text(
//                           "Confirm ${_getDayLabel(selectedDay)}",
//                           style: GoogleFonts.poppins(
//                             fontSize: 15.sp,
//                             fontWeight: FontWeight.w700,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final selectedDay = int.tryParse(salaryDayCont.text) ?? 1;
//
//     return SingleChildScrollView(
//       child: Column(
//         children: [
//           // ── Monthly Income ──
//           _InputField(
//             label: "MONTHLY INCOME",
//             child: MoneyTextField(
//               controller: incomeCont,
//               label: "Enter amount",
//             ),
//           ),
//
//           SizedBox(height: 20.h),
//
//           // ── Savings Goal ──
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     "SAVINGS GOAL",
//                     style: GoogleFonts.poppins(
//                       fontSize: 12.sp,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.white38,
//                       letterSpacing: 0.8,
//                     ),
//                   ),
//                   Container(
//                     padding: EdgeInsets.symmetric(
//                         horizontal: 10.w, vertical: 3.h),
//                     decoration: BoxDecoration(
//                       color: AppPallete.primaryBlue.withOpacity(0.15),
//                       borderRadius: BorderRadius.circular(20.r),
//                       border: Border.all(
//                           color: AppPallete.primaryBlue.withOpacity(0.3)),
//                     ),
//                     child: Text(
//                       "${sliderValue.toInt()}%",
//                       style: GoogleFonts.poppins(
//                         fontSize: 12.sp,
//                         fontWeight: FontWeight.w700,
//                         color: AppPallete.primaryBlue,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 12.h),
//               MySlider(
//                 onchanged: onSliderChanged,
//                 myvalue: sliderValue,
//               ),
//
//
//             ],
//           ),
//
//           SizedBox(height: 20.h),
//
//           // ── Salary Day ──
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 "SALARY DAY",
//                 style: GoogleFonts.poppins(
//                   fontSize: 12.sp,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.white38,
//                   letterSpacing: 0.8,
//                 ),
//               ),
//               SizedBox(height: 8.h),
//               GestureDetector(
//                 onTap: () => _showSalaryDayPicker(context),
//                 child: Container(
//                   padding: EdgeInsets.symmetric(
//                       horizontal: 16.w, vertical: 16.h),
//                   decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(0.05),
//                     borderRadius: BorderRadius.circular(14.r),
//                     border:
//                     Border.all(color: Colors.white.withOpacity(0.08)),
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Row(
//                         children: [
//                           Icon(Icons.calendar_month_outlined,
//                               color: AppPallete.primaryBlue, size: 20.sp),
//                           SizedBox(width: 12.w),
//                           Text(
//                             "Every ${_getDayLabel(selectedDay)} of the month",
//                             style: GoogleFonts.poppins(
//                               fontSize: 14.sp,
//                               color: Colors.white70,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ],
//                       ),
//                       Icon(Icons.chevron_right_rounded,
//                           color: Colors.white24, size: 20.sp),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//
//           SizedBox(height: 20.h),
//
//           // ── Savings summary ──
//           if (incomeCont.text.isNotEmpty && sliderValue > 0)
//             Container(
//               padding:
//               EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
//               decoration: BoxDecoration(
//                 color: AppPallete.primaryBlue.withOpacity(0.08),
//                 borderRadius: BorderRadius.circular(14.r),
//                 border: Border.all(
//                     color: AppPallete.primaryBlue.withOpacity(0.2)),
//               ),
//               child: Row(
//                 children: [
//                   Text(savingsEmoji,
//                       style: TextStyle(fontSize: 28.sp)),
//                   SizedBox(width: 14.w),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           savingsMessage,
//                           style: GoogleFonts.poppins(
//                             fontSize: 12.sp,
//                             color: Colors.white54,
//                           ),
//                         ),
//                         Text(
//                           "Saving ${CurrencyFormatter.compact(savings)} / month",
//                           style: GoogleFonts.poppins(
//                             fontSize: 14.sp,
//                             fontWeight: FontWeight.w700,
//                             color: AppPallete.primaryBlue,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }


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

  // Step 3 — Reminder time
  int _reminderHour = 21; // 24h format, default 9 PM
  int _reminderMinute = 0; // 0 or 30

  late AnimationController _fadeController;
  late AnimationController _pulseController;
  late Animation<double> _fadeAnim;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _fadeAnim = CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);
    _pulseAnim = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

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
    _pulseController.dispose();
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

  String get _formattedReminderTime {
    final hour = _reminderHour;
    final minute = _reminderMinute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$displayHour:$minute $period';
  }

  String get _reminderTimeForSupabase {
    final h = _reminderHour.toString().padLeft(2, '0');
    final m = _reminderMinute.toString().padLeft(2, '0');
    return '$h:$m:00';
  }

  void _animateStep(int newStep) {
    setState(() => _step = newStep);
    _fadeController.reset();
    _fadeController.forward();
  }

  void _goToNextStep() {
    if (_step == 0) {
      if (name_cont.text.trim().isEmpty || phone_cont.text.trim().isEmpty) {
        _showSnack("Please fill in your name and phone number!");
        return;
      }
      _animateStep(1);
    } else if (_step == 1) {
      if (income_cont.text.isEmpty || _value == 0) {
        _showSnack("Please fill in your income and savings goal!");
        return;
      }
      _animateStep(2);
    }
  }

  Future<void> _saveProfile() async {
    final salaryDay = int.tryParse(salaryDayCont.text) ?? 1;
    final phoneInt =
    int.tryParse(phone_cont.text.trim().replaceAll(RegExp(r'\D'), ''));
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
      reminder_time: _reminderTimeForSupabase,
    );
    ref.invalidate(profileProvider);
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg,
            style:
            GoogleFonts.poppins(fontSize: 13.sp, color: Colors.white)),
        backgroundColor: const Color(0xFF1A1D35),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPallete.background,
      body: Stack(
        children: [
          // ── Decorative background blobs ──
          Positioned(
            top: -100.h,
            right: -80.w,
            child: _GlowBlob(
                color: AppPallete.primaryBlue.withOpacity(0.12),
                size: 260.w),
          ),
          Positioned(
            bottom: 80.h,
            left: -100.w,
            child: _GlowBlob(
                color: AppPallete.primaryBlue.withOpacity(0.07),
                size: 200.w),
          ),
          Positioned(
            top: 200.h,
            left: 30.w,
            child: _GlowBlob(
                color: Colors.purpleAccent.withOpacity(0.04), size: 120.w),
          ),

          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 28.h),
                  _buildStepIndicator(),
                  SizedBox(height: 24.h),

                  // ── Animated Header ──
                  FadeTransition(
                    opacity: _fadeAnim,
                    child: _buildHeader(),
                  ),

                  SizedBox(height: 24.h),

                  // ── Content ──
                  Expanded(
                    child: FadeTransition(
                      opacity: _fadeAnim,
                      child: _buildStepContent(),
                    ),
                  ),

                  SizedBox(height: 16.h),
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
        _StepLine(active: _step > 0),
        _StepDot(active: _step == 1, done: _step > 1, label: "2"),
        _StepLine(active: _step > 1),
        _StepDot(active: _step == 2, done: false, label: "3"),
      ],
    );
  }

  Widget _buildHeader() {
    final titles = [
      ("Who are you?", "Let's get to know you 👋"),
      ("Your Finances", "Set your money goals 💸"),
      ("Daily Reminder", "Never miss logging expenses 🔔"),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titles[_step].$1,
          style: GoogleFonts.poppins(
            fontSize: 24.sp,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            height: 1.2,
          ),
        ),
        SizedBox(height: 5.h),
        Text(
          titles[_step].$2,
          style: GoogleFonts.poppins(
            fontSize: 13.sp,
            color: Colors.white38,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildStepContent() {
    switch (_step) {
      case 0:
        return _PersonalStep(nameCont: name_cont, phoneCont: phone_cont);
      case 1:
        return _FinanceStep(
          incomeCont: income_cont,
          sliderValue: _value,
          onSliderChanged: (val) => setState(() => _value = val),
          savings: income * (_value / 100),
          savingsEmoji: getSavingsEmoji(),
          savingsMessage: getSavingsMessage(),
          salaryDayCont: salaryDayCont,
        );
      case 2:
        return _ReminderStep(
          selectedHour: _reminderHour,
          selectedMinute: _reminderMinute,
          formattedTime: _formattedReminderTime,
          pulseAnim: _pulseAnim,
          onHourChanged: (h) => setState(() => _reminderHour = h),
          onMinuteChanged: (m) => setState(() => _reminderMinute = m),
        );
      default:
        return const SizedBox();
    }
  }

  Widget _buildButtons() {
    if (_step == 0) {
      return _PrimaryButton(label: "Continue →", onTap: _goToNextStep);
    }
    if (_step == 1) {
      return Row(
        children: [
          _BackButton(onTap: () => _animateStep(0)),
          SizedBox(width: 12.w),
          Expanded(
              child: _PrimaryButton(
                  label: "Next →", onTap: _goToNextStep)),
        ],
      );
    }
    // Step 2
    return Row(
      children: [
        _BackButton(onTap: () => _animateStep(1)),
        SizedBox(width: 12.w),
        Expanded(
            child: _PrimaryButton(
                label: "Start Tracking 🚀", onTap: _saveProfile)),
      ],
    );
  }
}

// ─── Reminder Step ────────────────────────────────────────────────────────

class _ReminderStep extends StatelessWidget {
  final int selectedHour;
  final int selectedMinute;
  final String formattedTime;
  final Animation<double> pulseAnim;
  final ValueChanged<int> onHourChanged;
  final ValueChanged<int> onMinuteChanged;

  const _ReminderStep({
    required this.selectedHour,
    required this.selectedMinute,
    required this.formattedTime,
    required this.pulseAnim,
    required this.onHourChanged,
    required this.onMinuteChanged,
  });

  // All valid hours in 24h (6 AM to 11 PM)
  static const List<int> _hours = [
    6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23
  ];
  static const List<int> _minutes = [0, 30];

  String _formatHour(int h) {
    final period = h >= 12 ? 'PM' : 'AM';
    final display = h > 12 ? h - 12 : (h == 0 ? 12 : h);
    return '$display $period';
  }

  @override
  Widget build(BuildContext context) {
    final hourIndex = _hours.indexOf(selectedHour).clamp(0, _hours.length - 1);
    final minuteIndex = _minutes.indexOf(selectedMinute).clamp(0, 1);

    return SingleChildScrollView(
      child: Column(
        children: [
          // ── Time display card ──
          ScaleTransition(
            scale: pulseAnim,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 28.h),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppPallete.primaryBlue.withOpacity(0.18),
                    AppPallete.primaryBlue.withOpacity(0.06),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24.r),
                border: Border.all(
                    color: AppPallete.primaryBlue.withOpacity(0.3), width: 1.5),
              ),
              child: Column(
                children: [
                  Text(
                    "🔔",
                    style: TextStyle(fontSize: 36.sp),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    formattedTime,
                    style: GoogleFonts.poppins(
                      fontSize: 38.sp,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: -1,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    "Daily reminder time",
                    style: GoogleFonts.poppins(
                      fontSize: 12.sp,
                      color: Colors.white38,
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 28.h),

          // ── Wheels ──
          Row(
            children: [
              // Hour wheel
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    Text(
                      "HOUR",
                      style: GoogleFonts.poppins(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white38,
                        letterSpacing: 1.2,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    _WheelPicker(
                      items: _hours.map((h) => _formatHour(h)).toList(),
                      initialIndex: hourIndex,
                      onChanged: (i) => onHourChanged(_hours[i]),
                    ),
                  ],
                ),
              ),

              // Divider
              Padding(
                padding: EdgeInsets.only(top: 24.h),
                child: Text(
                  ":",
                  style: GoogleFonts.poppins(
                    fontSize: 32.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white30,
                  ),
                ),
              ),

              // Minute wheel
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Text(
                      "MINUTE",
                      style: GoogleFonts.poppins(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white38,
                        letterSpacing: 1.2,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    _WheelPicker(
                      items: _minutes
                          .map((m) => m.toString().padLeft(2, '0'))
                          .toList(),
                      initialIndex: minuteIndex,
                      onChanged: (i) => onMinuteChanged(_minutes[i]),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 24.h),

          // ── Info pill ──
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.04),
              borderRadius: BorderRadius.circular(12.r),
              border:
              Border.all(color: Colors.white.withOpacity(0.08)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.info_outline_rounded,
                    color: Colors.white30, size: 15.sp),
                SizedBox(width: 8.w),
                Text(
                  "You can change this anytime in Settings",
                  style: GoogleFonts.poppins(
                    fontSize: 11.sp,
                    color: Colors.white30,
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

// ─── Reusable Wheel Picker ────────────────────────────────────────────────

class _WheelPicker extends StatefulWidget {
  final List<String> items;
  final int initialIndex;
  final ValueChanged<int> onChanged;

  const _WheelPicker({
    required this.items,
    required this.initialIndex,
    required this.onChanged,
  });

  @override
  State<_WheelPicker> createState() => _WheelPickerState();
}

class _WheelPickerState extends State<_WheelPicker> {
  late FixedExtentScrollController _controller;
  late int _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialIndex;
    _controller =
        FixedExtentScrollController(initialItem: widget.initialIndex);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160.h,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white.withOpacity(0.07)),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Selection highlight
          Center(
            child: Container(
              height: 46.h,
              margin: EdgeInsets.symmetric(horizontal: 8.w),
              decoration: BoxDecoration(
                color: AppPallete.primaryBlue.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(
                    color: AppPallete.primaryBlue.withOpacity(0.35)),
              ),
            ),
          ),
          ListWheelScrollView.useDelegate(
            controller: _controller,
            itemExtent: 46.h,
            perspective: 0.003,
            diameterRatio: 1.8,
            physics: const FixedExtentScrollPhysics(),
            onSelectedItemChanged: (i) {
              setState(() => _selected = i);
              widget.onChanged(i);
            },
            childDelegate: ListWheelChildBuilderDelegate(
              childCount: widget.items.length,
              builder: (context, index) {
                final isSelected = index == _selected;
                return Center(
                  child: Text(
                    widget.items[index],
                    style: GoogleFonts.poppins(
                      fontSize: isSelected ? 20.sp : 14.sp,
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.w400,
                      color: isSelected
                          ? Colors.white
                          : Colors.white24,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Glow Blob ────────────────────────────────────────────────────────────

class _GlowBlob extends StatelessWidget {
  final Color color;
  final double size;

  const _GlowBlob({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(color: color, blurRadius: 60, spreadRadius: 20),
        ],
      ),
    );
  }
}

// ─── Step Line ────────────────────────────────────────────────────────────

class _StepLine extends StatelessWidget {
  final bool active;
  const _StepLine({required this.active});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        height: 2.h,
        margin: EdgeInsets.symmetric(horizontal: 6.w),
        decoration: BoxDecoration(
          gradient: active
              ? LinearGradient(colors: [
            AppPallete.primaryBlue,
            AppPallete.primaryBlue.withOpacity(0.4),
          ])
              : null,
          color: active ? null : Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(2.r),
        ),
      ),
    );
  }
}

// ─── Primary Button ───────────────────────────────────────────────────────

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
              AppPallete.primaryBlue.withOpacity(0.75),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: AppPallete.primaryBlue.withOpacity(0.35),
              blurRadius: 18,
              offset: const Offset(0, 7),
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Back Button ──────────────────────────────────────────────────────────

class _BackButton extends StatelessWidget {
  final VoidCallback onTap;
  const _BackButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white60,
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
      width: 34.w,
      height: 34.w,
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
            color: AppPallete.primaryBlue.withOpacity(0.45),
            blurRadius: 12,
            offset: const Offset(0, 3),
          )
        ]
            : [],
      ),
      child: Center(
        child: done
            ? Icon(Icons.check_rounded, size: 15.sp, color: Colors.white)
            : Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12.sp,
            fontWeight: FontWeight.w700,
            color: active ? Colors.white : Colors.white30,
          ),
        ),
      ),
    );
  }
}

// ─── Input Field ──────────────────────────────────────────────────────────

class _InputField extends StatelessWidget {
  final String label;
  final Widget child;

  const _InputField({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white38,
            letterSpacing: 0.9,
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
      hintStyle: GoogleFonts.poppins(color: Colors.white24, fontSize: 14.sp),
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
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 15.sp),
            decoration: _dec("Your full name", Icons.person_outline_rounded),
          ),
        ),
        SizedBox(height: 20.h),
        _InputField(
          label: "PHONE NUMBER",
          child: TextField(
            controller: phoneCont,
            keyboardType: TextInputType.phone,
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 15.sp),
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
                  Container(
                    width: 36.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: Colors.white12,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Text("Salary Day",
                      style: GoogleFonts.poppins(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white)),
                  SizedBox(height: 4.h),
                  Text("Which day do you get paid?",
                      style: GoogleFonts.poppins(
                          fontSize: 13.sp, color: Colors.white38)),
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
                        gradient: LinearGradient(colors: [
                          AppPallete.primaryBlue,
                          AppPallete.primaryBlue.withOpacity(0.7)
                        ]),
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      child: Center(
                        child: Text(
                          "Confirm ${_getDayLabel(selectedDay)}",
                          style: GoogleFonts.poppins(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.white),
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
          _InputField(
            label: "MONTHLY INCOME",
            child: MoneyTextField(controller: incomeCont, label: "Enter amount"),
          ),
          SizedBox(height: 20.h),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("SAVINGS GOAL",
                      style: GoogleFonts.poppins(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white38,
                          letterSpacing: 0.9)),
                  Container(
                    padding:
                    EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
                    decoration: BoxDecoration(
                      color: AppPallete.primaryBlue.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                          color: AppPallete.primaryBlue.withOpacity(0.3)),
                    ),
                    child: Text("${sliderValue.toInt()}%",
                        style: GoogleFonts.poppins(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w700,
                            color: AppPallete.primaryBlue)),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              MySlider(onchanged: onSliderChanged, myvalue: sliderValue),
            ],
          ),
          SizedBox(height: 20.h),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("SALARY DAY",
                  style: GoogleFonts.poppins(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white38,
                      letterSpacing: 0.9)),
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
                                fontWeight: FontWeight.w500),
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
                        Text(savingsMessage,
                            style: GoogleFonts.poppins(
                                fontSize: 12.sp, color: Colors.white54)),
                        Text(
                          "Saving ${CurrencyFormatter.compact(savings)} / month",
                          style: GoogleFonts.poppins(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                              color: AppPallete.primaryBlue),
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