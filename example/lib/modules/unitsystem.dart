import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

class UnitSystemPage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const UnitSystemPage({Key? key, required this.blePlugin}) : super(key: key);

  @override
  State<UnitSystemPage> createState() {
    return _UnitSystemPage(blePlugin);
  }
}

class _UnitSystemPage extends State<UnitSystemPage> {
  final MoYoungBle _blePlugin;
  int _unitSystemType = -1;

  _UnitSystemPage(this._blePlugin);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("UnitSystem"),
            ),
            body: Center(
            child: ListView(
              children: [
                Text("unitSystemType: $_unitSystemType"),

                ElevatedButton(
                    child: const Text('queryMetricSystem()'),
                    onPressed: () async {
                      int unitSystemType = await _blePlugin.queryUnitSystem;
                      setState(() {
                      _unitSystemType = unitSystemType;
                    });}),
                ElevatedButton(
                    child: const Text('sendMetricSystem(METRIC_SYSTEM)'),
                    onPressed: () => _blePlugin
                        .sendUnitSystem(UnitSystemType.metricSystem)),
                ElevatedButton(
                    child: const Text('sendMetricSystem(IMPERIAL_SYSTEM)'),
                    onPressed: () => _blePlugin
                        .sendUnitSystem(UnitSystemType.imperialSystem)),
              ],
            )
            )
        )
    );
  }
}
