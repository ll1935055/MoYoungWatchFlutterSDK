import 'dart:async';

import 'package:flutter/material.dart';

import 'package:logger/logger.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

class TakePhotoPage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const TakePhotoPage({
    Key? key,
    required this.blePlugin,
  }) : super(key: key);

  @override
  State<TakePhotoPage> createState() {
    return _TakePhotoPage(blePlugin);
  }
}

class _TakePhotoPage extends State<TakePhotoPage> {
  final MoYoungBle _blePlugin;
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  Logger logger = Logger();
  String _camera = "";
  int _phone = -1;

  _TakePhotoPage(this._blePlugin);

  @override
  void initState() {
    super.initState();
    subscriptStream();
  }

  void subscriptStream() {
    _streamSubscriptions.add(
      _blePlugin.cameraEveStm.listen(
            (String event) {
          setState(() {
            logger.d('connCameraEveStm');
            _camera = event;
          });
        },
      ),
    );

    _streamSubscriptions.add(
      _blePlugin.phoneEveStm.listen(
            (int event) {
          setState(() {
            logger.d('connPhoneEveStm===' + event.toString());
            _phone = event;
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
              title: const Text("Take Photo Page"),
            ),
            body: Center(child: ListView(children: <Widget>[
              Text("camera: $_camera"),
              Text("phone: $_phone"),

              ElevatedButton(
                  child: const Text('enterCameraView'),
                  onPressed: () => _blePlugin.enterCameraView),
              ElevatedButton(
                  child: const Text('exitCameraView'),
                  onPressed: () => _blePlugin.exitCameraView),
            ])
            )
        )
    );
  }
}
