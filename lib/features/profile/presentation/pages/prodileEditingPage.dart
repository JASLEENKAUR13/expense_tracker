import 'package:expense_tracker/common/theme/AppPallete.dart';
import 'package:expense_tracker/features/profile/provider/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  final user = Supabase.instance.client.auth.currentUser;

  @override
  void initState() {
    super.initState();

    final username = user?.userMetadata?['name'] ?? '';
    _nameController.text = username;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _incomeController.dispose();
    _savingsController.dispose();
    super.dispose();
  }

  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: GoogleFonts.poppins(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: AppPallete.textSecondary,
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(profileProvider);

    // Pre-fill fields once profile data loads
    profileAsync.whenData((profile) {
      if (profile != null) {
        if (_nameController.text.isEmpty || _nameController.text == user?.userMetadata?['name']) {
          _nameController.text = profile.user_name ?? user?.userMetadata?['name'] ?? '';
        }
        if (_phoneController.text.isEmpty) {
          _phoneController.text = profile.phone_no != 0 ? '${profile.phone_no}' : '';
        }
        if (_incomeController.text.isEmpty) {
          _incomeController.text = '${profile.income_montly}';
        }
        if (_savingsController.text.isEmpty) {
          _savingsController.text = '${profile.savingsGoalPerc}';
        }
      }
    });

    return Scaffold(
      backgroundColor: AppPallete.background,
      appBar: AppBar(
        backgroundColor: AppPallete.background,
        title: Text(
          "Edit Profile",
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.w500,
            color: AppPallete.textPrimary,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppPallete.textPrimary),
      ),

      // ── Column wraps scroll + button so button sticks to bottom ──
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),

                  // ── Personal Info Section ──
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppPallete.cardWhite,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Personal Info",
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppPallete.textPrimary.withOpacity(0.8),
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildSectionLabel("Full Name"),
                        const SizedBox(height: 6),
                        textField(
                          mycontroller: _nameController,
                          placeholder: "Enter your name",
                          icon: Icons.person_outline,
                          isString: true,
                        ),
                        const SizedBox(height: 14),
                        _buildSectionLabel("Phone Number"),
                        const SizedBox(height: 6),
                       textField(
                          mycontroller: _phoneController,
                          placeholder : "Enter your phone number",
                          icon: Icons.phone_outlined, isString: true,

                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ── Finances Section ──
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppPallete.cardWhite,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Finances",
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppPallete.textPrimary.withOpacity(0.8),
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildSectionLabel("Monthly Income (₹)"),
                        const SizedBox(height: 6),
                        MoneyTextField (
                          controller: _incomeController,
                          label: "Enter monthly income",

                        ),
                        const SizedBox(height: 14),
                        _buildSectionLabel("Savings Goal (%)"),
                        const SizedBox(height: 6),
                       textField(
                          mycontroller: _savingsController,
                          placeholder: "e.g. 30",
                          icon: Icons.savings_outlined,
                          isString: true,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),

          // ── Save Button always sticks to bottom ──
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  if(_nameController.text.isEmpty || _phoneController.text.isEmpty ||
                      _incomeController.text.isEmpty || _savingsController.text.isEmpty){
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Input Required Details !")),
                    );

                  }

                  ref.watch(profileProvider.notifier).updateProfile(userName: _nameController.text.trim(), 
                      phoneNo:int.parse( _phoneController.text.trim(),),
                      monthlyIncome: int.parse(_incomeController.text.trim()),
                      savingsGoalPerc: int.parse(_savingsController.text.trim())
                  );
                  print("updated profie");
                  Navigator.pop(context);






                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppPallete.primaryBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  "Save Changes",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppPallete.textPrimary,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 20,)
        ],
      ),
    );
  }
}