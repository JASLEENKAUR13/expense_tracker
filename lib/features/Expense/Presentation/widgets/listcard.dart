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
            children: [
              // LEFT SIDE (icon + text)
              Expanded( // 👈 THIS is where Expanded should be
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: categoryColor.withOpacity(0.25),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        categoryIcon,
                        color: categoryColor,
                        size: 20,
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded( // 👈 THIS controls text width
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.currentExp.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          const SizedBox(height: 4),

                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  matchedCategory?.name ?? "Other",
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: AppPallete.textSecondary,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                DateFormat('d MMM yyyy')
                                    .format(widget.currentExp.created_at),
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  color: AppPallete.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              // RIGHT SIDE (amount)
              Text(
                (widget.currentExp.is_credited ? "+" : "-") +
                    CurrencyFormatter.compact(widget.currentExp.amount),
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: widget.currentExp.is_credited
                      ? AppPallete.incomeGreen
                      : AppPallete.expenseRed,
                ),
              ),
            ],
          )
        ),
      ),
    );
  }
}