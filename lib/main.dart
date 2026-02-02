import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sregep_productivity_app/providers/timer_provider.dart';
import 'package:sregep_productivity_app/ui/splash/splash_screen.dart';

void main() {
  // Inisialisasi Database untuk Linux Preview
  if (Platform.isLinux || Platform.isWindows) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => TimerProvider())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sregep Productivity',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const SplashScreen(), // Scaffold di sini sekarang aman
    );
  }
}
