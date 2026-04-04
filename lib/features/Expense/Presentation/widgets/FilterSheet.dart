import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../common/theme/AppPallete.dart';

class FilterSheet extends ConsumerStatefulWidget {
  final String currentFilter; //
  const FilterSheet({super.key, required this.currentFilter});

  @override
  ConsumerState<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends ConsumerState<FilterSheet> {
  late String selectedType = widget.currentFilter;


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Filters", style: GoogleFonts.poppins(
              fontSize: 22, fontWeight: FontWeight.w600,
              color: AppPallete.textPrimary
          )),
          SizedBox(height: 20),
          Row(
            children: ["All", "Income", "Expense"].map((type) {
              final isSelected = selectedType == type;
              return GestureDetector(
                onTap: () => setState(() => selectedType = type),
                child: Container(
                  margin: EdgeInsets.only(right: 8),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? AppPallete.primaryBlue : AppPallete.surface,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(type, style: GoogleFonts.poppins(
                    fontSize: 13, fontWeight: FontWeight.w500,
                    color: isSelected ? Colors.white : AppPallete.textPrimary,
                  )),
                ),
              );
            }).toList(),
          ),

          SizedBox(height: 30),

          // Apply button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context, selectedType),

              style: ElevatedButton.styleFrom(
                  backgroundColor: AppPallete.primaryBlue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))
              ),
              child: Text("Apply", style: GoogleFonts.poppins(
                  color: Colors.white, fontWeight: FontWeight.w600
              )),
            ),
          ),
          SizedBox(height: 20),

        ],
      ),
    );
  }
}