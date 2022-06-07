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
  List<AlarmClockBean> _list = [];

  _AlarmPage(this._blePlugin);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("Alarm"),
            ),
            body: Center(
                child: ListView(children: [
                  Text("list: $_list"),

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
                  onPressed: () async {
                    List<AlarmClockBean> list = await _blePlugin.queryAllAlarm;
                    setState(() {
                        _list = list;
                      });}),
            ])
            )
        )
    );
  }
}
