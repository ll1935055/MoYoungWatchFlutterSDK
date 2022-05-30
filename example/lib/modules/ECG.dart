import 'dart:async';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

class ECGPage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const ECGPage({
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
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  Logger logger = Logger();
  List<int> _ints = [];
  int _measureComplete = -1;
  String _date = "";
  bool _isCancel = false;
  bool _isFail = false;

  _ECGPage(this._blePlugin);

  @override
  void initState() {
    super.initState();
    subscriptStream();
  }

  void subscriptStream() {
    _streamSubscriptions.add(
      _blePlugin.ecgEveStm.listen(
            (EgcBean event) {
          setState(() {
            logger.d('ecgEveStm===' + event.ints.toString());
            _ints = event.ints;
            _measureComplete = event.measureComplete;
            _date = event.date;
            _isCancel = event.isCancel;
            _isFail = event.isFail;
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
              title: const Text("ECG Page"),
            ),
            body: Center(child: ListView(children: <Widget>[
              Text("ints: $_ints"),
              Text("ints: $_measureComplete"),
              Text("ints: $_date"),
              Text("ints: $_isCancel"),
              Text("ints: $_isFail"),

              ElevatedButton(
                  child: const Text('setECGChangeListener()'),
                  onPressed: () => _blePlugin.setECGChangeListener(EcgMeasureType.ti)),
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
