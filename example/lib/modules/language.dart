import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

class LanguagePage extends StatefulWidget {
  MoYoungBle blePlugin;

  LanguagePage({Key? key, required this.blePlugin}) : super(key: key);

  @override
  State<LanguagePage> createState() {
    return _languagePage(blePlugin);
  }
}

class _languagePage extends State<LanguagePage> {
  final MoYoungBle _blePlugin;

  _languagePage(this._blePlugin);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("LanguagePage"),
            ),
            body: Center(child: ListView(children: [
              ElevatedButton(
                  child: const Text('sendDeviceLanguage()'),
                  onPressed: () => _blePlugin.sendDeviceLanguage(DeviceLanguageType.LANGUAGE_CHINESE)),
              ElevatedButton(
                  child: const Text('queryDeviceLanguage()'),
                  onPressed: () => _blePlugin.queryDeviceLanguage),
            ])
            )
        )
    );
  }
}
