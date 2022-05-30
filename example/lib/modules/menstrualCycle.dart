import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

class MenstrualCyclePage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const MenstrualCyclePage({
    Key? key,
    required this.blePlugin,
  }) : super(key: key);

  @override
  State<MenstrualCyclePage> createState() {
    return _MenstrualCyclePage(blePlugin);
  }
}

class _MenstrualCyclePage extends State<MenstrualCyclePage> {
  final MoYoungBle _blePlugin;
  MenstrualCycleBean? _menstrualCycleBean;
  int physiologcalPeriod = -1;
  int menstrualPeriod = -1;
  String startDate = "";
  bool menstrualReminder = false;
  bool ovulationReminder = false;
  bool ovulationDayReminder = false;
  bool ovulationEndReminder = false;
  int reminderHour = -1;
  int reminderMinute = -1;

  _MenstrualCyclePage(this._blePlugin);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("Menstrual Cycle Page"),
            ),
            body: Center(
                child: ListView(
                    children: <Widget>[
                      Text("physiologcalPeriod: $physiologcalPeriod"),
                      Text("menstrualPeriod: $menstrualPeriod"),
                      Text("startDate: $startDate"),
                      Text("menstrualReminder: $menstrualReminder"),
                      Text("ovulationReminder: $ovulationReminder"),
                      Text("ovulationDayReminder: $ovulationDayReminder"),
                      Text("ovulationEndReminder: $ovulationEndReminder"),
                      Text("reminderHour: $reminderHour"),
                      Text("reminderMinute: $reminderMinute"),

                      ElevatedButton(
                          onPressed: () =>
                              _blePlugin.sendMenstrualCycle(MenstrualCycleBean(
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
                          onPressed: () => setState(() async {
                            _menstrualCycleBean = await _blePlugin.queryMenstrualCycle;
                            menstrualPeriod = _menstrualCycleBean!.menstrualPeriod;
                            startDate = _menstrualCycleBean!.startDate;
                            menstrualReminder = _menstrualCycleBean!.menstrualReminder;
                            ovulationReminder = _menstrualCycleBean!.ovulationReminder;
                            ovulationDayReminder = _menstrualCycleBean!.ovulationDayReminder;
                            ovulationEndReminder = _menstrualCycleBean!.ovulationEndReminder;
                            reminderHour = _menstrualCycleBean!.reminderHour;
                            reminderMinute = _menstrualCycleBean!.reminderMinute;
                          }),
                          child: const Text("queryMenstrualCycle()")),
                    ])
            )
        )
    );
  }
}