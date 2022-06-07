import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

class NotDisturbPage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const NotDisturbPage({
    Key? key,
    required this.blePlugin,
  }) : super(key: key);

  @override
  State<NotDisturbPage> createState() {
    return _NotDisturbPage(blePlugin);
  }
}

class _NotDisturbPage extends State<NotDisturbPage> {
  final MoYoungBle _blePlugin;
  PeriodTimeResultBean? _periodTimeResultBean;
  int _periodTimeType = -1;
  PeriodTimeBean? _periodTimeInfo;
  int _endHour = -1;
  int _endMinute = -1;
  int _startHour = -1;
  int _startMinute = -1;

  _NotDisturbPage(this._blePlugin);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("Not Disturb"),
            ),
            body: Center(child: ListView(children: <Widget>[
              Text("periodTimeType: $_periodTimeType"),
              Text("startHour: $_startHour"),
              Text("startMinute: $_startMinute"),
              Text("endHour: $_endHour"),
              Text("endMinute: $_endMinute"),

              ElevatedButton(
                  child: const Text('queryDoNotDisturbTime()'),
                  onPressed: () async {
                    _periodTimeResultBean = await _blePlugin.queryDoNotDisturbTime;
                    setState(() {
                    _periodTimeType = _periodTimeResultBean!.periodTimeType;
                    _periodTimeInfo = _periodTimeResultBean!.periodTimeInfo;
                    _endHour = _periodTimeInfo!.endHour;
                    _endMinute = _periodTimeInfo!.endMinute;
                    _startHour = _periodTimeInfo!.startHour;
                    _startMinute = _periodTimeInfo!.startMinute;
                  });}),
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
