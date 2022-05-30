import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

class DisplayTimePage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const DisplayTimePage({
    Key? key,
    required this.blePlugin,
  }) : super(key: key);

  @override
  State<DisplayTimePage> createState() {
    return _DisplayTimePage(blePlugin);
  }
}

class _DisplayTimePage extends State<DisplayTimePage> {
  final MoYoungBle _blePlugin;
  int _time = -1;

  _DisplayTimePage(this._blePlugin);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("Display Time Page"),
            ),
            body: Center(child: ListView(children: <Widget>[
              Text("time: $_time"),

              ElevatedButton(
                  onPressed: () => _blePlugin.sendDisplayTime(DisplayTimeType.displayFive),
                  child: const Text("sendDisplayTime()")),
              ElevatedButton(
                  onPressed: () => setState(() async {
                    _time = await _blePlugin.queryDisplayTime;
                  }),
                  child: const Text("queryDisplayTime()")),
            ])
            )
        )
    );
  }
}
