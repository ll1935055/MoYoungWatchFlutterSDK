import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

class BrightnessPage extends StatefulWidget {
  MoYoungBle blePlugin;

  BrightnessPage({
    Key? key,
    required this.blePlugin,
  }) : super(key: key);

  @override
  State<BrightnessPage> createState() {
    return _brightnessPage(blePlugin);
  }
}

class _brightnessPage extends State<BrightnessPage> {
  final MoYoungBle _blePlugin;

  _brightnessPage(this._blePlugin);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("BrightnessPage"),
            ),
            body: Center(child: ListView(children: <Widget>[
              ElevatedButton(
                  onPressed: () => _blePlugin.sendBrightness(5),
                  child: const Text("sendBrightness(5)")),
              ElevatedButton(
                  onPressed: () => _blePlugin.queryBrightness,
                  child: const Text("queryBrightness()")),
            ])
            )
        )
    );
  }
}
