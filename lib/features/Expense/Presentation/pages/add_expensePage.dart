
import 'dart:io';

import 'dart:ui';

import 'package:expense_tracker/common/functions/money_textfield.dart';
import 'package:expense_tracker/features/Category/presentation/categoryPillRow.dart';
import 'package:expense_tracker/features/Expense/provider/ExpenseListProvider.dart';
import 'package:expense_tracker/features/Expense/Presentation/functions/datepicker.dart';
import 'package:expense_tracker/features/Expense/Presentation/functions/pickImage.dart';
import 'package:expense_tracker/common/theme/AppPallete.dart';
import 'package:expense_tracker/features/Expense/Presentation/widgets/StatusPill.dart';
import 'package:flutter/cupertino.dart' hide Size;
import 'package:flutter/material.dart' hide Size;
import 'package:google_fonts/google_fonts.dart';

import '../../../../common/functions/CurrencyFormater.dart';
import '../widgets/text_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddExpensepage extends ConsumerStatefulWidget {
  const AddExpensepage({super.key});

  @override
  ConsumerState<AddExpensepage> createState() => _AddExpensepageState();
}

class _AddExpensepageState extends ConsumerState<AddExpensepage> {
  TextEditingController DateController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  late int? selectedCategory =null ;



  //
  // File? image ;
  // final imagePickerFunction = ImagePickerFunction();
  DateTime? selectedDate;

  // Future<void> selectImage() async{
  //   final curimage = await imagePickerFunction.pickImage();
  //
  //   if(curimage != null){
  //     setState(() {
  //       image = curimage;
  //
  //     });
  //   }
  // }

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
  bool isCredited=false;



  @override
  void dispose() {
    // TODO: implement initState
   titleController.dispose();
    amountController.dispose();
    noteController.dispose();
    DateController.dispose();
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {

    return  Scaffold(
      //backgroundColor: AppPallete.textPrimary,
      appBar:  AppBar(
        title: Center(child : Text("Add Expense" ,
            style: GoogleFonts.poppins(fontSize: 25 ,
                fontWeight: FontWeight.w500 , color: AppPallete.textPrimary)) ,

        ),





        backgroundColor:  AppPallete.background,
      ),

          body: Padding(padding: EdgeInsets.all(10) ,
            child:
            Container(
              child: Column(
                children: [

                  // InkWell(
                  //   onTap: selectImage,
                  //     child : Container(
                  //   height: 220,
                  //   width : double.infinity,
                  //
                  //   decoration: BoxDecoration(
                  //     color: AppPallete.primaryBlue,
                  //     borderRadius: BorderRadius.circular(22),
                  //   ),
                  //   child: image != null ?
                  //       ClipRRect(
                  //         borderRadius: BorderRadius.circular(22),
                  //           child: Image.file(
                  //             image!,
                  //             fit : BoxFit.cover,
                  //             width: double.infinity,
                  //
                  //           ),
                  //       )
                  //       : Center(child: IconButton(onPressed:  ()=>{selectImage()},
                  //       icon: Icon(Icons.add_a_photo_rounded ,
                  //         size: 40, fontWeight: FontWeight.bold ,
                  //       color: AppPallete.background),),
                  // )
                  //
                  //
                  //
                  // )) ,
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
                  CategoryPillsRow(onCategorySelected: (category){
                    setState(() {
                      selectedCategory = category;

                    });
                  }),

                  const SizedBox(height:10),
                  GestureDetector(
                    onTap: ()=>setState(()=> isCredited = !isCredited),

                    child: StatusPill(isCredited: isCredited),
                  ),



                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    height: 50 ,
                    child: ElevatedButton(onPressed: () async{
                        final dateToSave = selectedDate ?? DateTime.now();
                        print("triggered to save tran!");

                        if(titleController.text.isEmpty || amountController.text.isEmpty
                             || DateController.text.isEmpty || selectedCategory == null){
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Input Required Details !")),
                          );

                        }

                        await ref.read(ItemListProvider.notifier).addItem(


                          titleController.text,
                          CurrencyFormatter.parse(amountController.text),
                          noteController.text,
                          dateToSave,
                          isCredited,
                          selectedCategory!
                        );
                        print("data added!");
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

                        ,child: const Text("Save")),
                  ) ,


                  const SizedBox(height: 35,),



                ],
              ),

            ),),

    );
  }
}
