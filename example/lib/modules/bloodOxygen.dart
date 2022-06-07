import 'dart:async';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

class BloodOxygenPage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const BloodOxygenPage({
    Key? key,
    required this.blePlugin,
  }) : super(key: key);

  @override
  State<BloodOxygenPage> createState() {
    return _BloodOxygenPage(blePlugin);
  }
}

class _BloodOxygenPage extends State<BloodOxygenPage> {
  final MoYoungBle _blePlugin;
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  Logger logger = Logger();
  bool _continueState = false;
  int _timingMeasure = -1;
  int _bloodOxygen = -1;
  List<HistoryBloodOxygenBean> _historyList = [];
  BloodOxygenInfo? _continueBo;
  int _startTime = -1;
  int _timeInterval = -1;

  _BloodOxygenPage(this._blePlugin);

  @override
  void initState() {
    super.initState();
    subscriptStream();
  }

  void subscriptStream() {
    _streamSubscriptions.add(
      _blePlugin.bloodOxygenEveStm.listen(
            (BloodOxygenBean event) {
          setState(() {
            switch (event.type) {
              case BloodOxygenType.continueState:
                _continueState = event.continueState!;
                break;
              case BloodOxygenType.timingMeasure:
                _timingMeasure = event.timingMeasure!;
                break;
              case BloodOxygenType.bloodOxygen:
                _bloodOxygen = event.bloodOxygen!;
                break;
              case BloodOxygenType.historyList:
                _historyList = event.historyList!;
                break;
              case BloodOxygenType.continueBO:
                _continueBo = event.continueBo!;
                _startTime = _continueBo!.startTime!;
                _timeInterval = _continueBo!.timeInterval!;
                break;
              default:
                break;
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
              title: const Text("Blood Oxygen"),
            ),
            body: Center(child: ListView(children: <Widget>[
              Text("continueState: $_continueState"),
              Text("timingMeasure: $_timingMeasure"),
              Text("bloodOxygen: $_bloodOxygen"),
              Text("historyList[0]: $_historyList"),
              Text("startTime: $_startTime"),
              Text("timeInterval: $_timeInterval"),

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
                  onPressed: () => _blePlugin.queryTimingBloodOxygen(BloodOxygenTimeType.today)),
              ElevatedButton(
                  child: const Text('queryTimingBloodOxygen(CRPBloodOxygenTimeType)'),
                  onPressed: () => _blePlugin.queryTimingBloodOxygen(BloodOxygenTimeType.yesterday)),
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
