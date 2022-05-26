import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

class TakePhotoPage extends StatefulWidget {
  MoYoungBle blePlugin;

  TakePhotoPage({
    Key? key,
    required this.blePlugin,
  }) : super(key: key);

  @override
  State<TakePhotoPage> createState() {
    return _takePhotoPage(blePlugin);
  }
}

class _takePhotoPage extends State<TakePhotoPage> {
  final MoYoungBle _blePlugin;

  _takePhotoPage(this._blePlugin);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("TakePhotoPage"),
            ),
            body: Center(child: ListView(children: <Widget>[
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
