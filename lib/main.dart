import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rondomchat/PreferenceManager/preference_manager.dart';
import 'Controller/connection_controller.dart';
import 'Controller/home_controller.dart';
import 'View/Home/home_screen.dart';
import 'View/Auth/register_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        title: 'Flutter Demo',
        initialBinding: ControllerBindings(),
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: PreferenceManager.getUserName() == null
            ? const RegisterScreen()
            : const HomeScreen()
        // const AllCustomers(),
        );
  }
}

class ControllerBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(HomeController());
    Get.put(ConnectionController());
    // TODO: implement dependencies
  }
}
