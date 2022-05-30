import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';
import 'dart:async';

class StepsPage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const StepsPage({
    Key? key,
    required this.blePlugin
  }) : super(key: key);

  @override
  State<StepsPage> createState() {
    return _StepsPage(blePlugin);
  }
}

class _StepsPage extends State<StepsPage> {
  final MoYoungBle _blePlugin;
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  int _stepsChange = -1;

  _StepsPage(this._blePlugin);

  @override
  void initState() {
    super.initState();
    subscriptStream();
  }

  void subscriptStream() {
    _streamSubscriptions.add(
      _blePlugin.stepsChangeEveStm.listen(
            (StepsChangeBean event) {
          setState(() {
            _stepsChange = event.stepsInfo.steps;
          });
        },
      ),
    );

    _streamSubscriptions.add(
      _blePlugin.stepsDetailEveStm.listen(
            (StepsDetailBean event) {
          setState(() {

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
              title: const Text("Steps Page"),
            ),
            body: Center(
              child: ListView(
                children: [
                  Text("StepsChange=" + _stepsChange.toString()),

                  ElevatedButton(
                      child: const Text('querySteps'),
                      onPressed: () => _blePlugin.querySteps),
                  ElevatedButton(
                      child: const Text('queryHistorySteps(todayStepsDetail)'),
                      onPressed: () => _blePlugin.queryHistorySteps(StepsDetailDateType.todayStepsDetail)),
                  ElevatedButton(
                      child: const Text('queryHistorySteps(todayStepsDetail)'),
                      onPressed: () => _blePlugin.queryStepsDetail(StepsDetailDateType.todayStepsDetail)),
                ],
              ),
            )
        )
    );
  }
}
