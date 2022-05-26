import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

class FirmwarePage extends StatefulWidget {
  MoYoungBle blePlugin;
  BleScanBean device;

  FirmwarePage({
    Key? key,
    required this.blePlugin,
    required this.device
  }) : super(key: key);

  @override
  State<FirmwarePage> createState() {
    return _firmwarePage(blePlugin, device);
  }
}

class _firmwarePage extends State<FirmwarePage> {
  final MoYoungBle _blePlugin;
  late BleScanBean device;
  String _firmwareVersion = "queryFirmwareVersion()";
  String _newFirmwareInfo = "checkFirmwareVersion()";
  String oTAType="";

  _firmwarePage(this._blePlugin, this.device);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("FirmwarePage"),
        ),
        body: Center(
            child: ListView(
                children: <Widget>[
                  ElevatedButton(
                      child: Text(_firmwareVersion),
                      onPressed: queryFrimwareVersion),
                  ElevatedButton(
                      child: Text(_newFirmwareInfo),
                      onPressed: ()=>checkFirmwareVersion(_firmwareVersion,OTAType.NORMAL_UPGEADE_TYPE)),
                  ElevatedButton(
                      child: const Text('FirmwareUpgrade(cmu)'),
                      onPressed: () => firmwareUpgrade(checkOtaBeanFromJson(_newFirmwareInfo).firmwareVersionInfo.mcu,device.address)),
                  ElevatedButton(
                      child: const Text('FirmwareUpgradeAbort(cmu)'),
                      onPressed: () => firmwareUpgradeAbort(oTAType)),
                  ElevatedButton(
                      child: const Text('queryDeviceDfuStatus()'),
                      onPressed: () => _blePlugin.queryDeviceDfuStatus),
                  ElevatedButton(
                      child: const Text('queryHsDfuAddress()'),
                      onPressed: () => _blePlugin.queryHsDfuAddress),
                  ElevatedButton(
                      child: const Text('enableHsDfu()'),
                      onPressed: () => _blePlugin.enableHsDfu),
                  ElevatedButton(
                      child: const Text('queryDfuType()'),
                      onPressed: () => _blePlugin.queryDfuType),
                ]
            )
        ),
      ),
    );
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

  Future<void> firmwareUpgrade(int mcu, String address) async {
    switch (mcu) {
      case 4:
      case 8:
      case 9:
        oTAType="OTA_FIRST";
        String hsDfuAdress = await _blePlugin.queryHsDfuAddress;
        await _blePlugin.hsStartOTA(hsDfuAdress);
        break;
      case 7:
      case 11:
      case 71:
      case 72:
        oTAType="OTA_SECOND";
        await _blePlugin.rtStartOTA(address);
        break;
      case 10:
        oTAType="OTA_THIRD";
        await _blePlugin.startOTA(true);
        break;
      default:
        oTAType="OTA_FOUR";
        await _blePlugin.startOTA(false);
        break;
    }
  }

  Future<void> firmwareUpgradeAbort(String oTAType) async {
    switch (oTAType) {
      case "OTA_FIRST":
        await _blePlugin.hsAbortOTA();
        break;
      case "OTA_SECOND":
        await _blePlugin.rtAbortOTA();
        break;
      default:
        await _blePlugin.abortOTA();
        break;
    }
  }
}