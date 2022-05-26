import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

class SetsLocalCityPage extends StatefulWidget {
  MoYoungBle blePlugin;

  SetsLocalCityPage({
    Key? key,
    required this.blePlugin,
  }) : super(key: key);

  @override
  State<SetsLocalCityPage> createState() {
    return _setsLocalCityPage(blePlugin);
  }
}

class _setsLocalCityPage extends State<SetsLocalCityPage> {
  final MoYoungBle _blePlugin;

  _setsLocalCityPage(this._blePlugin);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("SetsLocalCityPage"),
            ),
            body: Center(child: ListView(children: <Widget>[
              ElevatedButton(
                  onPressed: () => _blePlugin.sendLocalCity("永州"),
                  child: const Text("sendLocalCity()")),
            ])
            )
        )
    );
  }
}
