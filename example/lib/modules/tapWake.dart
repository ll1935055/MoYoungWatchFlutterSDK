import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

class TapWakePage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const TapWakePage({
    Key? key,
    required this.blePlugin,
  }) : super(key: key);

  @override
  State<TapWakePage> createState() {
    return _TapWakePage(blePlugin);
  }
}

class _TapWakePage extends State<TapWakePage> {
  final MoYoungBle _blePlugin;
  bool _enable = false;

  _TapWakePage(this._blePlugin);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("Tap Wake Page"),
            ),
            body: Center(child: ListView(children: <Widget>[
              Text("enable: $_enable"),

              ElevatedButton(
                  onPressed: () => setState(() async {
                    _enable = await _blePlugin.queryWakeState;
                  }),
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
