import 'package:expense_tracker/features/Expense/Presentation/pages/AnalyticsPage.dart';
import 'package:expense_tracker/features/Expense/Presentation/pages/alltransactionpage.dart';
import 'package:expense_tracker/features/Expense/Presentation/widgets/weeklyBarChart.dart';
import 'package:expense_tracker/features/profile/presentation/pages/profilePage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../profile/provider/profile_provider.dart';
import '../../provider/ExpenseListProvider.dart';
import '../../../../common/theme/AppPallete.dart';
import '../../../Category/presentation/categoryPieChart.dart';
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
                Navigator.pop(context);
               Navigator.push(context, MaterialPageRoute(builder: (context) => const AnalyticsPage() ));
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
          child: SingleChildScrollView(
            child: Container(child :
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
                children :[
                  QuickViewContainer(),
                  const SizedBox(height: 10) ,







                  Consumer(
                    builder: (context, ref, child) {
                      final list = ref.watch(ItemListProvider);
                      final recent = list.take(5).toList();

                      if (list.isEmpty) {
                        return SizedBox(
                          height: MediaQuery.of(context).size.height * 0.6,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.track_changes,
                                  size: 70,
                                  color: AppPallete.textSecondary,
                                ),
                                const SizedBox(height: 15),
                                Text(
                                  "Track your expenses",
                                  style: GoogleFonts.poppins(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w600,
                                    color: AppPallete.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Start adding your first expense 💰",
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: AppPallete.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Transactions",
                            style: GoogleFonts.poppins(
                              fontSize: 22,
                              fontWeight: FontWeight.w400,
                              color: AppPallete.textPrimary,
                            ),
                          ),

                          const SizedBox(height: 8),

                          ListView.builder(
                            itemCount: recent.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return ListCard(currentExp: recent[index]);
                            },
                          ),

                          const SizedBox(height: 20),

                          Text(
                            "Category Spending",
                            style: GoogleFonts.poppins(
                              fontSize: 22,
                              fontWeight: FontWeight.w400,
                              color: AppPallete.textPrimary,
                            ),
                          ),

                          const SizedBox(height: 20),

                          CategoryPieChart(),
                        ],
                      );
                    },
                  ),
            
            
            
            
            
            
            
                ]
            ) ,
            
            
            
            
            
            
            ),
          )
      ),
    );
  }

}
