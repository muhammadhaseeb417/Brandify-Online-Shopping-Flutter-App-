import 'package:brand_shoes/firebase_options.dart';
import 'package:brand_shoes/pages/home.dart';
import 'package:brand_shoes/pages/signup.dart';
import 'package:brand_shoes/utils.dart';
import 'package:brand_shoes/widgets/navigation_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'servics/auth_service.dart';
import 'package:device_preview/device_preview.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await RegisterServics();
  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => MyApp(), // Wrap your app
    ),
  );
}

class MyApp extends StatelessWidget {
  final GetIt _getIt = GetIt.instance;

  late AuthService _authService;

  MyApp({super.key}) {
    _authService = _getIt.get<AuthService>();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color.fromRGBO(197, 0, 0, 0.8),
          primary: Color.fromRGBO(197, 0, 0, 0.8),
        ),
        scaffoldBackgroundColor: const Color.fromRGBO(249, 249, 249, 1.0),
        appBarTheme: const AppBarTheme(color: Colors.transparent),
        useMaterial3: true,
        textTheme: GoogleFonts.lexendTextTheme(),
      ),
      home: _authService.user != null ? NavigationWidget() : NavigationWidget(),
    );
  }
}
