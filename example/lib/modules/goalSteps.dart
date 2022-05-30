import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

class GoalStepsPage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const GoalStepsPage({Key? key, required this.blePlugin}) : super(key: key);

  @override
  State<GoalStepsPage> createState() {
    return _GoalStepPage(blePlugin);
  }
}

class _GoalStepPage extends State<GoalStepsPage> {
  final MoYoungBle _blePlugin;
  int _goalSteps = -1;

  _GoalStepPage(this._blePlugin);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("Goal Steps Page"),
            ),
            body: Center(
                child: ListView(
                    children: [
                      Text("goalSteps: $_goalSteps"),

                      ElevatedButton(
                          child: const Text('sendGoalSteps(5000)'),
                          onPressed: () => _blePlugin.sendGoalSteps(5000)),
                      ElevatedButton(
                          child: const Text('queryGoalStep()'),
                          onPressed: () => setState(() async {
                            _goalSteps = await _blePlugin.queryGoalSteps;
                          })),
                    ]
                )
            )
        )
    );
  }
}
