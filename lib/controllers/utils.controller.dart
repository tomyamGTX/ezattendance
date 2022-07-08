import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Controller extends GetxController {
  var count = 0.obs;
  var name = 'Jonatas Borges'.obs;
  var isDarkMode = false.obs;

  increment() => count++;

  changeTheme() {
    Get.changeTheme(Get.isDarkMode ? ThemeData.light() : ThemeData.dark());
    isDarkMode.value = !isDarkMode.value;
  }
}
