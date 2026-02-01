import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:library_app/db/library_database.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:library_app/providers/visit_provider.dart';
import 'package:library_app/providers/package_provider.dart';
import 'package:library_app/providers/news_provider.dart';
import 'package:library_app/providers/auth_provider.dart';

import 'screens/home.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  HttpOverrides.global = MyHttpOverrides(); // 👈 ADD THIS


  if (Platform.isWindows) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  LibraryDatabase database = LibraryDatabase();
  await database.getDatabase();

  runApp(ChangeNotifierProvider(
      create: (_) => VisitProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => VisitProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => PackageProvider()),
        ChangeNotifierProvider(create: (_) => NewsProvider()),

      ],
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: MaterialApp(
          title: 'Library App',
          debugShowCheckedModeBanner: false,

          theme: ThemeData(
            primaryColor: const Color(0xFF76499C),
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF76499C),
              secondary: const Color(0xFF4ABC9D),
            ),
            scaffoldBackgroundColor: const Color(0xFFF9F7FB),
            useMaterial3: true,
          ),

          home: const MainPage(),
        ),
      ),
    );
  }
}
