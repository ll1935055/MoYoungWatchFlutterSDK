import 'dart:async';

import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

class BodyTemperaturePage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const BodyTemperaturePage({
    Key? key,
    required this.blePlugin,
  }) : super(key: key);

  @override
  State<BodyTemperaturePage> createState() {
    return _BodyTemperaturePage(blePlugin);
  }
}

class _BodyTemperaturePage extends State<BodyTemperaturePage> {
  final MoYoungBle _blePlugin;
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  bool _enable = false;
  double _temp = -1.0;
  bool _state = false;
  TempInfo? _tempInfo;
  String _tempTimeType = "";
  int _startTime = -1;
  List<double> _tempList = [];

  _BodyTemperaturePage(this._blePlugin);

  @override
  void initState() {
    super.initState();
    subscriptStream();
  }


  void subscriptStream() {
    _streamSubscriptions.add(
      _blePlugin.tempChangeEveStm.listen(
            (TempChangeBean event) {
          setState(() {
            _enable = event.enable;
            _temp = event.temp;
            _state = event.state;
            _tempInfo = event.tempInfo;
            _tempTimeType = _tempInfo!.tempTimeType;
            _startTime = _tempInfo!.startTime;
            _tempList = _tempInfo!.tempList;
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
              title: const Text("Body Temperature Page"),
            ),
            body: Center(child: ListView(children: <Widget>[
              Text("enable: $_enable"),
              Text("temp: $_temp"),
              Text("state: $_state"),
              Text("tempTimeType: $_tempTimeType"),
              Text("startTime: $_startTime"),
              Text("tempList: $_tempList"),

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
                      _blePlugin.queryTimingMeasureTemp(TempTimeType.yesterday),
                  child: const Text("queryTimingMeasureTemp()")),
              ElevatedButton(
                  onPressed: () =>
                      _blePlugin.queryTimingMeasureTemp(TempTimeType.today),
                  child: const Text("queryTimingMeasureTemp()")),
            ])
            )
        )
    );
  }
}
