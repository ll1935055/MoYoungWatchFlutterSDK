import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

class HandWashingReminderPage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const HandWashingReminderPage({
    Key? key,
    required this.blePlugin,
  }) : super(key: key);

  @override
  State<HandWashingReminderPage> createState() {
    return _HandWashingReminderPage(blePlugin);
  }
}

class _HandWashingReminderPage extends State<HandWashingReminderPage> {
  final MoYoungBle _blePlugin;
  HandWashingPeriodBean? _handWashingPeriodBean;
  bool enable = false;
  int startHour = -1;
  int startMinute = -1;
  int count = -1;
  int period = -1;

  _HandWashingReminderPage(this._blePlugin);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("Hand Washing Reminder Page"),
            ),
            body: Center(child: ListView(children: <Widget>[
              Text("enable: $enable"),
              Text("startHour: $startHour"),
              Text("startMinute: $startMinute"),
              Text("count: $count"),
              Text("period: $period"),

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
                  onPressed: () => setState(() async {
                    _handWashingPeriodBean = await _blePlugin.queryHandWashingReminderPeriod;
                    enable = _handWashingPeriodBean!.enable;
                    startHour = _handWashingPeriodBean!.startHour;
                    startMinute = _handWashingPeriodBean!.startMinute;
                    count = _handWashingPeriodBean!.count;
                    period = _handWashingPeriodBean!.period;
                  }),
                  child: const Text("queryHandWashingReminderPeriod()")),
            ])
            )
        )
    );
  }
}
