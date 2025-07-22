// Put your app themes like this

import 'package:flutter/material.dart';
import 'package:offline_service_booking/src/presentation/core/theme/colors.dart';

class AppThemes {
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.primaryColor,
    colorScheme: const ColorScheme.light(secondary: AppColors.secondaryColor),
  );
  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.primaryColor,
    colorScheme: const ColorScheme.dark(secondary: AppColors.secondaryColor),
  );
}
