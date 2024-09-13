import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  int _bottomNavIndex = 0;

  final List<Widget> _fragmentList = [
    Text("Plants fragment"),
    Text("Diseases fragment"),
    Text("Tools fragment"),
    Text("Settings fragment")
  ];

  void _setFragment(int index) {
    setState(() {
      _bottomNavIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _fragmentList.elementAt(_bottomNavIndex),
      // Bottom navigation bar controls what the home screen sees
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.green,
        selectedItemColor: Colors.lime,
        unselectedItemColor: Colors.white,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.eco), label: "Plants"),
          BottomNavigationBarItem(
              icon: Icon(Icons.coronavirus), label: "Diseases"),
          BottomNavigationBarItem(icon: Icon(Icons.edit), label: "Tools"),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: "Settings"),
        ],
        currentIndex: _bottomNavIndex,
        onTap: _setFragment,
      ),
    );
  }
}
