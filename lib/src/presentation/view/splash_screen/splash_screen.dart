import 'dart:async';

import 'package:flutter/material.dart';
import 'package:offline_service_booking/main.dart';
import 'package:offline_service_booking/src/infrastructure/core/database_service.dart';
import 'package:offline_service_booking/src/presentation/view/home/provider_list_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    requestNotificationPermission();
    DatabaseServices().initDB();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ProviderListScreen()),
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text("Hi")));
  }
}
