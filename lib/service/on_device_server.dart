import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:netshare/data/pref_data.dart';
import 'package:netshare/di/di.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart' as shelf_router;
import 'package:shelf_static/shelf_static.dart' as shelf_static;

class onDeviceServer {

  final ValueNotifier<bool> _isHostingNotifier = ValueNotifier(false);
  final ValueNotifier<HttpServer?> _serverNotifier = ValueNotifier(null);

  init() async {
    final address = '10.0.50.34:8080';
   
    final routerHandler = shelf_router.Router()
    ..get('/is_online', (request) => _isOnline(request, address))
    ..post('/make_call', (request) => _callHandler(request, address))
    ..post('/end_call', (request) => _callEndHandler(request, address));
  
    Cascade cascade = Cascade()
        .add(routerHandler);
    var handler = const Pipeline()
        .addHandler(cascade.handler);

    _isHostingNotifier.value = !_isHostingNotifier.value;

    try {
      _serverNotifier.value =
          await shelf_io.serve(handler, '10.0.50.34', 8080).catchError((error) {
        throw error;
      });

     
    } catch (e) {
      debugPrint(e.toString());
      _stopHosting(isForce: false);
    }
  }

  void _stopHosting({required isForce}) {
    _isHostingNotifier.value = !_isHostingNotifier.value;
    _serverNotifier.value?.close(force: isForce);
  }

  Future<Response> _isOnline(Request request, String address) async {
    try {
      return Response(
        HttpStatus.ok,
        headers: {'content-type': 'application/json'},
        body: json.encode({"status":"success"}),
      );
    } catch (e) {
      debugPrint(e.toString());
      return Response(HttpStatus.badRequest);
    }
  }

  Future<Response> _callHandler(Request request, String address) async {
    try {
      final payload = await request.readAsString();
      final decodedPayload = jsonDecode(payload);
      checkFriendsList(address,decodedPayload['callerId']);
      // // Construct response body
      final responseBody = {
        'callerId': decodedPayload['callerId'],
        'sdpOffer': decodedPayload['sdpOffer'],
      };

      return Response(
        HttpStatus.ok,
        headers: {'content-type': 'application/json'},
        body: json.encode(responseBody),
      );
    } catch (e) {
      debugPrint(e.toString());
      return Response(HttpStatus.badRequest);
    }
  }

  Future<Response> _callEndHandler(Request request, String address) async {
    try {
      final payload = await request.readAsString();
      final decodedPayload = jsonDecode(payload);
      // // Construct response body
      final responseBody = {
        'holderId': decodedPayload['holderId'],
      };

      return Response(
        HttpStatus.ok,
        headers: {'content-type': 'application/json'},
        body: json.encode(responseBody),
      );
    } catch (e) {
      debugPrint(e.toString());
      return Response(HttpStatus.badRequest);
    }
  }
}

extension OnDeviceOperations on onDeviceServer {

  // {
  //   "id":"212323",
  //   "address":"192.168.1.1",   
  // }
  checkFriendsList(id,address) async {
    final lastSavedDir = await getIt.get<PrefData>().getUsersFriendList();
    if(lastSavedDir != null && lastSavedDir.contains(id)){
    }else{
      var decodedLastSavedDir = jsonDecode(lastSavedDir!);
      // decodedLastSavedDir = [...decodedLastSavedDir,{"id":id, "address"}]
    }
  }
}