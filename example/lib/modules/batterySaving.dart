import 'dart:async';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

class BatterySavingPage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const BatterySavingPage({
    Key? key,
    required this.blePlugin,
  }) : super(key: key);

  @override
  State<BatterySavingPage> createState() {
    return _BatterySavingPage(blePlugin);
  }
}

class _BatterySavingPage extends State<BatterySavingPage> {
  final MoYoungBle _blePlugin;
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  bool _batterSaving = false;
  Logger logger = Logger();

  _BatterySavingPage(this._blePlugin);

  @override
  void initState() {
    super.initState();
    subscriptStream();
  }

  void subscriptStream() {
    _streamSubscriptions.add(
      _blePlugin.batterySavingEveStm.listen(
            (bool event) {
          setState(() {
            logger.d("BatterySavingEveStm======" + event.toString());
            _batterSaving = event;
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
              title: const Text("Battery Saving"),
            ),
            body: Center(child: ListView(children: <Widget>[
              Text("batterSaving: $_batterSaving"),

              ElevatedButton(
                  onPressed: () => _blePlugin.sendBatterySaving(true),
                  child: const Text("sendBatterySaving(true)")),
              ElevatedButton(
                  onPressed: () => _blePlugin.sendBatterySaving(false),
                  child: const Text("sendBatterySaving(false)")),
              ElevatedButton(
                  onPressed: () => _blePlugin.queryBatterySaving,
                  child: const Text("queryBatterySaving()")),
            ])
            )
        )
    );
  }
}
