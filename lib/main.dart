import 'package:ez_attendance/views/navigation.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EZAttendance',
      themeMode: ThemeMode.system,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Navigation(),
    );
  }
}
