import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

class UnitSystemPage extends StatefulWidget {
  MoYoungBle blePlugin;

  UnitSystemPage({Key? key, required this.blePlugin}) : super(key: key);

  @override
  State<UnitSystemPage> createState() {
    return _unitSystemPage(blePlugin);
  }
}

class _unitSystemPage extends State<UnitSystemPage> {
  final MoYoungBle _blePlugin;

  _unitSystemPage(this._blePlugin);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("UnitSystemPage"),
            ),
            body: Center(
            child: ListView(
              children: [
                ElevatedButton(
                    child: const Text('queryMetricSystem()'),
                    onPressed: () => _blePlugin.queryUnitSystem),
                ElevatedButton(
                    child: const Text('sendMetricSystem(METRIC_SYSTEM)'),
                    onPressed: () => _blePlugin
                        .sendUnitSystem(UnitSystemType.METRIC_SYSTEM)),
                ElevatedButton(
                    child: const Text('sendMetricSystem(IMPERIAL_SYSTEM)'),
                    onPressed: () => _blePlugin
                        .sendUnitSystem(UnitSystemType.IMPERIAL_SYSTEM)),
              ],
            )
            )
        )
    );
  }
}
