import 'package:flutter/material.dart';
import 'package:offline_service_booking/src/presentation/view/splash_screen/splash_screen.dart';

class FcmNavigationService {
  FcmNavigationService({this.page});
  final String? page;
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  Future<dynamic> navigateToPage() {
    switch (page) {
      case "check":
        return Navigator.of(
          navigatorKey.currentContext!,
        ).push(MaterialPageRoute(builder: (context) => SplashScreen()));
      default:
        return Navigator.of(
          navigatorKey.currentContext!,
        ).push(MaterialPageRoute(builder: (context) => const SplashScreen()));
    }
  }
}
