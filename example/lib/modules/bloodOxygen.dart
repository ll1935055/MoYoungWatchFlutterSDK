import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

class BloodOxygenPage extends StatefulWidget {
  MoYoungBle blePlugin;

  BloodOxygenPage({
    Key? key,
    required this.blePlugin,
  }) : super(key: key);

  @override
  State<BloodOxygenPage> createState() {
    return _bloodOxygenPage(blePlugin);
  }
}

class _bloodOxygenPage extends State<BloodOxygenPage> {
  final MoYoungBle _blePlugin;

  _bloodOxygenPage(this._blePlugin);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("BloodOxygenPage"),
            ),
            body: Center(child: ListView(children: <Widget>[
              ElevatedButton(
                  child: const Text('startMeasureBloodOxygen'),
                  onPressed: () => _blePlugin.startMeasureBloodOxygen),
              ElevatedButton(
                  child: const Text('stopMeasureBloodOxygen'),
                  onPressed: () => _blePlugin.stopMeasureBloodOxygen),
              ElevatedButton(
                  child: const Text('enableTimingMeasureBloodOxygen(1)'),
                  onPressed: () =>
                      _blePlugin.enableTimingMeasureBloodOxygen(1)),
              ElevatedButton(
                  child: const Text('disableTimingMeasureBloodOxygen'),
                  onPressed: () => _blePlugin.disableTimingMeasureBloodOxygen),
              ElevatedButton(
                  child: const Text('queryTimingBloodOxygenMeasureState'),
                  onPressed: () =>
                  _blePlugin.queryTimingBloodOxygenMeasureState),
              ElevatedButton(
                  child: const Text('queryTimingBloodOxygen(CRPBloodOxygenTimeType)'),
                  onPressed: () => _blePlugin.queryTimingBloodOxygen(BloodOxygenTimeType.TODAY)),
              ElevatedButton(
                  child: const Text('queryTimingBloodOxygen(CRPBloodOxygenTimeType)'),
                  onPressed: () => _blePlugin.queryTimingBloodOxygen(BloodOxygenTimeType.YESTERDAY)),
              ElevatedButton(
                  child: const Text('enableContinueBloodOxygen'),
                  onPressed: () => _blePlugin.enableContinueBloodOxygen),
              ElevatedButton(
                  child: const Text('disableContinueBloodOxygen'),
                  onPressed: () => _blePlugin.disableContinueBloodOxygen),
              ElevatedButton(
                  child: const Text('queryContinueBloodOxygenState'),
                  onPressed: () => _blePlugin.queryContinueBloodOxygenState),
              ElevatedButton(
                  child: const Text('queryLast24HourBloodOxygen'),
                  onPressed: () => _blePlugin.queryLast24HourBloodOxygen),
              ElevatedButton(
                  child: const Text('queryHistoryBloodOxygen'),
                  onPressed: () => _blePlugin.queryHistoryBloodOxygen),
            ])
            )
        )
    );
  }
}
