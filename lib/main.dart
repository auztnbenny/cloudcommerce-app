import 'package:cloudcommerce/pages/login/loginpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'styles/app_styles.dart';
import 'styles/bottom_nav_styles.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dashboard Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          primary: AppStyles.primaryColor,
          secondary: AppStyles.secondaryColor,
          surface: AppStyles.cardColor,
          background: AppStyles.backgroundColor,
        ),
        scaffoldBackgroundColor: AppStyles.backgroundColor,
        floatingActionButtonTheme: BottomNavStyles.fabTheme,
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}
