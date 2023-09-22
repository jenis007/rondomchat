import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rondomchat/Controller/connection_controller.dart';

class NearByUsersList extends StatelessWidget {
  const NearByUsersList({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ConnectionController>(
      builder: (controller) {
        if (controller.nearByUsers.isNotEmpty) {
          return Column(
            children: _buildTextWidgets(controller.nearByUsers, controller),
          );
        } else {
          return const Center(
            child: Text(
              'Currently no users are\n active near by you.',
              textAlign: TextAlign.center,
            ),
          );
        }
      },
    );
  }

  List<Widget> _buildTextWidgets(
      Map<String, dynamic> data, ConnectionController controller) {
    List<Widget> textWidgets = []; // Add an empty Container as a default widget
    for (var element in data.keys) {
      textWidgets.add(
        Container(
          height: 75,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${data[element]['name']}'),
                  Text('${data[element]['age']}'),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  controller.sendConnectionRequest(
                      element, data[element]['username']);
                },
                child: const Text('Send'),
              ),
            ],
          ),
        ), // ending bracket of container
      ); // ending bracket of add function
    } // ending bracket of for loop
    return textWidgets;
  }
}
