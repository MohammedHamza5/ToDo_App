import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'my_app.dart';

void main () async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await ScreenUtil.ensureScreenSize();

  /// To Generate Keys File for localization
  /// flutter pub run easy_localization:generate -S assets/translations -O lib/view_model/utils -o local_keys.g.dart -f keys

  runApp(
      EasyLocalization(
          supportedLocales: const [Locale('ar'), Locale('en')],
          path: 'assets/translations',
          fallbackLocale: const Locale('en'),
     child : const ToDo()
      ),
  );
}