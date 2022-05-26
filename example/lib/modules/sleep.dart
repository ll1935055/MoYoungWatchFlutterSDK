import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

class SleepPage extends StatefulWidget {
  MoYoungBle blePlugin;

  SleepPage({Key? key, required this.blePlugin}) : super(key: key);

  @override
  State<SleepPage> createState() {
    return _sleepPage(blePlugin);
  }
}

class _sleepPage extends State<SleepPage> {
  final MoYoungBle _blePlugin;

  _sleepPage(this._blePlugin);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("SleepPage"),
            ),
            body: Center(
              child: ListView(
                children: [
                  ElevatedButton(
                      child: const Text('syncSleep'),
                      onPressed: () => _blePlugin.syncSleep),
                  ElevatedButton(
                      child: const Text('syncRemSleep'),
                      onPressed: () => _blePlugin.syncRemSleep),
                  ElevatedButton(
                      child: const Text('syncPastSleep(YESTERDAY_STEPS)'),
                      onPressed: () => _blePlugin.syncHistorySleep(PastTimeType.YESTERDAY_STEPS)),
                  ElevatedButton(
                      child: const Text('syncPastSleep(DAY_BEFORE_YESTERDAY_STEPS)'),
                      onPressed: () => _blePlugin.syncHistorySleep(PastTimeType.DAY_BEFORE_YESTERDAY_STEPS)),
                  ElevatedButton(
                      child: const Text('syncPastSleep(YESTERDAY_SLEEP)'),
                      onPressed: () => _blePlugin.syncHistorySleep(PastTimeType.YESTERDAY_SLEEP)),
                  ElevatedButton(
                      child: const Text('syncPastSleep(DAY_BEFORE_YESTERDAY_SLEEP)'),
                      onPressed: () => _blePlugin.syncHistorySleep(PastTimeType.DAY_BEFORE_YESTERDAY_SLEEP)),
                ],
              ),
            )
        )
    );
  }
}
