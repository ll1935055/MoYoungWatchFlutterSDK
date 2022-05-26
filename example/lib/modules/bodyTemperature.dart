import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

class BodyTemperaturePage extends StatefulWidget {
  MoYoungBle blePlugin;

  BodyTemperaturePage({
    Key? key,
    required this.blePlugin,
  }) : super(key: key);

  @override
  State<BodyTemperaturePage> createState() {
    return _bodyTemperaturePage(blePlugin);
  }
}

class _bodyTemperaturePage extends State<BodyTemperaturePage> {
  final MoYoungBle _blePlugin;

  _bodyTemperaturePage(this._blePlugin);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("BodyTemperaturePage"),
            ),
            body: Center(child: ListView(children: <Widget>[
              ElevatedButton(
                  onPressed: () => _blePlugin.startMeasureTemp,
                  child: const Text("startMeasureTemp()")),
              ElevatedButton(
                  onPressed: () => _blePlugin.stopMeasureTemp,
                  child: const Text("stopMeasureTemp()")),
              ElevatedButton(
                  onPressed: () => _blePlugin.enableTimingMeasureTemp,
                  child: const Text("enableTimingMeasureTemp()")),
              ElevatedButton(
                  onPressed: () => _blePlugin.disableTimingMeasureTemp,
                  child: const Text("disableTimingMeasureTemp()")),
              ElevatedButton(
                  onPressed: () => _blePlugin.queryTimingMeasureTempState,
                  child: const Text("queryTimingMeasureTempState()")),
              ElevatedButton(
                  onPressed: () =>
                      _blePlugin.queryTimingMeasureTemp(TempTimeType.YESTERDAY),
                  child: const Text("queryTimingMeasureTemp()")),
              ElevatedButton(
                  onPressed: () =>
                      _blePlugin.queryTimingMeasureTemp(TempTimeType.TODAY),
                  child: const Text("queryTimingMeasureTemp()")),
            ])
            )
        )
    );
  }
}
