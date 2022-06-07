import 'dart:async';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

class RSSIPage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const RSSIPage({
    Key? key,
    required this.blePlugin,
  }) : super(key: key);

  @override
  State<RSSIPage> createState() {
    return _RSSIPage(blePlugin);
  }
}

class _RSSIPage extends State<RSSIPage> {
  final MoYoungBle _blePlugin;
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  Logger logger = Logger();
  int _deviceRssi = -1;

  _RSSIPage(this._blePlugin);

  @override
  void initState() {
    super.initState();
    subscriptStream();
  }

  void subscriptStream() {
    _streamSubscriptions.add(
      _blePlugin.deviceRssiEveStm.listen(
            (int event) {
          setState(() {
            logger.d('connDeviceRssiEveStm===' + event.toString());
            _deviceRssi = event;
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
              title: const Text("RSSI"),
            ),
            body: Center(child: ListView(children: <Widget>[
              Text("deviceRssi: $_deviceRssi"),

              ElevatedButton(
                  child: const Text('readDeviceRssi'),
                  onPressed: () => _blePlugin.readDeviceRssi),
            ])
            )
        )
    );
  }
}
