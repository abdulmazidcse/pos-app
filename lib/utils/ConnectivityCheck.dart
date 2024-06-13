// ConnectivityCheck.dart
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityCheck extends StatefulWidget {
  // final Widget child;

  const ConnectivityCheck({super.key});

  @override
  ConnectivityCheckState createState() => ConnectivityCheckState();
}

class ConnectivityCheckState extends State<ConnectivityCheck> {
  late bool _isConnected = true;

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
  }

  Future<void> _checkConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _isConnected = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isConnected) {
      return _buildNoConnection();
    } else {
      return widget;
    }
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
