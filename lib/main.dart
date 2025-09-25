import 'package:flutter/material.dart';
import 'screens/home_page.dart';

void main() {
  runApp(const MoonyApp());
}

class MoonyApp extends StatelessWidget {
  const MoonyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Moony - Personal Finance',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Colors.grey[100],
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
      home: const HomePage(),
    );
  }
}
