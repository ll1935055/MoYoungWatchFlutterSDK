import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

class QuickViewPage extends StatefulWidget {
  MoYoungBle blePlugin;

  QuickViewPage({Key? key, required this.blePlugin}) : super(key: key);

  @override
  State<QuickViewPage> createState() {
    return _quickViewPage(blePlugin);
  }
}

class _quickViewPage extends State<QuickViewPage> {
  final MoYoungBle _blePlugin;

  _quickViewPage(this._blePlugin);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("QuickViewPage"),
            ),
            body: Center(
              child: ListView(
                children: [
                  ElevatedButton(
                      child: const Text('sendQuickView(true)'),
                      onPressed: () => _blePlugin.sendQuickView(true)),
                  ElevatedButton(
                      child: const Text('sendQuickView(false)'),
                      onPressed: () => _blePlugin.sendQuickView(false)),
                  ElevatedButton(
                      child: const Text('queryQuickView()'),
                      onPressed: () => _blePlugin.queryQuickView),
                  ElevatedButton(
                      child: const Text(
                          'sendQuickViewTime(CrpPeriodTimeInfo(0,0,0,0)'),
                      onPressed: () => _blePlugin.sendQuickViewTime(
                          PeriodTimeBean(
                              endHour: 0,
                              endMinute: 0,
                              startHour: 0,
                              startMinute: 0))),
                  ElevatedButton(
                      child: const Text('queryQuickViewTime()'),
                      onPressed: () => _blePlugin.queryQuickViewTime),
                ],
              ),
            )
        )
    );
  }
}
