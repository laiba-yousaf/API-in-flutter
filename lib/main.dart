import 'package:api_project/screen/To_dolist.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      
      home: To_dolist(),
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      );
  }
}
