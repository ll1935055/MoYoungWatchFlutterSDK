import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

class BrightnessPage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const BrightnessPage({
    Key? key,
    required this.blePlugin,
  }) : super(key: key);

  @override
  State<BrightnessPage> createState() {
    return _BrightnessPage(blePlugin);
  }
}

class _BrightnessPage extends State<BrightnessPage> {
  final MoYoungBle _blePlugin;
  BrightnessBean? _brightnessBean;
  int _current = -1;
  int _max = -1;

  _BrightnessPage(this._blePlugin);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("Brightness"),
            ),
            body: Center(child: ListView(children: <Widget>[
              Text("current: $_current"),
              Text("max: $_max"),

              ElevatedButton(
                  onPressed: () => _blePlugin.sendBrightness(5),
                  child: const Text("sendBrightness(5)")),
              ElevatedButton(
                  onPressed: () async {
                    _brightnessBean = await _blePlugin.queryBrightness;
                    setState(() {
                    _current = _brightnessBean!.current;
                    _max = _brightnessBean!.max;
                  });},
                  child: const Text("queryBrightness()")),
            ])
            )
        )
    );
  }
}
