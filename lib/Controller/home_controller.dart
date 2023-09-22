import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController
    with GetSingleTickerProviderStateMixin {
  bool selectedTab = true;
  int osVersion = 0;
  TabController? tabController;
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  @override
  void onInit() {
    tabController = TabController(length: 2, vsync: this);
    // TODO: implement onInit
    super.onInit();
  }

  void changeTab(int value) {
    tabController!.index = value;
    update();
  }
}
