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
  String _date = "";
  _ECGPage(this._blePlugin);
  bool _isNewECGMeasurementVersion = true;

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
            switch(event.type){
              case ECGType.ecgChangeInts:
                _ints = event.ints!;
                break;
              case ECGType.measureComplete:
                break;
              case ECGType.date:
                _date = event.date!;
                break;
              case ECGType.cancel:
                break;
              case ECGType.fail:
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
              title: const Text("ECG"),
            ),
            body: Center(child: ListView(children: <Widget>[
              Text("ints: $_ints"),
              Text("date: $_date"),
              Text("isNewECGMeasurementVersion: $_isNewECGMeasurementVersion"),

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
                  onPressed: () async {
                    bool isNewECGMeasurementVersion = await _blePlugin.isNewECGMeasurementVersion;
                    setState(() {
                      _isNewECGMeasurementVersion = isNewECGMeasurementVersion;
                    });
                  }),
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
