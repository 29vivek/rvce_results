import 'package:flutter/material.dart';
import 'package:rvce_results/screens/input_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rvce Results',
      theme: ThemeData.dark(),
      home: InputScreen(),
    );
  }
}