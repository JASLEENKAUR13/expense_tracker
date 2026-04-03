
import 'package:expense_tracker/features/Expense/Presentation/widgets/quickViewCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../common/functions/CurrencyFormater.dart';
import '../../provider/ExpenseListProvider.dart';
import '../../../../common/theme/AppPallete.dart';

class QuickViewContainer extends ConsumerWidget {
  const QuickViewContainer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expenses = ref.watch(expenseProvider);
    final balance = ref.watch(budgetProvider);
    final income = ref.watch(incomeProvider);





    return Container(
      height: 220,
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppPallete.primaryBlue,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5, left: 8),
            child: Text(
              "Total Balance",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 20,
                color: Colors.white60,
              ),
            ),
          ),

          const SizedBox(height: 7),

          Text(
            CurrencyFormatter.compact(balance),         // ✅ live value now
            style: GoogleFonts.poppins(
              fontSize: 42,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                child: QuickViewcard(label: 'Income', amount: income, icon: Icons.arrow_upward_sharp,
                  color: AppPallete.incomeGreen,

                ),
              ),
              Expanded(
                child: QuickViewcard(label: "Spent", amount: expenses, icon: Icons.arrow_downward_sharp,
                  color: AppPallete.expenseRed,

                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}