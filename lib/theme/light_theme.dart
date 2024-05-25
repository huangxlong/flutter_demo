import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_demo/base/app_colors.dart';

ThemeData lightTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.mainColor,
      titleTextStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
    ),
    tabBarTheme: const TabBarTheme(
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(
          color: Colors.white,
          width: 2,
        ),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.mainColor,
        splashFactory: NoSplash.splashFactory,
        elevation: 0,
        shadowColor: Colors.transparent,
      ),
    ),
    // bottomSheetTheme: const BottomSheetThemeData(
    //   backgroundColor: Coloors.backgroundLight,
    //   modalBackgroundColor: Coloors.backgroundLight,
    //   shape: RoundedRectangleBorder(
    //     borderRadius: BorderRadius.vertical(
    //       top: Radius.circular(20),
    //     ),
    //   ),
    // ),
    // dialogBackgroundColor: Coloors.backgroundLight,
    // dialogTheme: DialogTheme(
    //   shape: RoundedRectangleBorder(
    //     borderRadius: BorderRadius.circular(10),
    //   ),
    // ),
    // floatingActionButtonTheme: const FloatingActionButtonThemeData(
    //   backgroundColor: Coloors.greenDark,
    //   foregroundColor: Colors.white,
    // ),
    // listTileTheme: const ListTileThemeData(
    //   iconColor: Coloors.greyDark,
    //   tileColor: Coloors.backgroundLight,
    // ),
    // switchTheme: const SwitchThemeData(
    //   thumbColor: MaterialStatePropertyAll(Color(0xFF83939C)),
    //   trackColor: MaterialStatePropertyAll(Color(0xFFDADFE2)),
    // ),
  );
}
