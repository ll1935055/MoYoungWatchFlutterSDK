import 'dart:async';

import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

class BatteryPage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const BatteryPage({
    Key? key,
    required this.blePlugin,
  }) : super(key: key);

  @override
  State<BatteryPage> createState() {
    return _BatteryPage(blePlugin);
  }
}

class _BatteryPage extends State<BatteryPage> {
  final MoYoungBle _blePlugin;
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  int _deviceBattery = -1;
  bool _enable = false;

  _BatteryPage(this._blePlugin);

  @override
  void initState() {
    super.initState();
    subscriptStream();
  }

  void subscriptStream() {
    _streamSubscriptions.add(
      _blePlugin.deviceBatteryEveStm.listen(
            (DeviceBatteryBean event) {
          setState(() {
              _deviceBattery = event.deviceBattery;
              _enable = event.isSubscribe;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("Battery Page"),
            ),
            body: Center(
                child: ListView(
                    children: <Widget>[
                      Text("deviceBattery: $_deviceBattery"),
                      Text("enable: $_enable"),

                      ElevatedButton(
                          child: const Text('queryDeviceBattery()'),
                          onPressed: () => _blePlugin.queryDeviceBattery),
                      ElevatedButton(
                          child: const Text('subscribeDeviceBattery()'),
                          onPressed: () => _blePlugin.subscribeDeviceBattery),
                    ]
                )
            )
        )
    );
  }
}
