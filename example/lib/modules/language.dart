import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

class LanguagePage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const LanguagePage({Key? key, required this.blePlugin}) : super(key: key);

  @override
  State<LanguagePage> createState() {
    return _LanguagePage(blePlugin);
  }
}

class _LanguagePage extends State<LanguagePage> {
  final MoYoungBle _blePlugin;
  DeviceLanguageBean? deviceLanguageBean;
  List<int> _languageType = [];
  int _type = -1;

  _LanguagePage(this._blePlugin);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("Language Page"),
            ),
            body: Center(child: ListView(children: [
              Text("languageType: $_languageType"),
              Text("type: $_type"),

              ElevatedButton(
                  child: const Text('sendDeviceLanguage()'),
                  onPressed: () => _blePlugin.sendDeviceLanguage(DeviceLanguageType.languageChinese)),
              ElevatedButton(
                  child: const Text('queryDeviceLanguage()'),
                  onPressed: () => setState(() async {
                    deviceLanguageBean = await _blePlugin.queryDeviceLanguage;
                    _languageType = deviceLanguageBean!.languageType;
                    _type = deviceLanguageBean!.type;
                  })),
            ])
            )
        )
    );
  }
}
