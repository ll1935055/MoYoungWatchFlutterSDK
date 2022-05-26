import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

class ProtocolVersionPage extends StatefulWidget {
  MoYoungBle blePlugin;

  ProtocolVersionPage({
    Key? key,
    required this.blePlugin,
  }) : super(key: key);

  @override
  State<ProtocolVersionPage> createState() {
    return _protocolVersionPage(blePlugin);
  }
}

class _protocolVersionPage extends State<ProtocolVersionPage> {
  final MoYoungBle _blePlugin;

  _protocolVersionPage(this._blePlugin);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("ProtocolVersionPage"),
            ),
            body: Center(child: ListView(children: <Widget>[
              ElevatedButton(
                  onPressed: () => _blePlugin.getProtocolVersion,
                  child: const Text("getProtocolVersion()")),
            ])
            )
        )
    );
  }
}
