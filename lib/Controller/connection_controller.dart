import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rondomchat/Constant/defs.dart';
import 'package:rondomchat/PreferenceManager/preference_manager.dart';

class ConnectionController extends GetxController {
  Map<String, dynamic> nearByUsers = {};
  bool loading = false;
  String username = '';
  int osVersion = 0;

  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  Map<String, dynamic> connectedUsers = {};

  @override
  onInit() {
    askForPermissions();
    super.onInit();
  }

  Future askForPermissions() async {
    ///getting current android version

    AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
    osVersion = int.parse(androidDeviceInfo.version.release);

    bool granted = false;

    /// requesting permissions
    if (osVersion <= 12) {
      await Permission.location.request();
    }
    if (osVersion >= 12) {
      await Permission.bluetooth.request();
      await Permission.bluetoothAdvertise.request();
      await Permission.bluetoothConnect.request();
      await Permission.bluetoothScan.request();
    }
    if (osVersion > 12) {
      await Permission.nearbyWifiDevices.request();
      await Permission.location.request();
    }
    await Location.instance.requestService();

    ///checking

    if (await Permission.location.isGranted) {
      granted = true;
    }
    if (await Permission.bluetooth.isGranted &&
        await Permission.bluetoothAdvertise.isGranted &&
        await Permission.bluetoothConnect.isGranted &&
        await Permission.bluetoothScan.isGranted) {
      granted = true;
    }
    if (await Permission.nearbyWifiDevices.isGranted) {
      granted = true;
    }

    if (granted) {}
  }

  Future startAdvertising() async {
    username = await PreferenceManager.getUserName();
    try {
      await Nearby().startAdvertising(
        username,
        connectionStrategy,
        serviceId: serviceId,
        onConnectionInitiated: onConnectionInit,
        onConnectionResult: (id, status) {
          if (Status.REJECTED == status) {
            connectedUsers.remove(id);
            Nearby().disconnectFromEndpoint(id);
          } else if (Status.CONNECTED == status) {
            nearByUsers.remove(id);
          }
          log("onConnectionResult==> $id $status");
        },
        onDisconnected: (id) {
          nearByUsers.remove(id);
          connectedUsers.remove(id);
          update();
        },
      );
    } catch (exception) {
      log("startAdvertising==> $exception");
    }
  }

  Future startDiscovering() async {
    username = await PreferenceManager.getUserName();
    try {
      await Nearby().startDiscovery(
        username,
        connectionStrategy,
        serviceId: serviceId,
        onEndpointFound: (id, name, serviceId) {
          var data = jsonDecode(name);

          Uint8List bytes = data['profile'];

          nearByUsers[id] = {
            "name": data['username'],
            "age": data['age'],
            "profile": File.fromRawPath(bytes),
            "username": name,
            "serviceId": serviceId,
            "message": []
          };
          update();
          // show sheet automatically to request connection
        },
        onEndpointLost: (id) {
          log(" Lost discovered Endpoint==> $id");
        },
      );
    } catch (e) {
      log("startDiscovering==> $e");
    }
  }

  void onConnectionInit(String id, ConnectionInfo info) {
    log('IS INCOMING ${info.isIncomingConnection}');
    if (info.isIncomingConnection) {
      Get.dialog(Dialog(
        child: Center(
          child: Column(
            children: <Widget>[
              Text("id: $id"),
              Text("Token: ${info.authenticationToken}"),
              Text("Name${info.endpointName}"),
              Text("Incoming: ${info.isIncomingConnection}"),
              ElevatedButton(
                child: const Text("Accept Connection"),
                onPressed: () {
                  Get.back();
                  acceptConnectionRequest(id, info);
                },
              ),
              ElevatedButton(
                child: const Text("Reject Connection"),
                onPressed: () async {
                  Get.back();
                  await Nearby().rejectConnection(id);
                },
              ),
            ],
          ),
        ),
      ));
    } else {
      acceptConnectionRequest(id, info);
    }
  }

  void sendConnectionRequest(String id, String userName) {
    Nearby().requestConnection(
      userName,
      id,
      onConnectionInitiated: onConnectionInit,
      onConnectionResult: (id, status) {
        log("onConnectionResult ==> $status");
        if (Status.REJECTED == status) {
          Nearby().disconnectFromEndpoint(id);
          connectedUsers.remove(id);
        }
      },
      onDisconnected: (id) {
        nearByUsers.remove(id);
        connectedUsers.remove(id);
        update();
      },
    );
  }

  void acceptConnectionRequest(String id, ConnectionInfo info) {
    var element = nearByUsers[id];

    element.addAll({"connection_info": info});
    connectedUsers[id] = element;
    nearByUsers.remove(id);
    update();

    Nearby().acceptConnection(
      id,
      onPayLoadRecieved: (endid, payload) async {
        if (payload.type == PayloadType.BYTES) {
          String str = String.fromCharCodes(payload.bytes!);
          var data = jsonDecode(str);

          connectedUsers[id]['message'].add(data);
          update();

          // print('DATA RECEIVED>>>>>>> $data');
        }
      },
      onPayloadTransferUpdate: (endid, payloadTransferUpdate) {
        if (payloadTransferUpdate.status == PayloadStatus.IN_PROGRESS) {
          // print(payloadTransferUpdate.bytesTransferred);
        } else if (payloadTransferUpdate.status == PayloadStatus.FAILURE) {
          // print("failed");
        } else if (payloadTransferUpdate.status == PayloadStatus.SUCCESS) {
          // print("sent");
        }
      },
    );
  }

  void addMessage(String id, String msg) {
    var a = jsonEncode({
      "msg": msg,
      "me": false,
    });
    var b = {
      "msg": msg,
      "me": true,
    };
    Nearby().sendBytesPayload(
      id,
      Uint8List.fromList(a.codeUnits),
    );
    connectedUsers[id]['message'].add(b);
    update();
  }

  // void showDialog() {
  //   Get.dialog(Center(
  //     child: Container(
  //       height: 200,
  //       width: 200,
  //       color: Colors.red,
  //     ),
  //   ));
  // }
}
