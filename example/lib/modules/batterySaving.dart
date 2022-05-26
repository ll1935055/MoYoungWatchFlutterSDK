import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

class BatterySavingPage extends StatefulWidget {
  MoYoungBle blePlugin;

  BatterySavingPage({
    Key? key,
    required this.blePlugin,
  }) : super(key: key);

  @override
  State<BatterySavingPage> createState() {
    return _batterySavingPage(blePlugin);
  }
}

class _batterySavingPage extends State<BatterySavingPage> {
  final MoYoungBle _blePlugin;

  _batterySavingPage(this._blePlugin);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("BatterySavingPage"),
            ),
            body: Center(child: ListView(children: <Widget>[
              ElevatedButton(
                  onPressed: () => _blePlugin.sendBatterySaving(true),
                  child: const Text("sendBatterySaving(true)")),
              ElevatedButton(
                  onPressed: () => _blePlugin.sendBatterySaving(false),
                  child: const Text("sendBatterySaving(false)")),
              ElevatedButton(
                  onPressed: () => _blePlugin.queryBatterySaving,
                  child: const Text("queryBatterySaving()")),
            ])
            )
        )
    );
  }
}
