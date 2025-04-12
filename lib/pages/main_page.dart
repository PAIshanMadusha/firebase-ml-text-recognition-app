import 'package:firebase_ml_text_recognition_app/pages/text_capture_history_page.dart';
import 'package:firebase_ml_text_recognition_app/pages/text_capture_page.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  void _onTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onTap,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.abc), label: "Text"),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "History"),
        ],
      ),
      body: Center(
        child:
            _selectedIndex == 0 ? TextCapturePage() : TextCaptureHistoryPage(),
      ),
    );
  }
}
