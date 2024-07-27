import 'dart:io';

import 'package:final_year_prpject/Pages/Home_Screen.dart';
import 'package:final_year_prpject/Pages/splash.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Provider/auth_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const MyApp(),
    ),
    
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => Splash(),
        Home.routeName: (context) => Home(), 
      },
      debugShowCheckedModeBanner: false,
      title: 'PronouncePal',
      // home: Splash(),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
