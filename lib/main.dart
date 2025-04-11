import 'package:flutter/material.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Firebase ML Text Recognition App",
      debugShowCheckedModeBanner: false,
      home: Scaffold(),
    );
  }
}