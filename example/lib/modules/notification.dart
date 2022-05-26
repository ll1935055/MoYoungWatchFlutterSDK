import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

class NotificationPage extends StatefulWidget {
  MoYoungBle blePlugin;

  NotificationPage({Key? key, required this.blePlugin}) : super(key: key);

  @override
  State<NotificationPage> createState() {
    return _notificationPage(blePlugin);
  }
}

class _notificationPage extends State<NotificationPage> {
  final MoYoungBle _blePlugin;

  _notificationPage(this._blePlugin);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("NotificationPage"),
            ),
            body: Center(child: ListView(children: [
              ElevatedButton(
                  child: const Text('sendOtherMessageState(false)'),
                  onPressed: () => _blePlugin.sendOtherMessageState(false)),
              ElevatedButton(
                  child: const Text('sendOtherMessageState(true)'),
                  onPressed: () => _blePlugin.sendOtherMessageState(true)),
              ElevatedButton(
                  child: const Text('queryOtherMessageState()'),
                  onPressed: () => _blePlugin.queryOtherMessageState),
              ElevatedButton(
                  child: const Text(
                      'sendMessage(CrpMessageInfo()'),
                  onPressed: () => _blePlugin.sendMessage(
                      MessageBean(
                          message: 'message',
                          type: BleMessageType.MESSAGE_PHONE,
                          versionCode: 229,
                          isHs: false,
                          isSmallScreen: false
                      ))),
              //存在问题
              ElevatedButton(
                  child: const Text('sendCall0ffHook()'),
                  onPressed: () => _blePlugin.endCall),
            ])
            )
        )
    );
  }
}
