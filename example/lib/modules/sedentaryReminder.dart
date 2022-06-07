import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

class SedentaryReminderPage extends StatefulWidget {
   final MoYoungBle blePlugin;

  const SedentaryReminderPage({Key? key, required this.blePlugin}) : super(key: key);

  @override
  State<SedentaryReminderPage> createState() {
    return _SedentaryReminderPage(blePlugin);
  }
}

class _SedentaryReminderPage extends State<SedentaryReminderPage> {
  final MoYoungBle _blePlugin;
  bool _sedentaryReminder = false;
  SedentaryReminderPeriodBean? _reminderPeriodBean;
  int _endHour = -1;
  int _period = -1;
  int _startHour = -1;
  int _steps = -1;

  _SedentaryReminderPage(this._blePlugin);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("Sedentary Reminder"),
            ),
            body: Center(child: ListView(children: [
              Text("sedentaryReminder: $_sedentaryReminder"),
              Text("endHour: $_endHour"),
              Text("period: $_period"),
              Text("startHour: $_startHour"),
              Text("steps: $_steps"),

              ElevatedButton(
                  child: const Text('sendSedentaryReminder(false)'),
                  onPressed: () => _blePlugin.sendSedentaryReminder(false)),
              ElevatedButton(
                  child: const Text('sendSedentaryReminder(true)'),
                  onPressed: () => _blePlugin.sendSedentaryReminder(true)),
              ElevatedButton(
                  child: const Text('querySedentaryReminder()'),
                  onPressed: () async {
                    bool sedentaryReminder = await _blePlugin.querySedentaryReminder;
                    setState(() {
                    _sedentaryReminder = sedentaryReminder;
                  });}),
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
                  onPressed: () async {
                    _reminderPeriodBean = await _blePlugin.querySedentaryReminderPeriod;
                    setState(() {
                    _endHour = _reminderPeriodBean!.endHour;
                    _period = _reminderPeriodBean!.period;
                    _startHour = _reminderPeriodBean!.startHour;
                    _steps = _reminderPeriodBean!.steps;
                  });}),
            ])
            )
        )
    );
  }
}
