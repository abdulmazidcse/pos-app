import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'DashboardModel.dart';
import '../utils/Drawer.dart';
import '../utils/HelplineWidget.dart';
import 'DashboardController.dart';
import '../utils/SalesBarChart.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  late Future<DashboardModel> _dashboardData;

  late bool _isConnected = true;

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
    _dashboardData = DashboardController().fetchData();
  }

  Future<void> _checkConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult[0] == ConnectivityResult.none) {
      setState(() {
        _isConnected = false;
      });
    } else {
      setState(() {
        _isConnected = true;
      });
    }
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
        color: const Color.fromARGB(255, 243, 241, 241),
        child: _isConnected ? _buildDashboard() : _buildNoConnection(),
      ),
    );
  }

  Widget _buildDashboard() {
    return FutureBuilder<DashboardModel>(
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
          List<SevenDaysSalesData> data = dashboardData.last7DaysSales;
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 7.0),
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
                const SizedBox(height: 7.0),
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
                const SizedBox(height: 7.0),
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
                const SizedBox(height: 15.0),
                SalesBarChart(data: data),
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildNoConnection() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.signal_wifi_off,
            size: 48,
            color: Colors.red,
          ),
          Text(
            'No Internet Connection',
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
