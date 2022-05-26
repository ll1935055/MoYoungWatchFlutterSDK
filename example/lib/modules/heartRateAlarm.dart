import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

class HeartRateAlarmPage extends StatefulWidget {
  MoYoungBle blePlugin;

  HeartRateAlarmPage({
    Key? key,
    required this.blePlugin,
  }) : super(key: key);

  @override
  State<HeartRateAlarmPage> createState() {
    return _heartRateAlarmPage(blePlugin);
  }
}

class _heartRateAlarmPage extends State<HeartRateAlarmPage> {
  final MoYoungBle _blePlugin;

  _heartRateAlarmPage(this._blePlugin);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("HeartRateAlarmPage"),
            ),
            body: Center(child: ListView(children: <Widget>[
              ElevatedButton(
                  onPressed: () => _blePlugin.setMaxHeartRate(50, true),
                  child: const Text("setMaxHeartRate()")),
              ElevatedButton(
                  onPressed: () => _blePlugin.queryMaxHeartRate,
                  child: const Text("queryMaxHeartRate()")),
            ])
            )
        )
    );
  }
}
