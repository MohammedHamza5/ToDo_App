import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:to_do_app/view/screens/splash_screen/splash_screen.dart';
import 'package:to_do_app/view_model/cubits/theme/theme_cubit.dart';
import 'package:to_do_app/view_model/themes/dark_theme.dart';
import 'package:to_do_app/view_model/themes/light_theme.dart';

class ToDo extends StatelessWidget {
  const ToDo({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return BlocProvider(
          create: (context) => ThemeCubit(),
          child: BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, state) {
              return MaterialApp(
                theme: lightTheme,
                darkTheme: darkTheme,
                themeMode: ThemeCubit.get(context).isDark
                    ? ThemeMode.dark
                    : ThemeMode.light,

                localizationsDelegates: context.localizationDelegates,
                supportedLocales: context.supportedLocales,
                locale: context.locale,
                debugShowCheckedModeBanner: false,
                home: child,
              );

            },
          ),
        );
      },
      child: const SplashScreen(),
    );
  }
}