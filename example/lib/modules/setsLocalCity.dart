import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

class SetsLocalCityPage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const SetsLocalCityPage({
    Key? key,
    required this.blePlugin,
  }) : super(key: key);

  @override
  State<SetsLocalCityPage> createState() {
    return _SetsLocalCityPage(blePlugin);
  }
}

class _SetsLocalCityPage extends State<SetsLocalCityPage> {
  final MoYoungBle _blePlugin;

  _SetsLocalCityPage(this._blePlugin);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("Sets Local City Page"),
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
