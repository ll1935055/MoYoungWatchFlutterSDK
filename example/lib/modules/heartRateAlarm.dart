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
  int heartRate = -1;
  bool enable = false;

  _HeartRateAlarmPage(this._blePlugin);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("Heart Rate Alarm Page"),
            ),
            body: Center(child: ListView(children: <Widget>[
              Text("heartRate: $heartRate"),
              Text("enable: $enable"),

              ElevatedButton(
                  onPressed: () => _blePlugin.setMaxHeartRate(MaxHeartRateBean(
                    heartRate: 5,
                    enable: true,
                  )),
                  child: const Text("setMaxHeartRate()")),
              ElevatedButton(
                  onPressed: () => setState(() async {
                    _maxHeartRateBean = await _blePlugin.queryMaxHeartRate;
                    enable = _maxHeartRateBean!.enable;
                    heartRate = _maxHeartRateBean!.heartRate;
                  }),
                  child: const Text("queryMaxHeartRate()")),
            ])
            )
        )
    );
  }
}
