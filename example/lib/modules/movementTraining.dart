import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

class MovementTrainingPage extends StatefulWidget {
  MoYoungBle blePlugin;

  MovementTrainingPage({
    Key? key,
    required this.blePlugin,
  }) : super(key: key);

  @override
  State<MovementTrainingPage> createState() {
    return _movementTrainingPage(blePlugin);
  }
}

class _movementTrainingPage extends State<MovementTrainingPage> {
  final MoYoungBle _blePlugin;

  _movementTrainingPage(this._blePlugin);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("MovementTrainingPage"),
            ),
            body: Center(child: ListView(children: <Widget>[
              ElevatedButton(
                  onPressed: () => _blePlugin.startMovement(10),
                  child: const Text("startMovement()")),
              ElevatedButton(
                  onPressed: () =>
                      _blePlugin.setMovementState(
                          MovementHeartRateStateType.MOVEMENT_COMPLETE),
                  child: const Text("setMaxHeartRate(-1)")),
              ElevatedButton(
                  onPressed: () =>
                      _blePlugin.setMovementState(
                          MovementHeartRateStateType.MOVEMENT_CONTINUE),
                  child: const Text("setMaxHeartRate(-2)")),
              ElevatedButton(
                  onPressed: () =>
                      _blePlugin.setMovementState(
                          MovementHeartRateStateType.MOVEMENT_PAUSE),
                  child: const Text("setMaxHeartRate(-3)")),
            ])
            )
        )
    );
  }
}
