import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

class PillReminderPage extends StatefulWidget {
  MoYoungBle blePlugin;

  PillReminderPage({
    Key? key,
    required this.blePlugin,
  }) : super(key: key);

  @override
  State<PillReminderPage> createState() {
    return _pillReminderPage(blePlugin);
  }
}

class _pillReminderPage extends State<PillReminderPage> {
  final MoYoungBle _blePlugin;

  _pillReminderPage(this._blePlugin);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("PillReminderPage"),
            ),
            body: Center(child: ListView(children: <Widget>[
              ElevatedButton(
                  onPressed: () => _blePlugin.queryPillReminder,
                  child: const Text("queryPillReminder()")),
              ElevatedButton(
                  onPressed: () =>
                      _blePlugin.sendPillReminder(PillReminderBean(
                          id: 1,
                          dateOffset: 1,
                          name: "name",
                          repeat: 1,
                          reminderTimeList: []
                      )),
                  child: const Text("sendPillReminder()")),
              ElevatedButton(
                  onPressed: () => _blePlugin.deletePillReminder(1),
                  child: const Text("deletePillReminder(1)")),
              ElevatedButton(
                  onPressed: () => _blePlugin.clearPillReminder,
                  child: const Text("clearPillReminder()")),
            ])
            )
        )
    );
  }
}
