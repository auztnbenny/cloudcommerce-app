import 'package:cloudcommerce/pages/login/loginpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'styles/app_styles.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppStyles.primaryColor,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cloud Commerce',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          primary: AppStyles.primaryColor,
          secondary: AppStyles.secondaryColor,
          surface: AppStyles.cardColor,
          background: AppStyles.backgroundColor,
          error: AppStyles.errorColor,
        ),
        textTheme: GoogleFonts.montserratTextTheme(
          Theme.of(context).textTheme.copyWith(
                displayLarge: AppStyles.displayLarge,
                headlineMedium: AppStyles.h1,
                titleLarge: AppStyles.h2,
                bodyLarge: AppStyles.body1,
                bodyMedium: AppStyles.body2,
                labelLarge: AppStyles.button,
              ),
        ),
        scaffoldBackgroundColor: AppStyles.backgroundColor,
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}
