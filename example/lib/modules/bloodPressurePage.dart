import 'dart:async';

import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

class BloodPressurePage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const BloodPressurePage({Key? key, required this.blePlugin}) : super(key: key);

  @override
  State<BloodPressurePage> createState() {
    return _BloodPressurePage(blePlugin);
  }
}

class _BloodPressurePage extends State<BloodPressurePage> {
  final MoYoungBle _blePlugin;
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  bool _continueState = false;
  int _bloodPressureChange = -1;
  int _bloodPressureChange1 = -1;
  List<HistoryBloodPressureBean> _historyBpList = [];

  _BloodPressurePage(this._blePlugin);

  @override
  void initState() {
    super.initState();
    subscriptStream();
  }

  void subscriptStream() {
    _streamSubscriptions.add(
      _blePlugin.bloodPressureEveStm.listen(
            (BloodPressureBean event) {
          setState(() {
            if (event.bloodPressureChange != 255) {
              _continueState = event.continueState;
              _bloodPressureChange = event.bloodPressureChange;
              _bloodPressureChange1 = event.bloodPressureChange1;
              _historyBpList = event.historyBpList;
            }
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("Blood Pressure Page"),
            ),
            body: Center(child: ListView(children: [
              Text("continueState: $_continueState"),
              Text("bloodPressureChange: $_bloodPressureChange"),
              Text("bloodPressureChange1: $_bloodPressureChange1"),
              Text("historyBpList: $_historyBpList"),

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
