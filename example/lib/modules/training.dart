import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

class TrainingPage extends StatefulWidget {
  MoYoungBle blePlugin;

  TrainingPage({
    Key? key,
    required this.blePlugin,
  }) : super(key: key);

  @override
  State<TrainingPage> createState() {
    return _trainingPage(blePlugin);
  }
}

class _trainingPage extends State<TrainingPage> {
  final MoYoungBle _blePlugin;

  _trainingPage(this._blePlugin);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("TrainingPage"),
            ),
            body: Center(child: ListView(children: <Widget>[
              ElevatedButton(
                  onPressed: () => _blePlugin.queryHistoryTraining,
                  child: const Text("queryHistoryTraining()")),
              ElevatedButton(
                  onPressed: () => _blePlugin.queryTraining(1),
                  child: const Text("queryTraining()")),
            ])
            )
        )
    );
  }
}
