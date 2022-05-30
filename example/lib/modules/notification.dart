import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

class NotificationPage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const NotificationPage({Key? key, required this.blePlugin}) : super(key: key);

  @override
  State<NotificationPage> createState() {
    return _NotificationPage(blePlugin);
  }
}

class _NotificationPage extends State<NotificationPage> {
  final MoYoungBle _blePlugin;
  bool _messageState = false;

  _NotificationPage(this._blePlugin);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("Notification Page"),
            ),
            body: Center(child: ListView(children: [
              Text("messageState: $_messageState"),

              ElevatedButton(
                  child: const Text('sendOtherMessageState(false)'),
                  onPressed: () => _blePlugin.sendOtherMessageState(false)),
              ElevatedButton(
                  child: const Text('sendOtherMessageState(true)'),
                  onPressed: () => _blePlugin.sendOtherMessageState(true)),
              ElevatedButton(
                  child: const Text('queryOtherMessageState()'),
                  onPressed: () => setState(() async {
                    _messageState = await _blePlugin.queryOtherMessageState;
                  })),
              ElevatedButton(
                  child: const Text(
                      'sendMessage(MessageInfo()'),
                  onPressed: () => _blePlugin.sendMessage(
                      MessageBean(
                          message: 'message',
                          type: BleMessageType.messagePhone,
                          versionCode: 229,
                          isHs: false,
                          isSmallScreen: false
                      ))),
              ElevatedButton(
                  child: const Text('endCall()'),
                  onPressed: () => _blePlugin.endCall),
            ])
            )
        )
    );
  }
}
