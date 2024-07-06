import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/app_colors.dart';

ThemeData lightTheme = ThemeData(
  primaryColor: AppColors.black,
  appBarTheme: const AppBarTheme(backgroundColor: AppColors.purpleA),
  inputDecorationTheme: InputDecorationTheme(
    border: const OutlineInputBorder(),
    filled: true,
    fillColor: Colors.grey[200],
    labelStyle:  const TextStyle(color: AppColors.grey),
    hintStyle: const TextStyle(color: AppColors.grey),

  ),
  buttonTheme: ButtonThemeData(
    buttonColor: AppColors.purpleA,
    textTheme: ButtonTextTheme.primary,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.r)
    )
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.purpleA,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r)
      )
    )
  ),
  textTheme: TextTheme(
    bodySmall: TextStyle(
      color: AppColors.black,
      fontSize: 12.sp,
    ),
    bodyMedium: TextStyle(
      color: AppColors.grey,
      fontSize: 16.sp,
    ),
    bodyLarge: TextStyle(
      color: AppColors.black,
      fontWeight: FontWeight.bold,
      fontSize: 18.sp,
    ),
  ),
);
