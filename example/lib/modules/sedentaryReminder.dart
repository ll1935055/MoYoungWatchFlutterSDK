import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

class SedentaryReminderPage extends StatefulWidget {
  MoYoungBle blePlugin;

  SedentaryReminderPage({Key? key, required this.blePlugin}) : super(key: key);

  @override
  State<SedentaryReminderPage> createState() {
    return _sedentaryReminderPage(blePlugin);
  }
}

class _sedentaryReminderPage extends State<SedentaryReminderPage> {
  final MoYoungBle _blePlugin;

  _sedentaryReminderPage(this._blePlugin);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("SedentaryReminderPage"),
            ),
            body: Center(child: ListView(children: [
              ElevatedButton(
                  child: const Text('sendSedentaryReminder(false)'),
                  onPressed: () => _blePlugin.sendSedentaryReminder(false)),
              ElevatedButton(
                  child: const Text('sendSedentaryReminder(true)'),
                  onPressed: () => _blePlugin.sendSedentaryReminder(true)),
              ElevatedButton(
                  child: const Text('querySedentaryReminder()'),
                  onPressed: () => _blePlugin.querySedentaryReminder),
              ElevatedButton(
                  child: const Text('sendSedentaryReminderPeriod()'),
                  onPressed: () => _blePlugin.sendSedentaryReminderPeriod(
                      SedentaryReminderPeriodBean(
                          startHour: 10,
                          endHour: 20,
                          period: 30,
                          steps: 40
                      ))),
              ElevatedButton(
                  child: const Text('querySedentaryReminderPeriod()'),
                  onPressed: () => _blePlugin.querySedentaryReminderPeriod),
            ])
            )
        )
    );
  }
}
