import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

class NotDisturbPage extends StatefulWidget {
  MoYoungBle blePlugin;

  NotDisturbPage({
    Key? key,
    required this.blePlugin,
  }) : super(key: key);

  @override
  State<NotDisturbPage> createState() {
    return _notDisturbPage(blePlugin);
  }
}

class _notDisturbPage extends State<NotDisturbPage> {
  final MoYoungBle _blePlugin;

  _notDisturbPage(this._blePlugin);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("NotDisturbPage"),
            ),
            body: Center(child: ListView(children: <Widget>[
              ElevatedButton(
                  child: const Text('queryDoNotDisturbTime()'),
                  onPressed: () => _blePlugin.queryDoNotDisturbTime),
              ElevatedButton(
                  child: const Text('sendDoNotDisturbTime()'),
                  onPressed: () => _blePlugin.sendDoNotDisturbTime(
                      PeriodTimeBean(
                          startHour: 1,
                          endHour: 1,
                          startMinute: 1,
                          endMinute: 1
                      ))),
            ])
            )
        )
    );
  }
}
