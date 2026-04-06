
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../common/Widgets/AlertDialogBox.dart';
import '../../../../common/functions/CurrencyFormater.dart';
import '../../../../common/functions/money_textfield.dart';
import '../../../../common/theme/AppPallete.dart';
import '../../expense.dart';
import '../../provider/ExpenseListProvider.dart';
import '../functions/datepicker.dart';
import '../widgets/StatusPill.dart';
import '../widgets/text_field.dart';

class EditingPage  extends ConsumerStatefulWidget {
  final Expense exp;
  const EditingPage({super.key, required this.exp});

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
  }
  @override
  Widget build(BuildContext context) {

    return  Scaffold(
      //backgroundColor: AppPallete.textPrimary,
      appBar:  AppBar(
        title: Center(child : Text("Edit Expense" ,
            style: GoogleFonts.poppins(fontSize: 25 ,
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

      body: Padding(padding: EdgeInsets.all(10) ,
        child:
        Container(
          child: Column(
            children: [


              const SizedBox(height: 30,) ,
              textField(placeholder: "Add title", mycontroller: titleController, isString: true, icon: Icons.title),
              const SizedBox(height: 10,) ,
              MoneyTextField(controller: amountController, label: "Enter Amount"),
              const SizedBox(height: 10,) ,
              textField(placeholder: "Add Note", mycontroller: noteController, isString: true, icon: Icons.note , maxLines: 3  ),
              const SizedBox(height: 10,) ,
              InkWell( onTap: selectDate,
                child : AbsorbPointer(child: textField(placeholder: "Select a date",
                    mycontroller: DateController,
                    isString: false, icon: Icons.calendar_month)),),
              const SizedBox(height: 10,) ,
              GestureDetector(
                onTap: ()=>setState(()=> iscredited = !iscredited),

                child: StatusPill(isCredited: iscredited),
              ),



              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 50 ,
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
                            borderRadius: BorderRadius.circular(14)
                        )
                    )

                    ,child: const Text("Update ")),
              ) ,



            ],
          ),

        ),),

    );
  }
}
