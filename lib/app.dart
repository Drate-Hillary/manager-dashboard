import 'package:flutter/material.dart';

class DineSwiftApp extends StatelessWidget {
  const DineSwiftApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DineSwift App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Scaffold(
        body: Center(
          child: Text('Welcome to DineSwift!'),
        ),
      ),
    );
  }
}