import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

class ClassicBluetoothAddressPage extends StatefulWidget {
  MoYoungBle blePlugin;

  ClassicBluetoothAddressPage({
    Key? key,
    required this.blePlugin,
  }) : super(key: key);

  @override
  State<ClassicBluetoothAddressPage> createState() {
    return _classicBluetoothAddressPage(blePlugin);
  }
}

class _classicBluetoothAddressPage extends State<ClassicBluetoothAddressPage> {
  final MoYoungBle _blePlugin;

  _classicBluetoothAddressPage(this._blePlugin);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("ClassicBluetoothAddressPage"),
            ),
            body: Center(child: ListView(children: <Widget>[
              ElevatedButton(
                  onPressed: () => _blePlugin.queryBtAddress,
                  child: const Text("queryBtAddress()")),
            ])
            )
        )
    );
  }
}
