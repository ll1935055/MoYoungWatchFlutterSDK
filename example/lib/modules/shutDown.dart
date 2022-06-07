import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

class ShutDownPage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const ShutDownPage({
    Key? key,
    required this.blePlugin,
  }) : super(key: key);

  @override
  State<ShutDownPage> createState() {
    return _ShutDownPage(blePlugin);
  }
}

class _ShutDownPage extends State<ShutDownPage> {
  final MoYoungBle _blePlugin;

  _ShutDownPage(this._blePlugin);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("Shut Down"),
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
