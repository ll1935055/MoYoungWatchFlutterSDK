import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

class System extends StatefulWidget {
  MoYoungBle blePlugin;

  System({
    Key? key,
    required this.blePlugin,
  }) : super(key: key);

  @override
  State<System> createState() {
    return _System(blePlugin);
  }
}

class _System extends State<System> {
  final MoYoungBle _blePlugin;

  _System(this._blePlugin);

  String _firmwareVersion = "未获取";
  String _newFirmwareInfo = "未获取";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("系统"),
            ),
            body: Center(
              child: ListView(
                      children: <Widget>[
                        ElevatedButton(
                            child: const Text('syncTime()'),
                            onPressed: () => _blePlugin.syncTime),
                        ElevatedButton(
                            child: const Text('sendTimeSystem(TIME_SYSTEM_12)'),
                            onPressed: () => _blePlugin
                                .sendTimeSystem(TimeSystemType.TIME_SYSTEM_12)),
                        ElevatedButton(
                            child: const Text('sendTimeSystem(TIME_SYSTEM_24)'),
                            onPressed: () => _blePlugin
                                .sendTimeSystem(TimeSystemType.TIME_SYSTEM_24)),
                        ElevatedButton(
                            child: const Text('queryTimeSystem()'),
                            onPressed: () => _blePlugin.queryTimeSystem),
                        ElevatedButton(
                            child: Text(_firmwareVersion),
                            onPressed: queryFrimwareVersion),
                        ElevatedButton(
                            child: Text(_newFirmwareInfo),
                            onPressed: ()=>checkFirmwareVersion(_firmwareVersion,OTAType.NORMAL_UPGEADE_TYPE)),
                        ElevatedButton(
                            child: const Text('queryMetricSystem()'),
                            onPressed: () => _blePlugin.queryMetricSystem),
                        ElevatedButton(
                            child: const Text('sendMetricSystem(METRIC_SYSTEM)'),
                            onPressed: () => _blePlugin
                                .sendMetricSystem(MetricSystemType.METRIC_SYSTEM)),
                        ElevatedButton(
                            child: const Text('sendMetricSystem(IMPERIAL_SYSTEM)'),
                            onPressed: () => _blePlugin
                                .sendMetricSystem(MetricSystemType.IMPERIAL_SYSTEM)),
                        ElevatedButton(
                            child: const Text('sendDeviceLanguage()'),
                            onPressed: () => _blePlugin.sendDeviceLanguage(
                                DeviceLanguageType.LANGUAGE_CHINESE)),
                        ElevatedButton(
                            child: const Text('queryDeviceLanguage()'),
                            onPressed: () => _blePlugin.queryDeviceLanguage),
                        ElevatedButton(
                            onPressed: () => _blePlugin.sendBrightness(20),
                            child: const Text("sendBrightness()")),
                        ElevatedButton(
                            onPressed: () => _blePlugin.queryBrightness,
                            child: const Text("queryBrightness()")),
                        ElevatedButton(
                            onPressed: () => _blePlugin.sendBatterySaving(true),
                            child: const Text("sendBatterySaving()")),
                        ElevatedButton(
                            onPressed: () => _blePlugin.queryBatterySaving,
                            child: const Text("queryBatterySaving()")),
                        ElevatedButton(
                            child: const Text('shutDown()'),
                            onPressed: () => _blePlugin.shutDown),
                        ElevatedButton(
                            child: const Text('queryDoNotDistrubTime()'),
                            onPressed: () => _blePlugin.queryDoNotDisturbTime),
                        ElevatedButton(
                            child: const Text('sendDoNotDistrubTime()'),
                            onPressed: () => _blePlugin.sendDoNotDisturbTime(
                                PeriodTimeBean(
                                    startHour: 0,
                                    endHour: 1,
                                    startMinute: 0,
                                    endMinute: 0))),
                        ElevatedButton(
                            child: const Text('queryDeviceBattery()'),
                            onPressed: () => _blePlugin.queryDeviceBattery),
                      ],
                    ),
              )));
  }

  Future<void> queryFrimwareVersion() async {
    String firmwareVersion = await _blePlugin.queryFirmwareVersion;
    if (!mounted) return;
    setState(() {
      _firmwareVersion = firmwareVersion;
    });
  }

  Future<void> checkFirmwareVersion(String version,int otaType) async {
    CheckOtaBean versionInfo = await _blePlugin.checkFirmwareVersion(version,otaType);
    if (!mounted) return;
    setState(() {
      _newFirmwareInfo = checkOtaBeanToJson(versionInfo);
    });
  }
}

