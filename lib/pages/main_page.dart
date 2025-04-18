import 'package:firebase_ml_text_recognition_app/pages/text_capture_history_page.dart';
import 'package:firebase_ml_text_recognition_app/pages/text_capture_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final double iconSize = 35;
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
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.black,
        selectedLabelStyle: TextStyle(
          fontSize: 15,
          color: Colors.green,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 15,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/lettertext.svg",
              width: iconSize,
              height: iconSize,
              colorFilter: ColorFilter.mode(
                _selectedIndex == 0 ? Colors.green : Colors.black,
                BlendMode.srcIn,
              ),
            ),
            label: "Capture Text",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/history.svg",
              width: iconSize,
              height: iconSize,
              colorFilter: ColorFilter.mode(
                _selectedIndex != 0 ? Colors.green : Colors.black,
                BlendMode.srcIn,
              ),
            ),
            label: "Captured History",
          ),
        ],
      ),
      body: Center(
        child:
            _selectedIndex == 0 ? TextCapturePage() : TextCaptureHistoryPage(),
      ),
    );
  }
}
