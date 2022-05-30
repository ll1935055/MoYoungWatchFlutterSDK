import 'dart:async';

import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

class FirmwarePage extends StatefulWidget {
  final MoYoungBle blePlugin;
  final BleScanBean device;

  const FirmwarePage({Key? key, required this.blePlugin, required this.device})
      : super(key: key);

  @override
  State<FirmwarePage> createState() {
    return _FirmwarePage(blePlugin, device);
  }
}

class _FirmwarePage extends State<FirmwarePage> {
  final MoYoungBle _blePlugin;
  late BleScanBean device;
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  String _firmwareVersion = "queryFirmwareVersion()";
  String _newFirmwareInfo = "checkFirmwareVersion()";
  int? oTAType;
  int error = -1;
  String errorContent = "";
  int otaProgressInt = -1;
  double otaProgressFloat = 0;
  String _hsOtaAddress="";

  _FirmwarePage(this._blePlugin, this.device);

  @override
  void initState() {
    super.initState();
    subscriptStream();
  }

  void subscriptStream() {
    _streamSubscriptions.add(
      _blePlugin.firmwareUpgradeEveStm.listen(
        (FirmwareUpgradeBean event) {
          setState(() {
            error = event.error;
            errorContent = event.errorContent;
            otaProgressInt = event.otaProgressInt;
            otaProgressFloat = event.otaProgressFloat;
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
          title: const Text("Firmware Page"),
        ),
        body: Center(
            child: ListView(children: <Widget>[
          Text("error: $error"),
          Text("errorContent: $errorContent"),
          Text("otaProgressInt: $otaProgressInt"),
          Text("otaProgressFloat: $otaProgressFloat"),
          ElevatedButton(
              child: Text(_firmwareVersion), onPressed: queryFirmwareVersion),
          ElevatedButton(
              child: Text(_newFirmwareInfo),
              onPressed: () => checkFirmwareVersion(
                  _firmwareVersion, OTAType.normalUpgradeType)),
          ElevatedButton(
              child: const Text('FirmwareUpgrade(mcu)'),
              onPressed: () => startOTA(
                  checkFirmwareVersionBeanFromJson(_newFirmwareInfo).isLatestVersion!?-1:checkFirmwareVersionBeanFromJson(_newFirmwareInfo)
                      .firmwareVersionInfo!
                      .mcu!,
                  device.address)),
              ElevatedButton(
              child: const Text('FirmwareUpgrade-first()'),
              onPressed: () => startOTA(
                  checkFirmwareVersionBeanFromJson(_newFirmwareInfo).isLatestVersion!?-1:checkFirmwareVersionBeanFromJson(_newFirmwareInfo)
                      .firmwareVersionInfo!
                      .mcu!,
                  _hsOtaAddress)),
          Text("oTAType:"+oTAType.toString()),
          ElevatedButton(
              child: const Text('abortOTA(oTAType)'),
              onPressed: () => _blePlugin.abortOTA(oTAType!)),
          ElevatedButton(
              child: const Text('queryDeviceOtaStatus()'),
              onPressed: () => _blePlugin.queryDeviceOtaStatus),
          ElevatedButton(
              child: const Text('queryHsOtaAddress()'),
              onPressed: () async => _hsOtaAddress = await _blePlugin.queryHsOtaAddress),
          ElevatedButton(
              child: const Text('enableHsOta()'),
              onPressed: () => _blePlugin.enableHsOta),
          ElevatedButton(
              child: const Text('queryOtaType()'),
              onPressed: () => _blePlugin.queryOtaType),
        ])),
      ),
    );
  }

  Future<void> queryFirmwareVersion() async {
    String firmwareVersion = await _blePlugin.queryFirmwareVersion;
    if (!mounted) {
      return;
    }
    setState(() {
      _firmwareVersion = firmwareVersion;
    });
  }

  Future<void> checkFirmwareVersion(String version, int oTAType) async {
    CheckFirmwareVersionBean versionInfo =
        await _blePlugin.checkFirmwareVersion(version, oTAType);
    if (!mounted) {
      return;
    }
    setState(() {
      _newFirmwareInfo = checkFirmwareVersionBeanToJson(versionInfo);
    });
  }

  Future<void> startOTA(int? mcu, String address) async {
    switch (mcu) {
      case 4:
      case 8:
      case 9:
        oTAType = OTAMcuType.otaFirst;
        await _blePlugin
            .startOTA(OtaBean(address: address, type: OTAMcuType.otaFirst));
        break;
      case 7:
      case 11:
      case 71:
      case 72:
        oTAType = OTAMcuType.otaSecond;
        await _blePlugin
            .startOTA(OtaBean(address: address, type: OTAMcuType.otaSecond));
        break;
      case 10:
        oTAType = OTAMcuType.otaThird;
        await _blePlugin
            .startOTA(OtaBean(address: address, type: OTAMcuType.otaThird));
        break;
      default:
        oTAType = OTAMcuType.otaFour;
        await _blePlugin
            .startOTA(OtaBean(address: address, type: OTAMcuType.otaFour));
        break;
    }
  }
}
