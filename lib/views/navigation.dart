import 'package:ez_attendance/views/qr.code.dart';
import 'package:ez_attendance/views/schedule.dart';
import 'package:ez_attendance/views/setting.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/utils.controller.dart';

class Navigation extends StatefulWidget {
  const Navigation({Key? key}) : super(key: key);

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  var iconList = [Icons.home, Icons.schedule, Icons.qr_code, Icons.settings];

  int _bottomNavIndex = 0;

  final _pageController = PageController();

  @override
  Widget build(context) {
    // Instantiate your class using Get.put() to make it available for all "child" routes there.
    final Controller c = Get.put(Controller());
    return Scaffold(
      // Use Obx(()=> to update Text() whenever count is changed.
      appBar: AppBar(
        title: const Text('EZAttendance'),
        actions: [
          IconButton(
            onPressed: () => c.changeTheme(),
            icon: Obx(() => c.isDarkMode.value
                ? const Icon(Icons.nightlight_round)
                : const Icon(Icons.sunny)),
          )
        ],
      ),

      // Replace the 8 lines Navigator.push by a simple Get.to(). You don't need context
      body: PageView(controller: _pageController, children: const [
        Schedule(),
        QRCode(),
        Setting(),
      ]),
      bottomNavigationBar: FloatingNavbar(
        backgroundColor: Theme.of(context).primaryColor,
        onTap: (int val) {
          _pageController.jumpToPage(val);
          setState(() {
            _bottomNavIndex = val;
          });
        },
        currentIndex: _bottomNavIndex,
        items: [
          FloatingNavbarItem(icon: Icons.schedule, title: 'Attendances'),
          FloatingNavbarItem(icon: Icons.qr_code, title: 'Scan'),
          FloatingNavbarItem(icon: Icons.settings, title: 'Settings'),
        ],
      ),
    );
  }
}
