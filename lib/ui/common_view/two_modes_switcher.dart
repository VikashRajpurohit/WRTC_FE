import 'package:flutter/material.dart';
import 'package:netshare/provider/user_info.dart';
import 'package:netshare/service/signalling.service.dart';
import 'package:netshare/ui/video_streaming/call_screen.dart';
import 'package:provider/provider.dart';

class TwoModeSwitcher extends StatefulWidget {
  final bool switchInitValue;
  final Text? leftValue;
  final Text? rightValue;
  final Function(bool)? onValueChanged;

  const TwoModeSwitcher({
    Key? key,
    this.switchInitValue = false,
    this.leftValue,
    this.rightValue,
    required this.onValueChanged,
  }) : super(key: key);

  @override
  State<TwoModeSwitcher> createState() => TwoModeSwitcherState();
}

class TwoModeSwitcherState extends State<TwoModeSwitcher>
    with SingleTickerProviderStateMixin {
  bool switchValue = false;
  dynamic incomingSDPOffer;
  AnimationController? _controller;
  final remoteCallerIdTextEditingController = TextEditingController();
  @override
  void initState() {
    super.initState();
    switchValue = widget.switchInitValue;
    Future.delayed(const Duration(milliseconds: 500), () {
      _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

      SignallingService.instance.socket!.on("newCall", (data) {
        if (mounted) {
          setState(() => incomingSDPOffer = data);
        }
      });
    });
  }

    @override
  void dispose() {
    remoteCallerIdTextEditingController.dispose();
    super.dispose();
  }

  _joinCall({
    required String callerId,
    required String calleeId,
    dynamic offer,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CallScreen(
          callerId: callerId,
          calleeId: calleeId,
          offer: offer,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: true);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (incomingSDPOffer == null)
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            widget.leftValue ?? const SizedBox.shrink(),
            Switch(
              activeThumbImage: Image.asset('assets/images/server.png').image,
              inactiveThumbImage: Image.asset('assets/images/client.png').image,
              activeColor: Theme.of(context).colorScheme.primaryContainer,
              inactiveThumbColor:
                  Theme.of(context).colorScheme.primaryContainer,
              trackColor: MaterialStatePropertyAll<Color>(
                  Theme.of(context).colorScheme.primaryContainer),
              trackOutlineColor: MaterialStatePropertyAll<Color>(
                  Theme.of(context).colorScheme.primaryContainer),
              value: switchValue,
              onChanged: (bool value) {
                setState(() {
                  switchValue = value;
                });
                widget.onValueChanged?.call(value);
              },
            ),
            widget.rightValue ?? const SizedBox.shrink(),
            Text(
              "User : " + userProvider.user,
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
        if (incomingSDPOffer == null)
      
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: const EdgeInsets.all(1.0),
                  child:SizedBox(
                    width: 200,
                    height: 40,
                    child: TextField(
                          controller: remoteCallerIdTextEditingController,
                          textAlign: TextAlign.start,
                          decoration: InputDecoration(
                            labelText: "Caller ID",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6.0),
                              borderSide: BorderSide(width: 4)
                            ),
                          ),
                        ),
                  ),
                ),
                SizedBox(width: 10,),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.call),
                      color: remoteCallerIdTextEditingController.text.length == 6 ?  Colors.greenAccent :  Colors.grey,
                      onPressed: () {
                          _joinCall(
                            callerId: userProvider.user,
                            calleeId: remoteCallerIdTextEditingController.text,
                          );   },
                    )
                  ],
                ),
              ],
            ),
        if (incomingSDPOffer != null)
        FadeTransition(
          opacity: _controller!,
          child: Container(
            color: const Color.fromARGB(255, 23, 10, 9),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "${incomingSDPOffer["callerId"]}",
                    // "Incoming Call from Vikash",
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.call_end),
                      color: Colors.redAccent,
                      onPressed: () {
                        _controller!.dispose();
                        setState(() => incomingSDPOffer = null);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.call),
                      color: Colors.greenAccent,
                      onPressed: () {
                         _joinCall(
                            callerId: userProvider.user,
                            calleeId: remoteCallerIdTextEditingController.text,
                          );
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void updateExternalValue(bool newValue) {
    setState(() {
      switchValue = newValue;
    });
  }
}
