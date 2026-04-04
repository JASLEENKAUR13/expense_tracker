import 'package:expense_tracker/features/Expense/Presentation/pages/alltransactionpage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../profile/provider/profile_provider.dart';
import '../../provider/ExpenseListProvider.dart';
import '../../../../common/theme/AppPallete.dart';
import '../widgets/listcard.dart';
import '../widgets/quickViewContainer.dart';
import 'add_expensePage.dart';

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key});




  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {


  @override
  Widget build(BuildContext context ) {
    //final provider = ref.watch(ItemListProvider);

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: ()=>{
            Navigator.push(context, MaterialPageRoute(builder: (context) => const AddExpensepage()))
          } ,
              icon : Icon(Icons.add ,
                  color: AppPallete.primaryBlue, size : 25 ,
                  fontWeight: FontWeight.bold)) ,


          IconButton(onPressed: ()=>{
            Navigator.push(context,
                MaterialPageRoute(builder: (context) =>
                const AlltransactionPage()))

          },
              icon: Icon(Icons.menu, color: AppPallete.primaryBlue,
                size: 25, fontWeight: FontWeight.bold,)) ,
          IconButton(
              onPressed: () async {
                ref.invalidate(ItemListProvider);
                ref.invalidate(profileProvider);
                await Supabase.instance.client.auth.signOut();
                print("Logged out!");
                // AuthWrapper will automatically show OnboardingScreen
              },
              icon: Icon(Icons.logout, color: AppPallete.primaryBlue, size: 25)
          ),


        ],

        title: Text(
          "Expenso",
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppPallete.background,
        foregroundColor: AppPallete.primaryBlue,
        elevation: 0,
      ),
      body: Padding(
          padding: const EdgeInsets.all(8),
          child: Container(child :
          Column(
              children :[
                QuickViewContainer(),
                const SizedBox(height: 10) ,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Transactions" ,
                      style: GoogleFonts.poppins(fontSize: 25 , fontWeight: FontWeight.w500 ,
                        color: AppPallete.textPrimary),) ,


                  ],
                ),

                const SizedBox(height: 8) ,
                Expanded(
                    child: Consumer(builder: (context , ref , child){
                      final list = ref.watch(ItemListProvider);

                      final recent = list.take(5).toList(); // ← add this

                      return ListView.builder( itemCount: recent.length,
                        itemBuilder: (context , index) {
                          return ListCard(
                            currentExp: recent[index],
                          );


                        },

                      );})

                ) ,




              ]
          ) ,






          )
      ),
    );
  }

}
