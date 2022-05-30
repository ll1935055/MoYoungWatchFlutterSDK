import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

class FindWatchPage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const FindWatchPage({Key? key, required this.blePlugin}) : super(key: key);

  @override
  State<FindWatchPage> createState() {
    return _FindWatchPage(blePlugin);
  }
}

class _FindWatchPage extends State<FindWatchPage> {
  final MoYoungBle _blePlugin;

  _FindWatchPage(this._blePlugin);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("Find Watch Page"),
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
