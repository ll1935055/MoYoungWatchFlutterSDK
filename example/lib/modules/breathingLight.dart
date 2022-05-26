import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

class BreathingLightPage extends StatefulWidget {
  MoYoungBle blePlugin;

  BreathingLightPage({
    Key? key,
    required this.blePlugin,
  }) : super(key: key);

  @override
  State<BreathingLightPage> createState() {
    return _breathingLightPage(blePlugin);
  }
}

class _breathingLightPage extends State<BreathingLightPage> {
  final MoYoungBle _blePlugin;

  _breathingLightPage(this._blePlugin);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("BreathingLightPage"),
            ),
            body: Center(child: ListView(children: <Widget>[
              ElevatedButton(
                  child: const Text('sendBreathingLight(false)'),
                  onPressed: () => _blePlugin.sendBreathingLight(false)),
              ElevatedButton(
                  child: const Text('sendBreathingLight(true)'),
                  onPressed: () => _blePlugin.sendBreathingLight(true)),
              ElevatedButton(
                  child: const Text('queryBreathingLight()'),
                  onPressed: () => _blePlugin.queryBreathingLight),
            ])
            )
        )
    );
  }
}
