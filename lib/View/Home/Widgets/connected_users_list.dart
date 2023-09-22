import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:rondomchat/Controller/connection_controller.dart';
import 'package:rondomchat/View/Chat/chat_screen.dart';

class ConnectedUsersList extends StatelessWidget {
  const ConnectedUsersList({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ConnectionController>(
      builder: (controller) {
        if (controller.connectedUsers.isNotEmpty) {
          return Column(
            children: _buildTextWidgets(controller.connectedUsers, controller),
          );
        } else {
          return const Center(
            child: Text(
              'Currently no users are\n connected to you.',
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
            children: [
              Text('${data[element]['name']}'),
              ElevatedButton(
                onPressed: () {
                  Nearby().disconnectFromEndpoint(element);
                },
                child: const Text('remove'),
              ),
              // ElevatedButton(
              //   onPressed: () {
              //     var a = jsonEncode({
              //       "msg": "bhensod",
              //       "me": false,
              //       "time": DateTime.now(),
              //     });
              //     Nearby().sendBytesPayload(
              //       element,
              //       Uint8List.fromList(a.codeUnits),
              //     );
              //   },
              //   child: const Text('send'),
              // ),
              ElevatedButton(
                onPressed: () {
                  Get.to(() => ChatScreen(
                        id: element,
                      ));
                },
                child: const Text('Chat'),
              )
            ],
          ),
        ), // ending bracket of container
      ); // ending bracket of add function
    } // ending bracket of for loop
    return textWidgets;
  }
}
