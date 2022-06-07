import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

class FindPhonePage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const FindPhonePage({
    Key? key,
    required this.blePlugin,
  }) : super(key: key);

  @override
  State<FindPhonePage> createState() {
    return _FindPhonePage(blePlugin);
  }
}

class _FindPhonePage extends State<FindPhonePage> {
  final MoYoungBle _blePlugin;

  _FindPhonePage(this._blePlugin);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("Find Phone"),
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
