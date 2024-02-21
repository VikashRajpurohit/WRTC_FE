import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:netshare/provider/user_info.dart';
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
      required BuildContext context}) {
    // init Socket
    socket = io(websocketUrl, {
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
