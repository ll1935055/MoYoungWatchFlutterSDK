import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

class BloodPressurePage extends StatefulWidget {
  MoYoungBle blePlugin;

  BloodPressurePage({Key? key, required this.blePlugin}) : super(key: key);

  @override
  State<BloodPressurePage> createState() {
    return _bloodPressurePage(blePlugin);
  }
}

class _bloodPressurePage extends State<BloodPressurePage> {
  final MoYoungBle _blePlugin;

  _bloodPressurePage(this._blePlugin);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("BloodPressurePage"),
            ),
            body: Center(child: ListView(children: [
              ElevatedButton(
                  child: const Text('startMeasureBloodPressure'),
                  onPressed: () => _blePlugin.startMeasureBloodPressure),
              ElevatedButton(
                  child: const Text('stopMeasureBloodPressure'),
                  onPressed: () => _blePlugin.stopMeasureBloodPressure),
              ElevatedButton(
                  child: const Text('enableContinueBloodPressure'),
                  onPressed: () => _blePlugin.enableContinueBloodPressure),
              ElevatedButton(
                  child: const Text('disableContinueBloodPressure'),
                  onPressed: () => _blePlugin.disableContinueBloodPressure),
              ElevatedButton(
                  child: const Text('queryContinueBloodPressureState'),
                  onPressed: () => _blePlugin.queryContinueBloodPressureState),
              ElevatedButton(
                  child: const Text('queryLast24HourBloodPressure'),
                  onPressed: () => _blePlugin.queryLast24HourBloodPressure),
              ElevatedButton(
                  child: const Text('queryHistoryBloodPressure'),
                  onPressed: () => _blePlugin.queryHistoryBloodPressure),
            ])
            )
        )
    );
  }
}
