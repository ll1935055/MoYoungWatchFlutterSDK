import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';
import 'package:logger/logger.dart';
import 'dart:async';

class StepsPage extends StatefulWidget {
  MoYoungBle blePlugin;

  StepsPage({
    Key? key,
    required this.blePlugin
  }) : super(key: key);

  @override
  State<StepsPage> createState() {
    return _stepsPage(blePlugin);
  }
}

class _stepsPage extends State<StepsPage> {
  final MoYoungBle _blePlugin;
  Logger logger = Logger();
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  int _stepChange = -1;

  _stepsPage(this._blePlugin);

  @override
  void initState() {
    super.initState();
    subscriptStream();
  }

  void subscriptStream() {
    _streamSubscriptions.add(
      _blePlugin.stepsChangeEveStm.listen(
            (StepChangeBean event) {
          setState(() {
            _stepChange = event.stepInfo.steps;
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
              title: const Text("StepsPage"),
            ),
            body: Center(
              child: ListView(
                children: [
                  Text("StepsChange=" + _stepChange.toString()),

                  ElevatedButton(
                      child: const Text('syncStep'),
                      onPressed: () => _blePlugin.syncSteps),
                  ElevatedButton(
                      child: const Text('syncPastStep(YESTERDAY_STEPS)'),
                      onPressed: () => _blePlugin.syncHistorySteps(StepsCategoryDateType.TODAY_STEPS_CATEGORY)),
                  ElevatedButton(
                      child: const Text('queryStepsCategory(CRPStepsCategoryDateType)'),
                      onPressed: () => _blePlugin.queryStepsCategory(StepsCategoryDateType.TODAY_STEPS_CATEGORY)),
                ],
              ),
            )
        )
    );
  }
}
