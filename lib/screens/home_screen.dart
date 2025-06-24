import 'package:flutter/material.dart';
import 'package:garden_buddy/const.dart';
import 'package:garden_buddy/gbio.dart';
import 'package:garden_buddy/screens/bottom_nav/plants/plants_frag.dart';
import 'package:garden_buddy/screens/bottom_nav/settings_frag.dart';
import 'package:garden_buddy/screens/bottom_nav/tools_frag.dart';
import 'package:garden_buddy/theming/colors.dart';
import 'package:garden_buddy/widgets/dialogs/custom_info_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  int _bottomNavIndex = 0;

  final List<Widget> _fragmentList = const [
    PlantsFragment(),
    //DiseasesFragment(),
    ToolsFragment(),
    SettingsFragment()
  ];

  void _setFragment(int index) {
    setState(() {
      _bottomNavIndex = index;
    });
  }

  void showApiNotice() {
    showDialog(
        context: context,
        builder: (ctx) => CustomInfoDialog(
            title: "API Notice",
            description:"The API for the plants database is still in the works. Upon release, there are only about twenty plants in this database that can be seen by users. As the application grows, we will be adding more plant information to grow this database.",
            imageAsset: "assets/icons/icon.jpg",
            buttonText: "Dismiss",
            onClose: () {
              GBIO.setApiNotice();
              apiNoticeComplete = true;
              Navigator.of(context).pop();
            }));
  }

  @override
  Widget build(BuildContext context) {
    checkScreenType(context);

    // Show the notice dialog, then don't show it again
    if (!apiNoticeComplete) {
      Future.delayed(Duration.zero, () {
        showApiNotice();
      });
    }

    return Scaffold(
      body: _fragmentList.elementAt(_bottomNavIndex),
      // Bottom navigation bar controls what the home screen sees
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(context).colorScheme.primary,
        selectedItemColor: ThemeColors.greenLight,
        unselectedItemColor: Colors.white,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.eco), label: "Plants"),
          //BottomNavigationBarItem(icon: Icon(Icons.coronavirus), label: "Diseases"),
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
