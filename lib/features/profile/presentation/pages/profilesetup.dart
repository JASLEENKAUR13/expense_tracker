

import 'package:expense_tracker/common/functions/money_textfield.dart';
import 'package:expense_tracker/features/Expense/Presentation/pages/HomePage.dart';

import 'package:expense_tracker/features/profile/presentation/widgets/slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../common/functions/CurrencyFormater.dart';
import '../../../../common/theme/AppPallete.dart';
import '../../provider/profile_provider.dart';

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
    income_cont.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    income_cont.dispose();
    super.dispose();
  }

  int get income => CurrencyFormatter.parse(income_cont.text);

  String getSavingsMessage() {
    if (income_cont.text.isEmpty) return "Enter your income";

    final savings = income * (_value / 100);

    if (savings == 0) return "Start saving something 💡";

    if (_value < 10) {
      return "Try to save more 🚀";
    } else if (_value < 20) {
      return "Good start 👍";
    } else if (_value < 35) {
      return "You're doing great 🔥";
    } else {
      return "Financially smart 💰";
    }
  }

  @override
  Widget build(BuildContext context) {


    final savings = income * (_value / 100);

    return Scaffold(
      backgroundColor: AppPallete.textPrimary,
      appBar: AppBar(
        title: Text(
          "Profile SetUp",
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.w500,
            color: AppPallete.textPrimary,
          ),
        ),
        centerTitle: true,
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Column(

            children: [

              const Spacer(),

              /// Top Content
             MoneyTextField(controller: income_cont, label: "Enter Montly Income"),

              const SizedBox(height: 40),

              MySlider(
                onchanged: (val) {
                  setState(() {
                    _value = val.toDouble();
                  });
                },
                myvalue: _value,
              ),

              const SizedBox(height: 60),

              Text(
                getSavingsMessage(),
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: AppPallete.cardWhite,
                ),
              ),

              const SizedBox(height: 5),

              Text(
                "You save ${CurrencyFormatter.compact(savings)}",
                style: GoogleFonts.poppins(
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                  color: AppPallete.iconBackground,
                ),
                //textAlign: TextAlign.center,
              ),

              /// 🔥 Pushes button to bottom
              const Spacer(),

              /// Bottom Button
              TextButton(
                onPressed: ()  async {
                  if(income_cont.text.isEmpty || _value == 0){
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Input Required Details !")),

                    );
                    return;

                  }
                  await ref.read(profileServicesProvider)
                      .saveProfile(monthlyincome: income.toInt() , savingGoalpert: _value.toInt());
                  ref.invalidate(profileProvider);
                  print("data saved");



                },
                style: ButtonStyle(
                  minimumSize: WidgetStatePropertyAll(Size(double.infinity, 56)),
                  foregroundColor: WidgetStatePropertyAll(AppPallete.textPrimary),
                  backgroundColor: WidgetStatePropertyAll(AppPallete.cardWhite),
                  padding: const WidgetStatePropertyAll(
                    EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                  ),
                  elevation: const WidgetStatePropertyAll(8),
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                child: Text(
                  "Start Tracking",
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),


              ),
              const SizedBox(height: 15,)
            ],
          ),
        ),
      ),
    );
  }
}