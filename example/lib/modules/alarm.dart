import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

class AlarmPage extends StatefulWidget {
  MoYoungBle blePlugin;

  AlarmPage({Key? key, required this.blePlugin}) : super(key: key);

  @override
  State<AlarmPage> createState() {
    return _alarmPage(blePlugin);
  }
}

class _alarmPage extends State<AlarmPage> {
  final MoYoungBle _blePlugin;

  _alarmPage(this._blePlugin);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("AlarmPage"),
            ),
            body: Center(child: ListView(children: [
              ElevatedButton(
                  child: const Text('sendAlarmClock()'),
                  onPressed: () => _blePlugin.sendAlarm(AlarmClockBean(
                      enable: true,
                      hour: 0,
                      id: AlarmClockBean.firstClock,
                      minute: 0,
                      repeatMode: AlarmClockBean.everyday))),
              ElevatedButton(
                  child: const Text('queryAllAlarmClock()'),
                  onPressed: () => _blePlugin.queryAllAlarm),
            ])
            )
        )
    );
  }
}
