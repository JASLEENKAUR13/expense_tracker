import 'package:expense_tracker/features/Expense/Presentation/pages/alltransactionpage.dart';
import 'package:expense_tracker/features/profile/presentation/pages/profilePage.dart';
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
      drawer: Drawer(
        elevation: 1,
        backgroundColor: AppPallete.background, // dark navy background
        surfaceTintColor: Colors.transparent,   // removes Material 3 tint
        child: ListView(
          padding: EdgeInsets.zero,
          children: [

            // Header
            DrawerHeader(
              decoration: BoxDecoration(color: AppPallete.surface),
              child: Text(
                'Expenso',
                style: TextStyle(
                  color: AppPallete.textPrimary,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Menu Items
            ListTile(
              leading: Icon(Icons.dashboard, color: AppPallete.primaryBlue),
              title: Text('Dashboard', style: TextStyle(color: AppPallete.textPrimary)),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const MyHomePage()),
                      (route) => false,
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.receipt_long, color: AppPallete.primaryBlue),
              title: Text('All Transactions', style: TextStyle(color: AppPallete.textPrimary)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const AlltransactionPage() ));

              },
            ),
            ListTile(
              leading: Icon(Icons.analytics, color: AppPallete.primaryBlue),
              title: Text('Analytics', style: TextStyle(color: AppPallete.textPrimary)),
              onTap: () {
                //Navigator.pop(context);
               // Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePage() ));
              },
            ),

            SizedBox(height: 400), // pushes profile down — adjust if needed

            // Profile at bottom
            ListTile(
              leading: Icon(Icons.person, color: AppPallete.textSecondary),
              title: Text('Profile', style: TextStyle(color: AppPallete.textSecondary , fontWeight: FontWeight.bold)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePage() ));
              },
            ),

          ],
        ),
      ),
      appBar: AppBar(
        actions: [
          IconButton(onPressed: ()=>{

            Navigator.push(context, MaterialPageRoute(builder: (context) =>

            const AddExpensepage()))
          } ,
              icon : Icon(Icons.add ,
                  color: AppPallete.primaryBlue, size : 25 ,
                  fontWeight: FontWeight.bold)) ,






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
