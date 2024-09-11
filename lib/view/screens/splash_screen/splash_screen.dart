import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tbib_splash_screen/splash_screen_view.dart';
import 'package:to_do_app/view_model/utils/app_assets.dart';
import 'package:to_do_app/view_model/utils/app_colors.dart';
import 'package:to_do_app/view_model/utils/app_navigate.dart';
import '../home_screen/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isLoaded = false;
  Widget? navigateTo;

  @override
  void initState() {
    super.initState();
    _initializeSplash();
  }

  Future<void> _initializeSplash() async {
    await Future.delayed(const Duration(seconds: 4));

    if (!mounted) return;
    setState(() {
      navigateTo = const HomeScreen();
    });
    if (navigateTo != null) {
      AppNavigation.pushAndRemove(context, navigateTo!);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SplashScreenView(
        navigateWhere: isLoaded,
        navigateRoute: navigateTo ?? Container(),
        linearGradient: const LinearGradient(
          colors: [
            AppColors.blue12,
            AppColors.blue15,
          ],
          begin: FractionalOffset(0.0, 0.0),
          end: FractionalOffset(1.0, 0.0),
          stops: [0.0, 1.0],
          tileMode: TileMode.clamp,
        ),
        text: WavyAnimatedText(
          " To Do App ",
          textStyle: TextStyle(
            color: AppColors.green,
            fontSize: 40.0.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        imageSrc: AppAssets.logo,
        logoSize: 200.sp,
      ),
    );
  }
}
