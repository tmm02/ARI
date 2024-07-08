import 'package:flutter/material.dart';
import 'package:my_app/pages/home.dart';
import 'package:my_app/splash.dart';
import 'package:my_app/theme.dart';
import 'package:provider/provider.dart';
import 'package:my_app/provider.dart';


void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LogDataProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: lightTheme, // Menggunakan tema terang
      darkTheme: darkTheme, // Menggunakan tema gelap
      themeMode: ThemeMode.light,
      home: const SplashPage(),
      routes: {
        '/home': (context) => HomePage(),
        // '/profilemenu': (context) => ProfileMenuPage(),
        // '/thread': (context) => ThreadPage()
      },
    );
  }
}
