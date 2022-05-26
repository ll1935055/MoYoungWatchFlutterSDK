import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

class HandWashingReminderPage extends StatefulWidget {
  MoYoungBle blePlugin;

  HandWashingReminderPage({
    Key? key,
    required this.blePlugin,
  }) : super(key: key);

  @override
  State<HandWashingReminderPage> createState() {
    return _handWashingReminderPage(blePlugin);
  }
}

class _handWashingReminderPage extends State<HandWashingReminderPage> {
  final MoYoungBle _blePlugin;

  _handWashingReminderPage(this._blePlugin);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("HandWashingReminderPage"),
            ),
            body: Center(child: ListView(children: <Widget>[
              ElevatedButton(
                  onPressed: () =>
                      _blePlugin.enableHandWashingReminder(
                          HandWashingPeriodBean(
                            enable: true,
                            startHour: 1,
                            startMinute: 1,
                            count: 1,
                            period: 1,
                          )),
                  child: const Text("enableHandWashingReminder()")),
              ElevatedButton(
                  onPressed: () => _blePlugin.disableHandWashingReminder,
                  child: const Text("disableHandWashingReminder()")),
              ElevatedButton(
                  onPressed: () => _blePlugin.queryHandWashingReminderPeriod,
                  child: const Text("queryHandWashingReminderPeriod()")),
            ])
            )
        )
    );
  }
}
