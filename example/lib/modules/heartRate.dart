import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';
import 'package:logger/logger.dart';
import 'dart:async';

class HearRatePage extends StatefulWidget {
  MoYoungBle blePlugin;

  HearRatePage({Key? key, required this.blePlugin}) : super(key: key);

  @override
  State<HearRatePage> createState() {
    return _hearRatePage(blePlugin);
  }
}

class _hearRatePage extends State<HearRatePage> {
  final MoYoungBle _blePlugin;
  Logger logger = Logger();
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  int _onceMeasureComplete = -1;

  _hearRatePage(this._blePlugin);

  @override
  void initState() {
    super.initState();
    subscriptStream();
  }

  void subscriptStream() {
    _streamSubscriptions.add(
      _blePlugin.heartRateEveStm.listen(
        (event) {
          setState(() {
            _onceMeasureComplete = event.onceMeasureComplete;
            // logger.d('connHeartRateEveStm===' + event.measuring.toString());
          });
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("HearRatePage"),
            ),
            body: Center(child: ListView(children: [
              Text("onceMeasureComplete=" + _onceMeasureComplete.toString()),

              ElevatedButton(
                  child: const Text('queryLastDynamicRate()'),
                  onPressed: () => _blePlugin.queryLastDynamicRate(HistoryDynamicRateType.FIRST_HEART_RATE)),
              ElevatedButton(
                  child: const Text('queryLastDynamicRate()'),
                  onPressed: () => _blePlugin.queryLastDynamicRate(HistoryDynamicRateType.SECOND_HEART_RATE)),
              ElevatedButton(
                  child: const Text('queryLastDynamicRate()'),
                  onPressed: () => _blePlugin.queryLastDynamicRate(HistoryDynamicRateType.THIRD_HEART_RATE)),
              ElevatedButton(
                  child: const Text('enableTimingMeasureHeartRate(10)'),
                  onPressed: () => _blePlugin.enableTimingMeasureHeartRate(10)),
              ElevatedButton(
                  child: const Text('disableTimingMeasureHeartRate()'),
                  onPressed: () => _blePlugin.disableTimingMeasureHeartRate),
              ElevatedButton(
                  child: const Text('queryTimingMeasureHeartRate()'),
                  onPressed: () => _blePlugin.queryTimingMeasureHeartRate),
              ElevatedButton(
                  child: const Text(
                      'queryTodayHeartRate(TIMING_MEASURE_HEART_RATE)'),
                  onPressed: () => _blePlugin.queryTodayHeartRate(
                      TodayHeartRateType.TIMING_MEASURE_HEART_RATE)),
              ElevatedButton(
                  child: const Text('queryTodayHeartRate(ALL_DAY_HEART_RATE)'),
                  onPressed: () => _blePlugin.queryTodayHeartRate(
                      TodayHeartRateType.ALL_DAY_HEART_RATE)),
              ElevatedButton(
                  child: const Text('queryPastHeartRate'),
                  onPressed: () => _blePlugin.queryPastHeartRate),
              ElevatedButton(
                  child: const Text('queryMovementHeartRate'),
                  onPressed: () => _blePlugin.queryMovementHeartRate),
              ElevatedButton(
                  child: const Text('startMeasureOnceHeartRate'),
                  onPressed: () => _blePlugin.startMeasureOnceHeartRate),
              ElevatedButton(
                  child: const Text('stopMeasureOnceHeartRate'),
                  onPressed: () => _blePlugin.stopMeasureOnceHeartRate),
              ElevatedButton(
                  child: const Text('queryHistoryHeartRate'),
                  onPressed: () => _blePlugin.queryHistoryHeartRate),
            ])
            )
        )
    );
  }
}
