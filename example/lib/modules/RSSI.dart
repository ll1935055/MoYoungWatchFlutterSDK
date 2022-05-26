import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

class RSSIPage extends StatefulWidget {
  MoYoungBle blePlugin;

  RSSIPage({
    Key? key,
    required this.blePlugin,
  }) : super(key: key);

  @override
  State<RSSIPage> createState() {
    return _RSSIPage(blePlugin);
  }
}

class _RSSIPage extends State<RSSIPage> {
  final MoYoungBle _blePlugin;

  _RSSIPage(this._blePlugin);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("RSSIPage"),
            ),
            body: Center(child: ListView(children: <Widget>[
              ElevatedButton(
                  child: const Text('readDeviceRssi'),
                  onPressed: () => _blePlugin.readDeviceRssi),
            ])
            )
        )
    );
  }
}
