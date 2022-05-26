import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

class BatteryPage extends StatefulWidget {
  MoYoungBle blePlugin;

  BatteryPage({
    Key? key,
    required this.blePlugin,
  }) : super(key: key);

  @override
  State<BatteryPage> createState() {
    return _batteryPage(blePlugin);
  }
}

class _batteryPage extends State<BatteryPage> {
  final MoYoungBle _blePlugin;

  _batteryPage(this._blePlugin);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("BatteryPage"),
            ),
            body: Center(
                child: ListView(
                    children: <Widget>[
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
