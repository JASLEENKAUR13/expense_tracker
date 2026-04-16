import 'package:expense_tracker/common/functions/CurrencyFormater.dart';
import 'package:expense_tracker/common/theme/AppPallete.dart';
import 'package:expense_tracker/features/Category/provider/CategoryProvider.dart';
import 'package:expense_tracker/features/Expense/Presentation/pages/editingPage.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../Category/category.dart';
import '../../../Category/iconmapper.dart';
import '../../expense.dart';
// ✅ Import the icon mapper

class ListCard extends ConsumerStatefulWidget {
  final Expense currentExp;

  const ListCard({super.key, required this.currentExp});

  @override
  ConsumerState<ListCard> createState() => _ListCardState();
}

class _ListCardState extends ConsumerState<ListCard> {
  @override
  Widget build(BuildContext context) {
    final categories_id = widget.currentExp.category_id;
    final categories = ref.watch(categoryProvider);

    // ✅ Find the matching category
    final Category? matchedCategory = categories.where(
          (category) => category.id == categories_id,
    ).isNotEmpty
        ? categories.firstWhere((category) => category.id == categories_id)
        : null;

    // ✅ Extract icon and color with fallbacks
    final categoryIcon = matchedCategory != null
        ? IconMapper.getIcon(matchedCategory.icon_name)
        : Icons.category;

    final categoryColor = matchedCategory?.color_hex != null
        ? Color(int.parse(matchedCategory!.color_hex.replaceFirst('#', '0xff')))
        : AppPallete.primaryBlue;

    return Card(
      color: AppPallete.cardWhite,
      elevation: 1,
      margin: EdgeInsets.all(8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditingPage(exp: widget.currentExp),
          ),
        ),
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Row(
                  children: [
                    // ✅ UPDATED: Category Icon with Color
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: categoryColor.withOpacity(0.25), // ✅ Category color background
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        categoryIcon, // ✅ Category icon
                        color: categoryColor, // ✅ Category color
                        size: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ✅ Transaction Title
                            Text(
                              widget.currentExp.title,
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            // ✅ NEW: Category Name + Date
                            Row(
                              children: [
                                Text(
                                  matchedCategory?.name ?? "Other",
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: AppPallete.textSecondary,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  DateFormat('d MMM yyyy')
                                      .format(widget.currentExp.created_at),
                                  style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                    color: AppPallete.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
              // ✅ Amount with Income/Expense color
              widget.currentExp.is_credited
                  ? Text(
                "+" + CurrencyFormatter.compact(widget.currentExp.amount),
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppPallete.incomeGreen,
                ),
              )
                  : Text(
                "-" + CurrencyFormatter.compact(widget.currentExp.amount),
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppPallete.expenseRed,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}