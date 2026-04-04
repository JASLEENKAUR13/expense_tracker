

import 'package:expense_tracker/common/theme/AppPallete.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../expense.dart';
import '../../provider/ExpenseListProvider.dart';
import '../widgets/FilterSheet.dart';
import '../widgets/listcard.dart';

class  AlltransactionPage extends ConsumerStatefulWidget {
  const AlltransactionPage({super.key});

  @override
  ConsumerState<AlltransactionPage> createState() => _State();
}

class _State extends ConsumerState<AlltransactionPage> {

  String selectedFilter = "All"; // ← default



  @override
  Widget build(BuildContext context) {


    late final list = ref.watch(ItemListProvider);


    Map<String , List<Expense>> groupByDate(List<Expense> expenses){

      final Map<String , List<Expense>> grouped = {};

      for(final expense in expenses){
        final key = DateFormat('d MMM yyyy').format(expense.created_at);

        if(grouped[key] == null ) grouped[key] = [];
        grouped[key]!.add(expense);

      }

      return grouped;
    }

    final filteredList = selectedFilter == "All"?
        list : list.where((e) =>  selectedFilter == "Income" ?
    e.is_credited : !e.is_credited).toList();

    final grouped = groupByDate(filteredList);




    return Scaffold(

      appBar: AppBar(

        title: Center(child: Text("All Transaction" ,
          style: GoogleFonts.poppins(
          fontWeight: FontWeight.bold,
          fontSize: 24
        ),)),

        actions: [
          IconButton(onPressed: () async
          {final result = await showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: AppPallete.background,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            builder: (context) => FilterSheet(currentFilter: selectedFilter),
          );
            if(result != null) setState(() => selectedFilter = result);

            },



              icon: Icon(Icons.filter_list ,
            color: AppPallete.textPrimary,
                fontWeight: FontWeight.w500,))
        ],


      ),

      body: Padding(padding: EdgeInsets.all(10) ,
      child:  Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (selectedFilter != "All")
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Chip(
                label: Text(selectedFilter),
                deleteIcon: Icon(Icons.close, size: 16),
                onDeleted: () => setState(() => selectedFilter = "All"),
                backgroundColor: AppPallete.primaryBlue,
                labelStyle: GoogleFonts.poppins(color: AppPallete.textPrimary , fontWeight: FontWeight.bold),
                deleteIconColor: Colors.white,
              ),
            ),
         Expanded (child : ListView.builder(
            itemCount: grouped.keys.length,
            itemBuilder: (context, index) {
              final date = grouped.keys.elementAt(index);
              final transactions = grouped[date]!;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date header
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(date,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppPallete.textPrimary.withOpacity(0.8)
                        )),
                  ),

                  // Transactions under this date
                  ...transactions.map((exp) =>
                      ListCard(currentExp: exp)),
                ],
              );
            },
          ),)
        ],
      ),

      ),
    );
  }
}
