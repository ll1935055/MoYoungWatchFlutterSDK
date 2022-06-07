import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

class BreathingLightPage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const BreathingLightPage({
    Key? key,
    required this.blePlugin,
  }) : super(key: key);

  @override
  State<BreathingLightPage> createState() {
    return _BreathingLightPage(blePlugin);
  }
}

class _BreathingLightPage extends State<BreathingLightPage> {
  final MoYoungBle _blePlugin;
  bool _breathingLight = false;

  _BreathingLightPage(this._blePlugin);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("Breathing Light"),
            ),
            body: Center(child: ListView(children: <Widget>[
              Text("breathingLight: $_breathingLight"),

              ElevatedButton(
                  child: const Text('sendBreathingLight(false)'),
                  onPressed: () => _blePlugin.sendBreathingLight(false)),
              ElevatedButton(
                  child: const Text('sendBreathingLight(true)'),
                  onPressed: () => _blePlugin.sendBreathingLight(true)),
              ElevatedButton(
                  child: const Text('queryBreathingLight()'),
                  onPressed: () async {
                    bool breathingLight = await _blePlugin.queryBreathingLight;
                    setState(() {
                      _breathingLight = breathingLight;
                    });
                  }),
            ])
            )
        )
    );
  }
}
