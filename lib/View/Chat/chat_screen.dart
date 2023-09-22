import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:rondomchat/Controller/connection_controller.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.id});
  final String id;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  ConnectionController connectionController = Get.find();
  TextEditingController message = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(
            height: height * 0.1,
          ),
          const Text(
            'You are chanting with a random person. do not share your personal information such as mobile number or email',
            style: TextStyle(),
            textAlign: TextAlign.center,
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: GetBuilder<ConnectionController>(
                builder: (controller) {
                  if (controller.connectedUsers[widget.id]
                          .containsKey('message') ||
                      controller.connectedUsers[widget.id]['message'] != null) {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: controller
                          .connectedUsers[widget.id]['message'].length,
                      itemBuilder: (context, index) {
                        bool myMsg = controller.connectedUsers[widget.id]
                            ['message'][index]['me'];

                        print(myMsg);
                        return Row(
                          mainAxisAlignment: myMsg
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.all(10),
                              padding: const EdgeInsets.all(10),
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.amber,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Center(
                                child: Text(
                                  '${controller.connectedUsers[widget.id]['message'][index]['msg']}',
                                  maxLines: 3,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    return const Text('no messages Available');
                  }
                },
              ),
            ),
          ),
          Container(
            height: height * 0.08,
            color: Colors.grey.shade300,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.grey,
                      ),
                    ),
                    child: TextField(
                      controller: message,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    connectionController.addMessage(widget.id, message.text);
                    message.clear();
                  },
                  child: const Text('send'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
