import 'package:flutter/material.dart';
import 'package:scanner_cnh_app/cnh_scan_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CNH Scanner',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const CnhScannerScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
