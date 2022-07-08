import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Controller extends GetxController {
  var count = 0.obs;
  var name = 'Jonatas Borges'.obs;
  var isDarkMode = true.obs;

  increment() => count++;

  changeTheme() {
    Get.changeTheme(Get.isDarkMode ? ThemeData.light() : ThemeData.dark());
    if (Get.isDarkMode) {
      isDarkMode.value = true;
    } else {
      isDarkMode.value = false;
    }
  }
}
