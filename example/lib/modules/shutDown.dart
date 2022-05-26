import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

class ShutDownPage extends StatefulWidget {
  MoYoungBle blePlugin;

  ShutDownPage({
    Key? key,
    required this.blePlugin,
  }) : super(key: key);

  @override
  State<ShutDownPage> createState() {
    return _shutDownPage(blePlugin);
  }
}

class _shutDownPage extends State<ShutDownPage> {
  final MoYoungBle _blePlugin;

  _shutDownPage(this._blePlugin);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("ShutDownPage"),
            ),
            body: Center(child: ListView(children: <Widget>[
              ElevatedButton(
                  child: const Text('shutDown()'),
                  onPressed: () => _blePlugin.shutDown),
            ])
            )
        )
    );
  }
}
