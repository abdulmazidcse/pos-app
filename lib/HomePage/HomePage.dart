import 'package:flutter/material.dart';
import 'package:pos/HomePage/DashboardModel.dart';
import 'package:provider/provider.dart';
import 'package:pos/utils/Helper.dart';
import '../utils/Drawer.dart';
import '../utils/HelplineWidget.dart';
import '../utils/StepCard.dart';
import 'DashboardController.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  late Future<DashboardModel> _dashboardData;

  @override
  void initState() {
    super.initState();
    _dashboardData = DashboardController().fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      drawer: const MyDrawer(),
      body: Container(
        color: Color.fromARGB(255, 243, 241, 241),
        child: FutureBuilder<DashboardModel>(
          future: _dashboardData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return const Center(child: Text('No data available'));
            } else {
              final dashboardData = snapshot.data!;
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Container(
                    //   padding: const EdgeInsets.all(16),
                    //   decoration: BoxDecoration(
                    //     gradient: LinearGradient(
                    //       colors: [Colors.green, Colors.greenAccent],
                    //       begin: Alignment.topLeft,
                    //       end: Alignment.bottomRight,
                    //     ),
                    //     borderRadius: BorderRadius.circular(10),
                    //     boxShadow: [
                    //       BoxShadow(
                    //         color: Colors.black.withOpacity(0.1),
                    //         blurRadius: 10,
                    //         spreadRadius: 5,
                    //       ),
                    //     ],
                    //   ),
                    //   child: Column(
                    //     mainAxisSize: MainAxisSize.min,
                    //     children: [
                    //       Container(
                    //         decoration: const BoxDecoration(
                    //           color: Colors.white,
                    //           shape: BoxShape.circle,
                    //         ),
                    //         padding: const EdgeInsets.all(8),
                    //         child:
                    //             Icon(Icons.abc, color: Colors.amber, size: 30),
                    //       ),
                    //       const SizedBox(height: 10),
                    //       Text(
                    //         'SS sdfdsf',
                    //         textAlign: TextAlign.center,
                    //         style: const TextStyle(
                    //           color: Colors.white,
                    //           fontSize: 16,
                    //           fontWeight: FontWeight.bold,
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // Container(
                    //   child: Card(
                    //     color: Colors.lightBlue,
                    //     child: Padding(
                    //       padding: const EdgeInsets.all(16.0),
                    //       child: Column(
                    //         crossAxisAlignment: CrossAxisAlignment.start,
                    //         children: [
                    //           Text(
                    //             "ddd",
                    //             style: const TextStyle(
                    //               fontSize: 24.0,
                    //               fontWeight: FontWeight.bold,
                    //               color: Colors.white,
                    //             ),
                    //           ),
                    //           const Text(
                    //             "Annual Total Sales",
                    //             style: TextStyle(color: Colors.white),
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    const SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        HelplineBox(
                          bgColorTop: const Color(0xFF9CCC3C),
                          bgColorBttm: const Color(0xFF9CCC3C),
                          bgColor: const Color(0xFF9CCC3C),
                          icon: Icons.currency_exchange,
                          text: "Today Sales",
                          subtext: dashboardData.todaySalesAmount,
                        ),
                        HelplineBox(
                          bgColorTop: const Color(0xFFFE8600),
                          bgColorBttm: const Color(0xFFFE8600),
                          bgColor: const Color(0xFFF9450B),
                          icon: Icons.currency_exchange,
                          text: "Yesterday Sales",
                          subtext: dashboardData.yesterdaySalesAmount,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        HelplineBox(
                          bgColorTop: const Color(0xFF4B408C),
                          bgColorBttm: const Color(0xFF4B408C),
                          bgColor: const Color(0xFF4B408C),
                          icon: Icons.currency_exchange,
                          text: "This Week Sales",
                          subtext: dashboardData.currentWeekSalesAmount,
                        ),
                        HelplineBox(
                          bgColorTop: const Color(0xFFC80999),
                          bgColorBttm: const Color(0xFFC80999),
                          bgColor: const Color(0xFFC8044C),
                          icon: Icons.currency_exchange,
                          text: "P. Week Sales",
                          subtext: dashboardData.previousWeekSalesAmount,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        HelplineBox(
                          bgColorTop: Colors.amber,
                          bgColorBttm: Colors.amber,
                          bgColor: Colors.amber,
                          icon: Icons.currency_exchange,
                          text: "This Month Sales",
                          subtext: dashboardData.currentMonthSalesAmount,
                        ),
                        HelplineBox(
                          bgColorTop: const Color(0xFF5697FF),
                          bgColorBttm: const Color(0xFF5697FF),
                          bgColor: const Color(0xFF0B63ED),
                          icon: Icons.currency_exchange,
                          text: "P. Month Sales",
                          subtext: dashboardData.previousMonthSalesAmount,
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
 


 // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                          // Expanded(
                          //   child: Card(
                          //     color: Colors.lightBlue,
                          //     child: Padding(
                          //       padding: const EdgeInsets.all(16.0),
                          //       child: Column(
                          //         crossAxisAlignment: CrossAxisAlignment.start,
                          //         children: [
                          //           Text(
                          //             "${dashboardController.dashboardData?.annualTotalSales ?? 0}",
                          //             style: const TextStyle(
                          //               fontSize: 24.0,
                          //               fontWeight: FontWeight.bold,
                          //               color: Colors.white,
                          //             ),
                          //           ),
                          //           const Text(
                          //             "Annual Total Sales",
                          //             style: TextStyle(color: Colors.white),
                          //           ),
                          //         ],
                          //       ),
                          //     ),
                          //   ),
                          // ),
                      //     Expanded(
                      //       child: Card(
                      //         color: Colors.lightBlue,
                      //         child: Padding(
                      //           padding: const EdgeInsets.all(16.0),
                      //           child: Column(
                      //             crossAxisAlignment: CrossAxisAlignment.start,
                      //             children: [
                      //               Text(
                      //                 "${dashboardController.dashboardData?.annualOrderDiscount ?? 0}",
                      //                 style: const TextStyle(
                      //                   fontSize: 24.0,
                      //                   fontWeight: FontWeight.bold,
                      //                   color: Colors.white,
                      //                 ),
                      //               ),
                      //               const Text(
                      //                 "Annual Order Discount",
                      //                 style: TextStyle(color: Colors.white),
                      //               ),
                      //             ],
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      // const SizedBox(height: 10.0),