import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

class MenstrualCyclePage extends StatefulWidget {
  MoYoungBle blePlugin;

  MenstrualCyclePage({
    Key? key,
    required this.blePlugin,
  }) : super(key: key);

  @override
  State<MenstrualCyclePage> createState() {
    return _menstrualCyclePage(blePlugin);
  }
}

class _menstrualCyclePage extends State<MenstrualCyclePage> {
  final MoYoungBle _blePlugin;

  _menstrualCyclePage(this._blePlugin);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("MenstrualCyclePage"),
            ),
            body: Center(
                child: ListView(
                    children: <Widget>[
                      ElevatedButton(
                          onPressed: () =>
                              _blePlugin.sendMenstrualCycle(PhysiologcalPeriodBean(
                                  physiologcalPeriod: 1,
                                  menstrualPeriod: 1,
                                  startDate: DateTime.now().microsecondsSinceEpoch.toString(),
                                  menstrualReminder: true,
                                  ovulationReminder: true,
                                  ovulationDayReminder: true,
                                  ovulationEndReminder: true,
                                  reminderHour: 1,
                                  reminderMinute: 1
                              )),
                          child: const Text("sendMenstrualCycle()")),
                      ElevatedButton(
                          onPressed: () => _blePlugin.queryMenstrualCycle,
                          child: const Text("queryMenstrualCycle()")),
                    ])
            )
        )
    );
  }
}