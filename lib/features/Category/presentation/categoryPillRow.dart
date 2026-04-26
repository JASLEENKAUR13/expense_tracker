import 'package:expense_tracker/common/theme/AppPallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../category.dart';
import '../provider/CategoryProvider.dart';

class CategoryPillsRow extends ConsumerStatefulWidget {
  final int? initialCategory;
  final Function(int) onCategorySelected; // Callback when category is selected

   CategoryPillsRow({
    Key? key,
    required this.onCategorySelected, this.initialCategory,
  }) : super(key: key);



  @override
  ConsumerState<CategoryPillsRow> createState() => _CategoryPillsRowState();
}

class _CategoryPillsRowState extends ConsumerState<CategoryPillsRow> {
  late int? selectedCategory; // ✅ Changed to late

  @override
  void initState() {
    super.initState();
    selectedCategory = widget.initialCategory; // ✅ Set from prop
  }



  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoryProvider);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 12.0.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label
         Text(
            'Select Category',
            style: TextStyle(
              color: AppPallete.textSecondary, // textSecondary
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 10.h),

          // Pills Row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: categories.map((category) {
                bool isSelected = selectedCategory == category.id;

                return Padding(
                  padding:  EdgeInsets.only(right: 8.0.w),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedCategory= category.id;
                      });
                      // Call the callback to notify parent
                      widget.onCategorySelected(category.id);
                    },
                    child: Container(
                      padding:  EdgeInsets.symmetric(
                        horizontal: 12.0.w,
                        vertical: 8.0.h,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ?  AppPallete.primaryBlue
                            :  AppPallete.surface, // surface when not selected
                        borderRadius: BorderRadius.circular(20.r),
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
                          fontSize: 13.sp,
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