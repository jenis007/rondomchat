import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:rondomchat/Controller/connection_controller.dart';
import 'package:rondomchat/Controller/home_controller.dart';
import 'package:rondomchat/View/Home/Widgets/near_by_users_list.dart';
import 'package:rondomchat/View/Home/Widgets/connected_users_list.dart';
import 'Widgets/tab_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ConnectionController connectionController = Get.find();

  @override
  void initState() {
    connectionController.startAdvertising();
    connectionController.startDiscovering();
    super.initState();
  }

  @override
  void dispose() {
    Nearby().stopAdvertising();
    Nearby().stopDiscovery();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Nearby().stopAdvertising();
          Nearby().stopDiscovery();
        },
      ),
      appBar: AppBar(
        title: const Text('Find Friends'),
      ),
      body: GetBuilder<HomeController>(
        builder: (controller) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const TabButton(),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: TabBarView(
                    controller: controller.tabController!,
                    children: const [
                      NearByUsersList(),
                      ConnectedUsersList(),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
