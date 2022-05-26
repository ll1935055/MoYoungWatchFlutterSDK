import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

class GoalStepsPage extends StatefulWidget {
  MoYoungBle blePlugin;

  GoalStepsPage({Key? key, required this.blePlugin}) : super(key: key);

  @override
  State<GoalStepsPage> createState() {
    return _goalStepPage(blePlugin);
  }
}

class _goalStepPage extends State<GoalStepsPage> {
  final MoYoungBle _blePlugin;

  _goalStepPage(this._blePlugin);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("GoalStepsPage"),
            ),
            body: Center(
                child: ListView(
                    children: [
                      ElevatedButton(
                          child: const Text('sendGoalSteps(5000)'),
                          onPressed: () => _blePlugin.sendGoalSteps(5000)),
                      ElevatedButton(
                          child: const Text('queryGoalStep()'),
                          onPressed: () => _blePlugin.queryGoalSteps),
                    ]
                )
            )
        )
    );
  }
}
