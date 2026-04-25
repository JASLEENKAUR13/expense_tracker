import 'package:expense_tracker/common/theme/AppPallete.dart';
import 'package:expense_tracker/features/profile/provider/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../common/functions/money_textfield.dart';
import '../../../Expense/Presentation/widgets/text_field.dart';

class ProfileEditingPage extends ConsumerStatefulWidget {
  const ProfileEditingPage({super.key});

  @override
  ConsumerState<ProfileEditingPage> createState() => _State();
}

class _State extends ConsumerState<ProfileEditingPage> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _incomeController = TextEditingController();
  final _savingsController = TextEditingController();
  final salaryDayController = TextEditingController();


  final user = Supabase.instance.client.auth.currentUser;

  @override
  void initState() {
    super.initState();
    _nameController.text = user?.userMetadata?['name'] ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _incomeController.dispose();
    _savingsController.dispose();
    salaryDayController.dispose();
    super.dispose();
  }

  bool isValidPhone(String phone) => RegExp(r'^[0-9]{10}$').hasMatch(phone);

  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: GoogleFonts.poppins(
        fontSize: 12.sp,
        fontWeight: FontWeight.w500,
        color: AppPallete.textSecondary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(profileProvider);

    profileAsync.whenData((profile) {
      if (profile != null) {
        if (_nameController.text.isEmpty ||
            _nameController.text == user?.userMetadata?['name']) {
          _nameController.text =
              profile.user_name ?? user?.userMetadata?['name'] ?? '';
        }
        if (_phoneController.text.isEmpty) {
          _phoneController.text =
          profile.phone_no != 0 ? '${profile.phone_no}' : '';
        }
        if (_incomeController.text.isEmpty) {
          _incomeController.text = '${profile.income_montly}';
        }
        if (_savingsController.text.isEmpty) {
          _savingsController.text = '${profile.savingsGoalPerc}';
        }
        if(salaryDayController.text.isEmpty){
          salaryDayController.text = '${profile.salary_day}';
        }
      }
    });

    return Scaffold(
      backgroundColor: AppPallete.background,
      appBar: AppBar(
        backgroundColor: AppPallete.background,
        elevation: 0,
        iconTheme: IconThemeData(color: AppPallete.textPrimary),
        title: Text(
          "Edit Profile",
          style: GoogleFonts.poppins(
            fontSize: 20.sp,
            fontWeight: FontWeight.w500,
            color: AppPallete.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10.h),

                  // ── Personal Info Section ──
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: AppPallete.cardWhite,
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Personal Info",
                          style: GoogleFonts.poppins(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w600,
                            color: AppPallete.textPrimary.withOpacity(0.8),
                          ),
                        ),
                        SizedBox(height: 16.h),
                        _buildSectionLabel("Full Name"),
                        SizedBox(height: 6.h),
                        textField(
                          mycontroller: _nameController,
                          placeholder: "Enter your name",
                          icon: Icons.person_outline,
                          isString: true,
                        ),
                        SizedBox(height: 14.h),
                        _buildSectionLabel("Phone Number"),
                        SizedBox(height: 6.h),
                        textField(
                          mycontroller: _phoneController,
                          placeholder: "Enter your phone number",
                          icon: Icons.phone_outlined,
                          isString: true,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 16.h),

                  // ── Finances Section ──
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: AppPallete.cardWhite,
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Finances",
                          style: GoogleFonts.poppins(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w600,
                            color: AppPallete.textPrimary.withOpacity(0.8),
                          ),
                        ),
                        SizedBox(height: 16.h),
                        _buildSectionLabel("Monthly Income (₹)"),
                        SizedBox(height: 6.h),
                        MoneyTextField(
                          controller: _incomeController,
                          label: "Enter monthly income",
                        ),
                        SizedBox(height: 14.h),
                        _buildSectionLabel("Savings Goal (%)"),
                        SizedBox(height: 6.h),
                        textField(
                          mycontroller: _savingsController,
                          placeholder: "e.g. 30",
                          icon: Icons.savings_outlined,
                          isString: true,
                        ),


                        SizedBox(height: 14.h),
                        _buildSectionLabel("Salary Day (1-30)"),
                        SizedBox(height: 6.h),

                        textField(
                          mycontroller: salaryDayController,
                          placeholder: "e.g. 1",
                          icon: Icons.payment,
                          isString: true,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 16.h),
                ],
              ),
            ),
          ),

          // ── Save Button ──
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 24.h),
            child: SizedBox(
              width: double.infinity,
              height: 52.h,
              child: ElevatedButton(
                onPressed: () {
                  if (_phoneController.text.isNotEmpty &&
                      !isValidPhone(_phoneController.text)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Invalid Phone Number!")),
                    );
                    return;
                  }
                  if (_nameController.text.isEmpty ||
                      _phoneController.text.isEmpty ||
                      _incomeController.text.isEmpty ||
                      _savingsController.text.isEmpty || salaryDayController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Input Required Details!")),
                    );
                    return;
                  }
                  ref.read(profileProvider.notifier).updateProfile(
                    userName: _nameController.text.trim(),
                    phoneNo: int.parse(_phoneController.text.trim()),
                    monthlyIncome:
                    int.parse(_incomeController.text.trim()),
                    savingsGoalPerc:
                    int.parse(_savingsController.text.trim()),
                    salary_day: int.parse(salaryDayController.text)
                  );
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppPallete.primaryBlue,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                ),
                child: Text(
                  "Save Changes",
                  style: GoogleFonts.poppins(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppPallete.textPrimary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}