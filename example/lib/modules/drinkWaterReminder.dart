import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

class DrinkWaterReminderPage extends StatefulWidget {
  MoYoungBle blePlugin;

  DrinkWaterReminderPage({
    Key? key,
    required this.blePlugin,
  }) : super(key: key);

  @override
  State<DrinkWaterReminderPage> createState() {
    return _drinkWaterReminderPage(blePlugin);
  }
}

class _drinkWaterReminderPage extends State<DrinkWaterReminderPage> {
  final MoYoungBle _blePlugin;

  _drinkWaterReminderPage(this._blePlugin);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("DrinkWaterReminderPage"),
            ),
            body: Center(child: ListView(children: <Widget>[
              ElevatedButton(
                  onPressed: () =>
                      _blePlugin.enableDrinkWaterReminder(DrinkWaterPeriodBean(
                          enable: true,
                          startHour: 1,
                          startMinute: 1,
                          count: 1,
                          period: 1,
                          currentCups: 1)),
                  child: const Text("enableDrinkWaterReminder()")),
              ElevatedButton(
                  onPressed: () => _blePlugin.disableDrinkWaterReminder,
                  child: const Text("disableDrinkWaterReminder()")),
              ElevatedButton(
                  onPressed: () => _blePlugin.queryDrinkWaterReminderPeriod,
                  child: const Text("queryDrinkWaterReminderPeriod()")),
            ])
            )
        )
    );
  }
}
