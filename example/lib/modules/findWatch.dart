import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

class FindWatchPage extends StatefulWidget {
  MoYoungBle blePlugin;

  FindWatchPage({Key? key, required this.blePlugin}) : super(key: key);

  @override
  State<FindWatchPage> createState() {
    return _findWatchPage(blePlugin);
  }
}

class _findWatchPage extends State<FindWatchPage> {
  final MoYoungBle _blePlugin;

  _findWatchPage(this._blePlugin);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("FindWatchPage"),
            ),
            body: Center(child: ListView(children: [
              ElevatedButton(
                  child: const Text('findDevice()'),
                  onPressed: () => _blePlugin.findDevice),
            ])
            )
        )
    );
  }
}
