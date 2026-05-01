
import 'dart:io';

import 'dart:ui';

import 'package:expense_tracker/common/functions/money_textfield.dart';
import 'package:expense_tracker/features/Category/presentation/categoryPillRow.dart';
import 'package:expense_tracker/features/Expense/provider/ExpenseListProvider.dart';
import 'package:expense_tracker/features/Expense/Presentation/functions/datepicker.dart';

import 'package:expense_tracker/common/theme/AppPallete.dart';
import 'package:expense_tracker/features/Expense/Presentation/widgets/StatusPill.dart';
import 'package:flutter/cupertino.dart' hide Size;
import 'package:flutter/material.dart' hide Size;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../common/functions/CurrencyFormater.dart';
import '../../../Category/services/AiCategoryProvider.dart';
import '../../../Category/services/gemini_services.dart';
import '../widgets/text_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddExpensepage extends ConsumerStatefulWidget {
   AddExpensepage({super.key});

  @override
  ConsumerState<AddExpensepage> createState() => _AddExpensepageState();
}

class _AddExpensepageState extends ConsumerState<AddExpensepage> {
  TextEditingController DateController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  late int? selectedCategory =null ;


  @override
  void initState() {
    super.initState();
    // ✅ Listen to title changes → trigger AI category suggestion
    titleController.addListener(_onTitleChanged);


    ref.listenManual<AiCategoryState>(
      aiCategoryProvider,
          (previous, next) {
        if (next.status == AiCategoryStatus.done &&
            next.suggestedCategoryId != null) {
          setState(() {
            selectedCategory = next.suggestedCategoryId;
          });
        }
      },
    );
  }
  // ─────────────────────────────────────────────────────
  void _onTitleChanged() {
    ref
        .read(aiCategoryProvider.notifier)
        .onTitleChanged(titleController.text);
  }



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

   titleController.removeListener(_onTitleChanged);
   titleController.dispose();
    amountController.dispose();
    noteController.dispose();
    DateController.dispose();
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    final aiCategory = ref.watch(aiCategoryProvider);


    return  Scaffold(
      //backgroundColor: AppPallete.textPrimary,
      appBar:  AppBar(
        centerTitle: true,
        title: Text("Add Expense" ,
            style: GoogleFonts.poppins(
                fontSize: 18.sp,

                fontWeight: FontWeight.w500 ,
                color: AppPallete.textPrimary)) ,


        backgroundColor:  AppPallete.background,
      ),

          body: Padding(padding: EdgeInsets.all(12.w) ,
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



                  SizedBox(height: 20.h,) ,
                  GestureDetector(
                    onTap: ()=>setState(()=> isCredited = !isCredited),

                    child: StatusPill(isCredited: isCredited , onChanged: (value){
                      setState(() {
                        isCredited = value;
                      });
                    },),
                  ),
                   SizedBox(height: 8.h,) ,
                  textField(placeholder: "Add title",
                      mycontroller: titleController,
                      isString: true, icon: Icons.title),
                   SizedBox(height: 8.h,) ,
                  _buildAiCategoryHint(aiCategory),
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
                  CategoryPillsRow(
                    onCategorySelected: (category) {
                      setState(() {
                        selectedCategory = category;

                        // reset AI suggestion
                        ref.read(aiCategoryProvider.notifier).reset();
                      });
                    },

                    selectedCategoryId: selectedCategory,
                  ),
                   SizedBox(height:8.h),




                  Spacer(),

                  SizedBox(
                    width: double.infinity,
                    height: 48.h ,
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
                            borderRadius: BorderRadius.circular(12.r)
                          )
                        )

                        ,child:  Text("Save" ,
                          style: GoogleFonts.poppins(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),)),
                  ) ,

                  SizedBox(height: 32.h,)






                ],
              ),

            ),),

    );
  }
}


Widget _buildAiCategoryHint(AiCategoryState aiCategory) {
  if (aiCategory.status == AiCategoryStatus.loading) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(left: 4.w),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 10.w,
              height: 10.h,
              child: CircularProgressIndicator(
                strokeWidth: 1.5,
                color: AppPallete.primaryBlue,
              ),
            ),
            SizedBox(width: 6.w),
            Text(
              'Suggesting category...',
              style: GoogleFonts.poppins(
                fontSize: 11.sp,
                color: Colors.white38,
              ),
            ),
          ],
        ),
      ),
    );
  }

  if (aiCategory.status == AiCategoryStatus.done &&
      aiCategory.suggestedCategoryName != null) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(left: 4.w),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.auto_awesome,
                size: 12.sp, color: AppPallete.primaryBlue),
            SizedBox(width: 4.w),
            Text(
              'AI suggested: ${aiCategory.suggestedCategoryName}',
              style: GoogleFonts.poppins(
                fontSize: 11.sp,
                color: AppPallete.primaryBlue,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  return const SizedBox.shrink();
}