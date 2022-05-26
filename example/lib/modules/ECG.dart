import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

class ECGPage extends StatefulWidget {
  MoYoungBle blePlugin;

  ECGPage({
    Key? key,
    required this.blePlugin,
  }) : super(key: key);

  @override
  State<ECGPage> createState() {
    return _ECGPage(blePlugin);
  }
}

class _ECGPage extends State<ECGPage> {
  final MoYoungBle _blePlugin;

  _ECGPage(this._blePlugin);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("ECGPage"),
            ),
            body: Center(child: ListView(children: <Widget>[
              ElevatedButton(
                  child: const Text('setECGChangeListener()'),
                  onPressed: () => _blePlugin.setECGChangeListener(EcgMeasureType.TI)),
              ElevatedButton(
                  child: const Text('startECGMeasure'),
                  onPressed: () => _blePlugin.startECGMeasure),
              ElevatedButton(
                  child: const Text('stopECGMeasure'),
                  onPressed: () => _blePlugin.stopECGMeasure),
              ElevatedButton(
                  child: const Text('isNewECGMeasurementVersion'),
                  onPressed: () => _blePlugin.isNewECGMeasurementVersion),
              ElevatedButton(
                  child: const Text('queryLastMeasureECGData'),
                  onPressed: () => _blePlugin.queryLastMeasureECGData),
              ElevatedButton(
                  child: const Text('sendECGHeartRate'),
                  onPressed: () => _blePlugin.sendECGHeartRate(78)),
            ])
            )
        )
    );
  }
}
