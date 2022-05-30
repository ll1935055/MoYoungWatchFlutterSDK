import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

class AlarmPage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const AlarmPage({Key? key, required this.blePlugin}) : super(key: key);

  @override
  State<AlarmPage> createState() {
    return _AlarmPage(blePlugin);
  }
}

class _AlarmPage extends State<AlarmPage> {
  final MoYoungBle _blePlugin;
  bool _enable = false;
  int _hour = -1;
  int _id = -1;
  int _minute = -1;
  int _repeatMode = -1;
  List<AlarmClockBean> list = [];

  _AlarmPage(this._blePlugin);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("Alarm Page"),
            ),
            body: Center(
                child: ListView(children: [
                  Text("enable: $_enable"),
                  Text("hour: $_hour"),
                  Text("id: $_id"),
                  Text("minute: $_minute"),
                  Text("repeatMode: $_repeatMode"),

              ElevatedButton(
                  child: const Text('sendAlarmClock()'),
                  onPressed: () => _blePlugin.sendAlarm(AlarmClockBean(
                      enable: true,
                      hour: 1,
                      id: AlarmClockBean.firstClock,
                      minute: 0,
                      repeatMode: AlarmClockBean.everyday))),
              ElevatedButton(
                  child: const Text('queryAllAlarmClock()'),
                  onPressed: () async => {
                  list = await _blePlugin.queryAllAlarm,
                    setState(() {
                        _enable = list[0].enable;
                        _hour = list[0].hour;
                        _id = list[0].id;
                        _minute = list[0].minute;
                        _repeatMode = list[0].repeatMode;
                      })}),
            ])
            )
        )
    );
  }
}
