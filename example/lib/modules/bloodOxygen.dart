import 'dart:async';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

class BloodOxygenPage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const BloodOxygenPage({
    Key? key,
    required this.blePlugin,
  }) : super(key: key);

  @override
  State<BloodOxygenPage> createState() {
    return _BloodOxygenPage(blePlugin);
  }
}

class _BloodOxygenPage extends State<BloodOxygenPage> {
  final MoYoungBle _blePlugin;
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  Logger logger = Logger();
  bool _continueState = false;
  int _timingMeasure = -1;
  int _bloodOxygen = -1;
  List<HistoryBloodOxygenBean> _historyList = [];
  BloodOxygenInfo? _continueBo;
  int startTime = -1;
  int timeInterval = -1;
  int type = 0;

  _BloodOxygenPage(this._blePlugin);

  @override
  void initState() {
    super.initState();
    subscriptStream();
  }

  void subscriptStream() {
    _streamSubscriptions.add(
      _blePlugin.bloodOxygenEveStm.listen(
            (BloodOxygenBean event) {
          setState(() {
            logger.d('connBloodOxygenEveStm:' + event.toString());
            type = event.type;
            print("type：" + type.toString());
            switch(type){
              case 1:_continueState = event.continueState!;break;
              case 2:_timingMeasure = event.timingMeasure!;break;
              case 3:_bloodOxygen = event.bloodOxygen!;break;
              case 4:_historyList = event.historyList!;break;
              case 5:_continueBo = event.continueBo!;
                     startTime = _continueBo!.startTime!;
                     timeInterval = _continueBo!.timeInterval!;
                     break;
            }
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("Blood Oxygen Page"),
            ),
            body: Center(child: ListView(children: <Widget>[
              Text("continueState: $_continueState"),
              Text("timingMeasure: $_timingMeasure"),
              Text("bloodOxygen: $_bloodOxygen"),
              Text("historyList: $_historyList"),
              Text("startTime: $startTime"),
              Text("timeInterval: $timeInterval"),

              ElevatedButton(
                  child: const Text('startMeasureBloodOxygen'),
                  onPressed: () => _blePlugin.startMeasureBloodOxygen),
              ElevatedButton(
                  child: const Text('stopMeasureBloodOxygen'),
                  onPressed: () => _blePlugin.stopMeasureBloodOxygen),
              ElevatedButton(
                  child: const Text('enableTimingMeasureBloodOxygen(1)'),
                  onPressed: () =>
                      _blePlugin.enableTimingMeasureBloodOxygen(1)),
              ElevatedButton(
                  child: const Text('disableTimingMeasureBloodOxygen'),
                  onPressed: () => _blePlugin.disableTimingMeasureBloodOxygen),
              ElevatedButton(
                  child: const Text('queryTimingBloodOxygenMeasureState'),
                  onPressed: () =>
                  _blePlugin.queryTimingBloodOxygenMeasureState),
              ElevatedButton(
                  child: const Text('queryTimingBloodOxygen(CRPBloodOxygenTimeType)'),
                  onPressed: () => _blePlugin.queryTimingBloodOxygen(BloodOxygenTimeType.today)),
              ElevatedButton(
                  child: const Text('queryTimingBloodOxygen(CRPBloodOxygenTimeType)'),
                  onPressed: () => _blePlugin.queryTimingBloodOxygen(BloodOxygenTimeType.yesterday)),
              ElevatedButton(
                  child: const Text('enableContinueBloodOxygen'),
                  onPressed: () => _blePlugin.enableContinueBloodOxygen),
              ElevatedButton(
                  child: const Text('disableContinueBloodOxygen'),
                  onPressed: () => _blePlugin.disableContinueBloodOxygen),
              ElevatedButton(
                  child: const Text('queryContinueBloodOxygenState'),
                  onPressed: () => _blePlugin.queryContinueBloodOxygenState),
              ElevatedButton(
                  child: const Text('queryLast24HourBloodOxygen'),
                  onPressed: () => _blePlugin.queryLast24HourBloodOxygen),
              ElevatedButton(
                  child: const Text('queryHistoryBloodOxygen'),
                  onPressed: () => _blePlugin.queryHistoryBloodOxygen),
            ])
            )
        )
    );
  }
}
