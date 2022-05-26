import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

class TimePage extends StatefulWidget {
  MoYoungBle blePlugin;

  TimePage({
    Key? key,
    required this.blePlugin,
  }) : super(key: key);

  @override
  State<TimePage> createState() {
    return _timePage(blePlugin);
  }
}

class _timePage extends State<TimePage> {
  final MoYoungBle _blePlugin;

  _timePage(this._blePlugin);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("TimePage"),
        ),
        body: Center(
            child: ListView(
                children: <Widget>[
                  ElevatedButton(
                      child: const Text('syncTime()'),
                      onPressed: () => _blePlugin.syncTime),
                  ElevatedButton(
                      child: const Text('sendTimeSystem(TIME_SYSTEM_12)'),
                      onPressed: () => _blePlugin
                          .sendTimeSystem(TimeSystemType.TIME_SYSTEM_12)),
                  ElevatedButton(
                      child: const Text('sendTimeSystem(TIME_SYSTEM_24)'),
                      onPressed: () => _blePlugin
                          .sendTimeSystem(TimeSystemType.TIME_SYSTEM_24)),
                  ElevatedButton(
                      child: const Text('queryTimeSystem()'),
                      onPressed: () => _blePlugin.queryTimeSystem),
                ]
            )
        ),
      ),
    );
  }
}