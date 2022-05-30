import 'dart:async';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

class MovementTrainingPage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const MovementTrainingPage({
    Key? key,
    required this.blePlugin,
  }) : super(key: key);

  @override
  State<MovementTrainingPage> createState() {
    return _MovementTrainingPage(blePlugin);
  }
}

class _MovementTrainingPage extends State<MovementTrainingPage> {
  final MoYoungBle _blePlugin;
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  Logger logger = Logger();
  int _type = -1;

  _MovementTrainingPage(this._blePlugin);

  @override
  void initState() {
    super.initState();
    subscriptStream();
  }

  void subscriptStream() {
    _streamSubscriptions.add(
      _blePlugin.trainingStateEveStm.listen(
            (int event) {
          setState(() {
            logger.d("trainingStateEveStm======" + event.toString());
            _type = event;
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
              title: const Text("Movement Training Page"),
            ),
            body: Center(child: ListView(children: <Widget>[
              Text("type: $_type"),

              ElevatedButton(
                  onPressed: () => _blePlugin.startTraining(10),
                  child: const Text("startTraining()")),
              ElevatedButton(
                  onPressed: () =>
                      _blePlugin.setTrainingState(
                          TrainingHeartRateStateType.trainingComplete),
                  child: const Text("setMaxHeartRate(-1)")),
              ElevatedButton(
                  onPressed: () =>
                      _blePlugin.setTrainingState(
                          TrainingHeartRateStateType.trainingPause),
                  child: const Text("setMaxHeartRate(-2)")),
              ElevatedButton(
                  onPressed: () =>
                      _blePlugin.setTrainingState(
                          TrainingHeartRateStateType.trainingContinue),
                  child: const Text("setMaxHeartRate(-3)")),
            ])
            )
        )
    );
  }
}
