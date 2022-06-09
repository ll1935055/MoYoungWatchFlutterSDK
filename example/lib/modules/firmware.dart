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
  int? _oTAType;
  UpgradeErrorBean? _upgradeError;
  int _error = -1;
  String _errorContent = "";
  int _upgradeProgress = -1;
  String _hsOtaAddress="";
  int _deviceOtaStatus = -1;
  int _otaType = -1;

  _FirmwarePage(this._blePlugin, this.device);

  @override
  void initState() {
    super.initState();
    subscriptStream();
  }

  void subscriptStream() {
    _streamSubscriptions.add(
      _blePlugin.oTAEveStm.listen(
        (OTABean event) {
          setState(() {
            switch(event.type){
              case OTAProgressType.downloadStart:
                break;
              case OTAProgressType.downloadComplete:
                break;
              case OTAProgressType.progressStart:
                break;
              case OTAProgressType.progressChanged:
                _upgradeProgress = event.upgradeProgress!;
                break;
              case OTAProgressType.upgradeCompleted:
                break;
              case OTAProgressType.upgradeAborted:
                break;
              case OTAProgressType.error:
                _upgradeError = event.upgradeError!;
                _error = _upgradeError!.error!;
                _errorContent = _upgradeError!.errorContent!;
                break;
              default:
                break;
            }
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
          title: const Text("Firmware"),
        ),
        body: Center(
            child: ListView(
                children: <Widget>[
                  Text("upgradeProgress: $_upgradeProgress"),
                  Text("error: $_error"),
                  Text("errorContent: $_errorContent"),
                  Text("deviceOtaStatus: $_deviceOtaStatus"),
                  Text("hsOtaAddress: $_hsOtaAddress"),
                  Text("OtaType: $_otaType"),

                  ElevatedButton(
                      child: Text(_firmwareVersion),
                      onPressed: queryFirmwareVersion),
                  ElevatedButton(
                      child: Text(_newFirmwareInfo),
                      onPressed: ()=>checkFirmwareVersion(_firmwareVersion,OTAType.normalUpgradeType)),
                  ElevatedButton(
                      child: const Text('queryHsOtaAddress()'),
                      onPressed: () async {
                        String hsOtaAddress = await _blePlugin.queryHsOtaAddress;
                        setState(() {
                          _hsOtaAddress = hsOtaAddress;
                        });
                      }),
                  ElevatedButton(
                      child: const Text('startOTA(cmu)'),
                      onPressed: () =>  startOTA(
                          checkFirmwareVersionBeanFromJson(_newFirmwareInfo).isLatestVersion!?-1:checkFirmwareVersionBeanFromJson(_newFirmwareInfo)
                              .firmwareVersionInfo!
                              .mcu!,
                          _hsOtaAddress)),
                  ElevatedButton(
                      child: const Text('abortOTA(oTAType)'),
                      onPressed: () => _blePlugin.abortOTA(_oTAType!)),
                  ElevatedButton(
                      child: const Text('queryDeviceOtaStatus()'),
                      onPressed: () async {
                        int deviceOtaStatus = await _blePlugin.queryDeviceOtaStatus;
                        setState(() {
                          _deviceOtaStatus = deviceOtaStatus;
                        });
                      }),
                  ElevatedButton(
                      child: const Text('enableHsOta()'),
                      onPressed: () => _blePlugin.enableHsOta),
                  ElevatedButton(
                      child: const Text('queryOtaType()'),
                      onPressed: () async {
                        int otaType = await _blePlugin.queryOtaType;
                        setState(() {
                          _otaType = otaType;
                        });
                      }),
                ]
            )
        ),
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
        await _blePlugin.checkFirmwareVersion(FirmwareVersion(
          version: version,
          otaType: oTAType
        ));
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
        _oTAType = OTAMcuType.startHsOta;
        await _blePlugin
            .startOTA(OtaBean(address: address, type: OTAMcuType.startHsOta));
        break;
      case 7:
      case 11:
      case 71:
      case 72:
        _oTAType = OTAMcuType.startRtkOta;
        await _blePlugin
            .startOTA(OtaBean(address: address, type: OTAMcuType.startRtkOta));
        break;
      case 10:
        _oTAType = OTAMcuType.startOta;
        await _blePlugin
            .startOTA(OtaBean(address: address, type: OTAMcuType.startOta));
        break;
      default:
        _oTAType = OTAMcuType.startDefaultOta;
        await _blePlugin
            .startOTA(OtaBean(address: address, type: OTAMcuType.startDefaultOta));
        break;
    }
  }
}
