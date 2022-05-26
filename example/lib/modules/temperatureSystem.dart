import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

class TemperatureSystemPage extends StatefulWidget {
  MoYoungBle blePlugin;

  TemperatureSystemPage({
    Key? key,
    required this.blePlugin,
  }) : super(key: key);

  @override
  State<TemperatureSystemPage> createState() {
    return _temperatureSystemPage(blePlugin);
  }
}

class _temperatureSystemPage extends State<TemperatureSystemPage> {
  final MoYoungBle _blePlugin;

  _temperatureSystemPage(this._blePlugin);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("TemperatureSystemPage"),
            ),
            body: Center(child: ListView(children: <Widget>[
              ElevatedButton(
                  onPressed: () => _blePlugin.sendTempUnit(TempUnit.CELSIUS),
                  child: const Text("sendTempUnit()")),
              ElevatedButton(
                  onPressed: () => _blePlugin.sendTempUnit(TempUnit.FAHRENHEIT),
                  child: const Text("sendTempUnit()")),
              ElevatedButton(
                  onPressed: () => _blePlugin.queryTempUnit,
                  child: const Text("queryTempUnit()")),
            ])
            )
        )
    );
  }
}
