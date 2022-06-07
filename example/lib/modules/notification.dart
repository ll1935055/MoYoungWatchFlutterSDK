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
  List _list = [];

  _NotificationPage(this._blePlugin);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("Notification"),
            ),
            body: Center(child: ListView(children: [
              Text("list: $_list"),

              ElevatedButton(
                  child: const Text(
                      'sendMessage(MessageInfo()'),
                  onPressed: () => _blePlugin.sendMessage(
                      MessageBean(
                          message: 'message',
                          type: BleMessageType.messagePhone,
                          versionCode: 229,
                          isHs: true,
                          isSmallScreen: true
                      ))),
              ElevatedButton(
                  child: const Text('android:endCall()'),
                  onPressed: () => _blePlugin.endCall),
              ElevatedButton(
                  child: const Text('ios:setNotification()'),
                  onPressed: () => _blePlugin.setNotification([
                        NotificationType.facebook,
                        NotificationType.gmail,
                        NotificationType.kakaoTalk
                      ])),
              ElevatedButton(
                  child: const Text('ios:getNotification'),
                  onPressed: () async {
                    List list = await _blePlugin.getNotification;
                    setState(() {
                      _list = list;
                    });
                  }),
            ]))
        )
    );
  }
}
