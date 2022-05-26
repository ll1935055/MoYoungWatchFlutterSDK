import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

class DisplayTimePage extends StatefulWidget {
  MoYoungBle blePlugin;

  DisplayTimePage({
    Key? key,
    required this.blePlugin,
  }) : super(key: key);

  @override
  State<DisplayTimePage> createState() {
    return _displayTimePage(blePlugin);
  }
}

class _displayTimePage extends State<DisplayTimePage> {
  final MoYoungBle _blePlugin;

  _displayTimePage(this._blePlugin);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("DisplayTimePage"),
            ),
            body: Center(child: ListView(children: <Widget>[
              ElevatedButton(
                  onPressed: () => _blePlugin.sendDisplayTime(20),
                  child: const Text("sendDisplayTime()")),
              ElevatedButton(
                  onPressed: () => _blePlugin.queryDisplayTime,
                  child: const Text("queryDisplayTime()")),
            ])
            )
        )
    );
  }
}
