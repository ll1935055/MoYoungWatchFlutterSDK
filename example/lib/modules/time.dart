import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

class TimePage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const TimePage({
    Key? key,
    required this.blePlugin,
  }) : super(key: key);

  @override
  State<TimePage> createState() {
    return _TimePage(blePlugin);
  }
}

class _TimePage extends State<TimePage> {
  final MoYoungBle _blePlugin;
  int _time = -1;

  _TimePage(this._blePlugin);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Time"),
        ),
        body: Center(
            child: ListView(
                children: <Widget>[
                  Text("time: $_time"),

                  ElevatedButton(
                      child: const Text('queryTime()'),
                      onPressed: () => _blePlugin.queryTime),
                  ElevatedButton(
                      child: const Text('sendTimeSystem(TIME_SYSTEM_12)'),
                      onPressed: () => _blePlugin
                          .sendTimeSystem(TimeSystemType.timeSystem12)),
                  ElevatedButton(
                      child: const Text('sendTimeSystem(TIME_SYSTEM_24)'),
                      onPressed: () => _blePlugin
                          .sendTimeSystem(TimeSystemType.timeSystem24)),
                  ElevatedButton(
                      child: const Text('queryTimeSystem()'),
                      onPressed: () async {
                        int time = await _blePlugin.queryTimeSystem;
                        setState(() {
                          _time = time;
                        });
                      }),
                ]
            )
        ),
      ),
    );
  }
}