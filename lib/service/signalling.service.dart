import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:netshare/provider/user_info.dart';
import 'package:netshare/util/utility_functions.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';

class SignallingService {
  // instance of Socket
  Socket? socket;

  SignallingService._();
  static final instance = SignallingService._();

  init(
      {required String websocketUrl,
      required String selfCallerID,
      required BuildContext context}) async {
    // init Socket
    var ip = await UtilityFunctions.getIPAddress();
    var websocketUrlNew = "http://"+"10.0.50.34"+":3000/";
    socket = io(websocketUrlNew, {
      "transports": ['websocket'],
      "query": {"callerId": selfCallerID}
    });

    // listen onConnect event
    socket!.onConnect((data) {
      log("Socket connected !!");
      Future.delayed(const Duration(milliseconds: 500), () {
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.setUser(selfCallerID);
      });
    });

    // listen onConnectError event
    socket!.onConnectError((data) {
      log("Connect Error $data");
    });

    // connect socket
    socket!.connect();
  }
}
