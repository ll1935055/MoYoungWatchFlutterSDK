import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

class FindPhonePage extends StatefulWidget {
  MoYoungBle blePlugin;

  FindPhonePage({
    Key? key,
    required this.blePlugin,
  }) : super(key: key);

  @override
  State<FindPhonePage> createState() {
    return _findPhonePage(blePlugin);
  }
}

class _findPhonePage extends State<FindPhonePage> {
  final MoYoungBle _blePlugin;

  _findPhonePage(this._blePlugin);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("FindPhonePage"),
            ),
            body: Center(child: ListView(children: <Widget>[
              ElevatedButton(
                  onPressed: () => _blePlugin.startFindPhone,
                  child: const Text('startFindPhone()')),
              ElevatedButton(
                  onPressed: () => _blePlugin.stopFindPhone,
                  child: const Text("stopFindPhone()")),
            ])
            )
        )
    );
  }
}
