import 'package:expense_tracker/common/theme/AppPallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../Category/category.dart';
import '../../../Category/provider/CategoryProvider.dart';

class CategoryPillsRow extends ConsumerStatefulWidget {
  final Function(int) onCategorySelected; // Callback when category is selected

  const CategoryPillsRow({
    Key? key,
    required this.onCategorySelected,
  }) : super(key: key);

  @override
  ConsumerState<CategoryPillsRow> createState() => _CategoryPillsRowState();
}

class _CategoryPillsRowState extends ConsumerState<CategoryPillsRow> {
  int? selectedCategory = null;



  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoryProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label
          const Text(
            'Select Category',
            style: TextStyle(
              color: AppPallete.textSecondary, // textSecondary
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),

          // Pills Row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: categories.map((category) {
                bool isSelected = selectedCategory == category.id;

                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedCategory= category.id;
                      });
                      // Call the callback to notify parent
                      widget.onCategorySelected(category.id);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 10.0,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ?  AppPallete.primaryBlue
                            :  AppPallete.surface, // surface when not selected
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ?  AppPallete.primaryBlue
                              :  AppPallete.surface,
                          width: 1.5,
                        ),
                      ),
                      child: Text(
                        category.name,
                        style: TextStyle(
                          color: isSelected
                              ? AppPallete.textPrimary
                              : AppPallete.textSecondary,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}