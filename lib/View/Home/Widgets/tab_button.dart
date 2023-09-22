import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rondomchat/Controller/home_controller.dart';

class TabButton extends StatelessWidget {
  const TabButton({super.key});
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (controller) {
      return Row(
        children: [
          tabButton(controller, 0, 'Near By Users'),
          const SizedBox(
            width: 20,
          ),
          tabButton(controller, 1, 'Connected'),
        ],
      );
    });
  }

  Expanded tabButton(HomeController controller, int index, String title) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          controller.changeTab(index);
        },
        child: Container(
          height: 55,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: controller.tabController?.index == index
                ? Colors.black
                : Colors.grey.shade400,
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: controller.tabController?.index == index
                    ? Colors.white
                    : Colors.black,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
