import 'package:gracedominion/AppRoutes.dart';
import 'package:gracedominion/UI/home.dart';
import 'package:gracedominion/UI/Settings.dart';
import 'package:gracedominion/UI/Upload.dart';
import 'package:flutter/material.dart';

import 'Profile.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> screens = [
      home(context),
      profile(context),
      settings(context),
      LogOut(context),

    ];
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        backgroundColor: Color(0xff173417),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white24,
        selectedFontSize: 16,
        unselectedFontSize: 12,
        onTap: (index) => setState(() {
          currentIndex = index;
          if(currentIndex == 3){
            Navigator.pushReplacementNamed(context, AppRoutes.login);
          };
        }),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle), label: "Profile"),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: "Settings"),
          BottomNavigationBarItem(icon: Icon(Icons.logout), label: "Log Out"),
        ],
      ),
      body: screens[currentIndex],
    );
  }

  Widget home(BuildContext context) {
    return const Home();
  }

  Widget profile(BuildContext context) {
    return const Profile();
  }

  Widget settings(BuildContext context) {
    return const Settings();
  }

  Widget LogOut(BuildContext context) {
    return Container();
  }
}
