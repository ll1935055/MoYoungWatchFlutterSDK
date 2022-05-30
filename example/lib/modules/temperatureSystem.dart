import 'dart:async';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

class TemperatureSystemPage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const TemperatureSystemPage({
    Key? key,
    required this.blePlugin,
  }) : super(key: key);

  @override
  State<TemperatureSystemPage> createState() {
    return _TemperatureSystemPage(blePlugin);
  }
}

class _TemperatureSystemPage extends State<TemperatureSystemPage> {
  final MoYoungBle _blePlugin;
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  Logger logger = Logger();
  bool _enable = false;
  double _temp = 0;
  bool _state = false;
  TempInfo? _tempInfo;
  String _tempTimeType = "";
  int _startTime = -1;
  List<double> _tempList = [];

  _TemperatureSystemPage(this._blePlugin);

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
            logger.d("connTempChangeEveStm======" + event.toString());
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
              title: const Text("Temperature System Page"),
            ),
            body: Center(child: ListView(children: <Widget>[
              Text("enable: $_enable"),
              Text("temp: $_temp"),
              Text("state: $_state"),
              Text("tempTimeType: $_tempTimeType"),
              Text("startTime: $_startTime"),
              Text("tempList: $_tempList"),

              ElevatedButton(
                  onPressed: () => _blePlugin.sendTempUnit(TempUnit.celsius),
                  child: const Text("sendTempUnit()")),
              ElevatedButton(
                  onPressed: () => _blePlugin.sendTempUnit(TempUnit.fahrenheit),
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
