import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

class QuickViewPage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const QuickViewPage({Key? key, required this.blePlugin}) : super(key: key);

  @override
  State<QuickViewPage> createState() {
    return _QuickViewPage(blePlugin);
  }
}

class _QuickViewPage extends State<QuickViewPage> {
  final MoYoungBle _blePlugin;
  bool _quickViewState = false;
  PeriodTimeResultBean? _periodTimeResultBean;
  int _periodTimeType = -1;
  PeriodTimeInfo? _periodTimeInfo;
  int _endHour = -1;
  int _endMinute = -1;
  int _startHour = -1;
  int _startMinute = -1;

  _QuickViewPage(this._blePlugin);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("Quick View Page"),
            ),
            body: Center(
              child: ListView(
                children: [
                  Text("quickViewState: $_quickViewState"),
                  Text("periodTimeType: $_periodTimeType"),
                  Text("startHour: $_startHour"),
                  Text("startMinute: $_startMinute"),
                  Text("endHour: $_endHour"),
                  Text("endMinute: $_endMinute"),

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
                      onPressed: () => setState(() async {
                        _periodTimeResultBean = await _blePlugin.queryQuickViewTime;
                        _periodTimeType = _periodTimeResultBean!.periodTimeType;
                        _periodTimeInfo = _periodTimeResultBean!.periodTimeInfo;
                        _endHour = _periodTimeInfo!.endHour;
                        _endMinute = _periodTimeInfo!.endMinute;
                        _startHour = _periodTimeInfo!.startHour;
                        _startMinute = _periodTimeInfo!.startMinute;
                      })),
                ],
              ),
            )
        )
    );
  }
}
