import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:rondomchat/Controller/connection_controller.dart';
import 'package:rondomchat/Controller/home_controller.dart';
import 'package:rondomchat/PreferenceManager/preference_manager.dart';
import 'package:rondomchat/View/Auth/register_screen.dart';
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

  final _key = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      drawer: Container(
        width: 300,
        padding: const EdgeInsets.all(20),
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: () async {
                await Nearby().stopAdvertising();
                await Nearby().stopDiscovery();
              },
              child: const Text('STOP'),
            ),
            ElevatedButton(
              onPressed: () async {
                await Nearby().stopAdvertising();
                await Nearby().stopDiscovery();
                await PreferenceManager.logout();
                Get.offAll(() => const RegisterScreen());
              },
              child: const Text('LOGOUT'),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('Find Friends'),
        leading: IconButton(
            onPressed: () {
              _key.currentState!.openDrawer();
            },
            icon: const Icon(Icons.menu)),
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
