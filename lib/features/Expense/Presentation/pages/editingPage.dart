
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../common/Widgets/AlertDialogBox.dart';
import '../../../../common/functions/CurrencyFormater.dart';
import '../../../../common/functions/money_textfield.dart';
import '../../../../common/theme/AppPallete.dart';
import '../../expense.dart';
import '../../provider/ExpenseListProvider.dart';
import '../functions/datepicker.dart';
import '../widgets/StatusPill.dart';
import '../../../Category/presentation/categoryPillRow.dart';
import '../widgets/text_field.dart';

class EditingPage  extends ConsumerStatefulWidget {
  final Expense exp;
   EditingPage({super.key, required this.exp});

  @override
  ConsumerState<EditingPage> createState() => _State();
}

class _State extends ConsumerState<EditingPage> {
  TextEditingController DateController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  DateTime? selectedDate;
  late bool iscredited;

  int? selectedCategory =null ;



  Future<void> selectDate() async{
    final pickeddate = await pickDate(context: context ,
        initialDate: selectedDate);

    if(pickeddate != null){
      setState(() {
        selectedDate = pickeddate;
        DateController.text = "${selectedDate?.day}/${selectedDate?.month}/${selectedDate?.year}";
      });

    }
  }

  @override
  void initState() {
    super.initState();
    // pre-fill everything from the passed expense
    titleController.text = widget.exp.title;
    amountController.text = widget.exp.amount.toString();
    noteController.text = widget.exp.note;
    selectedDate = widget.exp.created_at;
    DateController.text = "${widget.exp.created_at.day}/${widget.exp.created_at.month}/${widget.exp.created_at.year}";
    iscredited = widget.exp.is_credited;
    selectedCategory = widget.exp.category_id;

  }
  @override
  Widget build(BuildContext context) {

    return  Scaffold(
      //backgroundColor: AppPallete.textPrimary,
      appBar:  AppBar(
        title: Center(child : Text("Edit Expense" ,
            style: GoogleFonts.poppins(fontSize: 18.sp ,
                fontWeight: FontWeight.w500 , color: AppPallete.textPrimary)) ,

        ),





        backgroundColor:  AppPallete.background,
        actions:[

          IconButton(onPressed: () async{

             final confirm = await AlertDialogBox(
              context,
              "Delete Transaction",
              "Are you sure you want to delete this transaction",
               "Delete"
            );
            if(confirm == true) {
              await ref.read(ItemListProvider.notifier).deleteExpense(
                  widget.exp.id);
              Navigator.pop(context);
            }
    }, icon: Icon(Icons.delete, color: AppPallete.expenseRed),)


        ]
      ),

      body: Padding(padding: EdgeInsets.all(12.w) ,
        child:
        Container(
          child: Column(
            children: [


               SizedBox(height: 20.h,) ,
              GestureDetector(
                onTap: ()=>setState(()=> iscredited = !iscredited),

                child: StatusPill(isCredited: iscredited , onChanged: (value) {
                  setState(() {
                    iscredited = value;
                  });
                },),
              ),
              SizedBox(height: 8.h,) ,
              textField(placeholder: "Add title", mycontroller: titleController, isString: true, icon: Icons.title),
               SizedBox(height: 8.h,) ,
              MoneyTextField(controller: amountController, label: "Enter Amount"),
               SizedBox(height: 8.h,) ,
              textField(placeholder: "Add Note", mycontroller: noteController, isString: true, icon: Icons.note , maxLines: 3  ),
               SizedBox(height: 8.h,) ,
              InkWell( onTap: selectDate,
                child : AbsorbPointer(child: textField(placeholder: "Select a date",
                    mycontroller: DateController,
                    isString: false, icon: Icons.calendar_month)),),
               SizedBox(height: 8.h,) ,
              CategoryPillsRow(onCategorySelected: (category){
                setState(() {
                  selectedCategory = category;

                });
              } , selectedCategoryId: widget.exp.category_id,),
               SizedBox(height: 8.h,) ,





               Spacer(),
              SizedBox(
                width: double.infinity,
                height: 48.h ,
                child: ElevatedButton(onPressed: () async{
                  final dateToSave = selectedDate ?? DateTime.now();
                  print("triggered to save tran!");

                  if(titleController.text.isEmpty || amountController.text.isEmpty
                      || DateController.text.isEmpty){
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Input Required Details !")),
                    );

                  }
                  final updatedExp = widget.exp.copyWith(
                    title: titleController.text,
                    amount: CurrencyFormatter.parse(amountController.text),
                    note: noteController.text,
                    created_at: dateToSave,
                    is_credited: iscredited,
                    category_id: selectedCategory


                  );
                  await ref.read(ItemListProvider.notifier).updateItem(updatedExp);




                  print("data updated!");
                  Navigator.pop(context);


                },
                    style:ElevatedButton.styleFrom(
                        backgroundColor: AppPallete.primaryBlue,
                        foregroundColor: AppPallete.background,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.r)
                        )
                    )

                    ,child:  Text("Update ")),
              ) ,



            ],
          ),

        ),),

    );
  }
}
