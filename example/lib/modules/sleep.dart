import 'dart:async';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

class SleepPage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const SleepPage({Key? key, required this.blePlugin}) : super(key: key);

  @override
  State<SleepPage> createState() {
    return _SleepPage(blePlugin);
  }
}

class _SleepPage extends State<SleepPage> {
  final MoYoungBle _blePlugin;
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  int _totalTime = -1;
  int _restfulTime = -1;
  int _lightTime = -1;
  int _soberTime = -1;
  int _remTime = -1;

  Logger logger = Logger();

  _SleepPage(this._blePlugin);

  @override
  void initState() {
    super.initState();
    subscriptStream();
  }

  void subscriptStream() {
    _streamSubscriptions.add(
      _blePlugin.sleepChangeEveStm.listen(
            (SleepBean event) {
          setState(() {
            _totalTime = event.pastSleepInfo.totalTime;
            _restfulTime = event.pastSleepInfo.restfulTime;
            _lightTime = event.pastSleepInfo.lightTime;
            _soberTime = event.pastSleepInfo.soberTime;
            _remTime = event.pastSleepInfo.remTime;
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
              title: const Text("Sleep Page"),
            ),
            body: Center(
              child: ListView(
                children: [
                  Text("totalTime: $_totalTime"),
                  Text("restfulTime: $_restfulTime"),
                  Text("lightTime: $_lightTime"),
                  Text("soberTime: $_soberTime"),
                  Text("remTime: $_remTime"),

                  ElevatedButton(
                      child: const Text('querySleep'),
                      onPressed: () => _blePlugin.querySleep),
                  ElevatedButton(
                      child: const Text('queryRemSleep'),
                      onPressed: () => _blePlugin.queryRemSleep),
                  ElevatedButton(
                      child: const Text('queryHistorySleep(YESTERDAY_SLEEP)'),
                      onPressed: () => _blePlugin.queryHistorySleep(HistoryTimeType.yesterdaySleep)),
                  ElevatedButton(
                      child: const Text('queryHistorySleep(DAY_BEFORE_YESTERDAY_SLEEP)'),
                      onPressed: () => _blePlugin.queryHistorySleep(HistoryTimeType.dayBeforeYesterdaySleep)),
                ],
              ),
            )
        )
    );
  }
}
