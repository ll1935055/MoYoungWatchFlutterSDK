import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';
import 'package:logger/logger.dart';
import 'dart:async';

class HearRatePage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const HearRatePage({Key? key, required this.blePlugin}) : super(key: key);

  @override
  State<HearRatePage> createState() {
    return _HearRatePage(blePlugin);
  }
}

class _HearRatePage extends State<HearRatePage> {
  final MoYoungBle _blePlugin;
  Logger logger = Logger();
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  int _measuring = -1;
  int _onceMeasureComplete = -1;
  List<HistoryHeartRateBean> _historyHrList = [];
  HeartRateInfo? _measureComplete;
  HeartRateInfo? _hour24MeasureResult;
  List<TrainingHeartRateBean> _trainingList = [];

  _HearRatePage(this._blePlugin);

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
            _measuring = event.measuring;
            _onceMeasureComplete = event.onceMeasureComplete;
            _historyHrList = event.historyHrList;
            _measureComplete = event.measureComplete;
            _hour24MeasureResult = event.hour24MeasureResult;
            _trainingList = event.trainingList;
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
              title: const Text("Hear Rate Page"),
            ),
            body: Center(child: ListView(children: [
              Text("measuring: $_measuring"),
              Text("onceMeasureComplete: $_onceMeasureComplete"),
              Text("historyHrList: $_historyHrList"),
              Text("measureComplete: $_measureComplete"),
              Text("hour24MeasureResult: $_hour24MeasureResult"),
              Text("trainingList: $_trainingList"),

              ElevatedButton(
                  child: const Text('queryLastDynamicRate()'),
                  onPressed: () => _blePlugin.queryLastDynamicRate(HistoryDynamicRateType.firstHeartRate)),
              ElevatedButton(
                  child: const Text('queryLastDynamicRate()'),
                  onPressed: () => _blePlugin.queryLastDynamicRate(HistoryDynamicRateType.secondHeartRate)),
              ElevatedButton(
                  child: const Text('queryLastDynamicRate()'),
                  onPressed: () => _blePlugin.queryLastDynamicRate(HistoryDynamicRateType.thirdHeartRate)),
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
                      TodayHeartRateType.timingMeasureHeartRate)),
              ElevatedButton(
                  child: const Text('queryTodayHeartRate(ALL_DAY_HEART_RATE)'),
                  onPressed: () => _blePlugin.queryTodayHeartRate(
                      TodayHeartRateType.allDayHeartRate)),
              ElevatedButton(
                  child: const Text('queryPastHeartRate'),
                  onPressed: () => _blePlugin.queryPastHeartRate),
              ElevatedButton(
                  child: const Text('queryTrainingHeartRate'),
                  onPressed: () => _blePlugin.queryTrainingHeartRate),
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
