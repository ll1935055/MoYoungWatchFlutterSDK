import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

class ClassicBluetoothAddressPage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const ClassicBluetoothAddressPage({
    Key? key,
    required this.blePlugin,
  }) : super(key: key);

  @override
  State<ClassicBluetoothAddressPage> createState() {
    return _ClassicBluetoothAddressPage(blePlugin);
  }
}

class _ClassicBluetoothAddressPage extends State<ClassicBluetoothAddressPage> {
  final MoYoungBle _blePlugin;
  String _address = "";

  _ClassicBluetoothAddressPage(this._blePlugin);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("Classic Bluetooth Address"),
            ),
            body: Center(child: ListView(children: <Widget>[
              Text("address: $_address"),

              ElevatedButton(
                  onPressed: () async{
                    String address = await _blePlugin.queryBtAddress;
                    setState(() {
                      _address = address;
                    });
                  },
                  child: const Text("queryBtAddress()")),
            ])
            )
        )
    );
  }
}
