import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/apptheme/theme_controller.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/features/splash/views/splash_page.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ThemeController.instance.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.instance.mode,
      builder: (context, mode, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: mode,
          home: const SplashPage(),
          builder: (context, child) {
            Dimensions.init(context);
            return child ?? const SizedBox.shrink();
          },
        );
      },
    );
  }
}
