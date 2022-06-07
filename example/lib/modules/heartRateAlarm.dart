import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

class HeartRateAlarmPage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const HeartRateAlarmPage({
    Key? key,
    required this.blePlugin,
  }) : super(key: key);

  @override
  State<HeartRateAlarmPage> createState() {
    return _HeartRateAlarmPage(blePlugin);
  }
}

class _HeartRateAlarmPage extends State<HeartRateAlarmPage> {
  final MoYoungBle _blePlugin;
  MaxHeartRateBean? _maxHeartRateBean;
  int _heartRate = -1;
  bool _enable = false;

  _HeartRateAlarmPage(this._blePlugin);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("Heart Rate Alarm"),
            ),
            body: Center(child: ListView(children: <Widget>[
              Text("heartRate: $_heartRate"),
              Text("enable: $_enable"),

              ElevatedButton(
                  onPressed: () => _blePlugin.setMaxHeartRate(MaxHeartRateBean(
                    heartRate: 100,
                    enable: true,
                  )),
                  child: const Text("setMaxHeartRate()")),
              ElevatedButton(
                  onPressed: () async {
                    _maxHeartRateBean = await _blePlugin.queryMaxHeartRate;
                    setState(() {
                    _enable = _maxHeartRateBean!.enable;
                    _heartRate = _maxHeartRateBean!.heartRate;
                  });},
                  child: const Text("queryMaxHeartRate()")),
            ])
            )
        )
    );
  }
}
