import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

class TapWakePage extends StatefulWidget {
  MoYoungBle blePlugin;

  TapWakePage({
    Key? key,
    required this.blePlugin,
  }) : super(key: key);

  @override
  State<TapWakePage> createState() {
    return _tapWakePage(blePlugin);
  }
}

class _tapWakePage extends State<TapWakePage> {
  final MoYoungBle _blePlugin;

  _tapWakePage(this._blePlugin);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("TapWakePage"),
            ),
            body: Center(child: ListView(children: <Widget>[
              ElevatedButton(
                  onPressed: () => _blePlugin.queryWakeState,
                  child: const Text("queryWakeState()")),
              ElevatedButton(
                  onPressed: () => _blePlugin.sendWakeState(true),
                  child: const Text("sendWakeState(true)")),
              ElevatedButton(
                  onPressed: () => _blePlugin.sendWakeState(false),
                  child: const Text("sendTapToWakeState(false)")),
            ])
            )
        )
    );
  }
}
