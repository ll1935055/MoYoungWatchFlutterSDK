import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

class ProtocolVersionPage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const ProtocolVersionPage({
    Key? key,
    required this.blePlugin,
  }) : super(key: key);

  @override
  State<ProtocolVersionPage> createState() {
    return _ProtocolVersionPage(blePlugin);
  }
}

class _ProtocolVersionPage extends State<ProtocolVersionPage> {
  final MoYoungBle _blePlugin;
  String _protocolVersion = "";

  _ProtocolVersionPage(this._blePlugin);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("Protocol Version"),
            ),
            body: Center(child: ListView(children: <Widget>[
              Text("protocolVersion: $_protocolVersion"),

              ElevatedButton(
                  onPressed: () async {
                    String protocolVersion = await _blePlugin.getProtocolVersion;
                    setState(() {
                    _protocolVersion = protocolVersion;
                  });},
                  child: const Text("getProtocolVersion()")),
            ])
            )
        )
    );
  }
}
