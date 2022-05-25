import 'dart:async';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import 'package:moyoung_ble_plugin_example/lbz.dart';
import 'package:moyoung_ble_plugin_example/system.dart';
import 'package:moyoung_ble_plugin_example/xulei.dart';
import 'package:moyoung_ble_plugin_example/yusixia.dart';

import 'package:moyoung_ble_plugin/moyoung_ble.dart';

class NewRoute extends StatefulWidget {
  BleScanBean device;

  NewRoute({
    Key? key,
    required this.device,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _NewRoute(device);
  }
}

class _NewRoute extends State<NewRoute> {
  late BleScanBean device;

  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  // final MoyoungBlePlugin _blePlugin = MoyoungBlePlugin();
  final MoYoungBle _blePlugin = MoYoungBle();


  int _connetionState = -1;
  StepChangeBean _connStepChange =
  StepChangeBean(stepInfo: StepChange(steps: -1, distance: -1, calories: -1, time: -1),past:-1,
          pastStepInfo:StepChange(steps: -1, distance: -1, calories: -1, time: -1));
  String _newFirmwareInfo = "checkFirmwareVersion()";
  bool isConn = false;

  //余诗霞：start
  Logger logger = Logger();
  String oTAType="";
  String _firmwareVersion = "未获取";
  //余诗霞：end

  _NewRoute(this.device);

  @override
  void initState() {
    super.initState();
    subscriptStream();
  }

  void subscriptStream() {
    _streamSubscriptions.add(
      _blePlugin.connStateEveStm.listen(
        (int event) {
          setState(() {
            _connetionState = event;
          });
        },
      ),
    );

    _streamSubscriptions.add(
      _blePlugin.stepChangeEveStm.listen(
        (StepChangeBean event) {
          setState(() {
            _connStepChange = event;
          });
        },
      ),
    );

    //余诗霞补充

    _streamSubscriptions.add(
      _blePlugin.deviceBatteryEveStm.listen(
        (Map<dynamic,dynamic> event) {
          setState(() {
            // _connStepChange = event;
          });
        },
      ),
    );

    _streamSubscriptions.add(
      _blePlugin.weatherChangeEveStm.listen(
        (Map<dynamic,dynamic> event) {
          setState(() {
            // _connStepChange = event;
          });
        },
      ),
    );

    _streamSubscriptions.add(
      _blePlugin.stepsCategoryEveStm.listen(
        (StepsCategoryBean event) {
          setState(() {
            // _connStepChange = event;
          });
        },
      ),
    );
    _streamSubscriptions.add(
      _blePlugin.sleepChangeEveStm.listen(
        (SleepBean event) {
          setState(() {
            // _connStepChange = event;
          });
        },
      ),
    );
    _streamSubscriptions.add(
      _blePlugin.firmwareUpgradeEveStm.listen(
        (event) {
          setState(() {
            // _connStepChange = event;
          });
        },
      ),
    );


    //余诗霞：start
    _streamSubscriptions.add(
      _blePlugin.heartRateEveStm.listen(
        (event) {
          setState(() {
            logger.d('connHeartRateEveStm===' + event.measuring.toString());
          });
        },
      ),
    );
    _streamSubscriptions.add(
      _blePlugin.bloodPressureEveStm.listen(
        (event) {
          setState(() {
            logger.d('connBloodPressureEveStm===' + event.bloodPressureChange.toString());
          });
        },
      ),
    );
    _streamSubscriptions.add(
      _blePlugin.bloodOxygenEveStm.listen(
        (event) {
          setState(() {
            logger.d('connBloodOxygenEveStm===' + event.bloodOxygen.toString());
          });
        },
      ),
    );
    _streamSubscriptions.add(
      _blePlugin.cameraEveStm.listen(
        (event) {
          setState(() {
            logger.d('connCameraEveStm');
          });
        },
      ),
    );
    _streamSubscriptions.add(
      _blePlugin.phoneEveStm.listen(
        (event) {
          setState(() {
            logger.d('connPhoneEveStm===' + event.toString());
          });
        },
      ),
    );
    _streamSubscriptions.add(
      _blePlugin.deviceRssiEveStm.listen(
        (event) {
          setState(() {
            logger.d('connDeviceRssiEveStm===' + event.toString());
          });
        },
      ),
    );

    var lazyFileTransEveStm = _blePlugin.lazyFileTransEveStm.listen(
          (event) {
        setState(() {
          logger.d('connLazyFileTransEveStm===' + event.toString());
        });
      },
    );
    lazyFileTransEveStm.onError((error) {
      print(error.toString());
    });
    _streamSubscriptions.add(lazyFileTransEveStm);

    _streamSubscriptions.add(
      _blePlugin.lazyWFFileTransEveStm.listen(
        (WfFileTransLazyBean event) {
          setState(() {
            logger.d('connLazyWFFileTransEveStm===' + event.toString());
          });
        },
      ),
    );
    _streamSubscriptions.add(
      _blePlugin.lazyEgcEveStm.listen(
        (event) {
          setState(() {
            logger.d('connLazyEgcEveStm===' + event.ints.toString());
          });
        },
      ),
    );
    //以下是李宝忠的监听
    _streamSubscriptions.add(
      _blePlugin.lazyContactAvatarEveStm.listen(
        (event) {
          setState(() {
            logger.d('connLazyContactAvatarEveStm===' + event.toString());
          });
        },
      ),
    );
    //余诗霞：end

    _streamSubscriptions.add(
      _blePlugin.movementStateEveStm.listen(
        (event) {
          setState(() {
            logger.d("connTainStateEveStm======" + event.toString());
          });
        },
      ),
    );

    _streamSubscriptions.add(
      _blePlugin.tempChangeEveStm.listen(
        (event) {
          setState(() {
            logger.d("connTempChangeEveStm======" + event.toString());
          });
        },
      ),
    );

    _streamSubscriptions.add(
      _blePlugin.contactEveStm.listen(
        (event) {
          setState(() {
            logger.d("connContactEveStm======" + event.toString());
          });
        },
      ),
    );

    _streamSubscriptions.add(
      _blePlugin.batterySavingEveStm.listen(
        (event) {
          setState(() {
            logger.d("connBatterySavingEveStm======" + event.toString());
          });
        },
      ),
    );

    _streamSubscriptions.add(
      _blePlugin.trainingEveStm.listen(
        (event) {
          setState(() {
            logger.d("connTrainingEveStm======" + event.toString());
          });
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: ListView(
            children: <Widget>[
              ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("返回")),
              Text(device.name + ',' + device.address),

              Text("StepChange=" + _connStepChange.stepInfo.steps.toString()),

              Text('connetionState= $_connetionState'),

              ElevatedButton(
                  child: const Text('isConnected()'),
                  onPressed: () {
                    _blePlugin.isConnected(device.address);
                  }),
              ElevatedButton(
                  child: const Text("connect()"),
                  onPressed: () {
                    _blePlugin.connect(device.address);
                    isConn = true;
                  }),
              ElevatedButton(
                  child: const Text('disconnect()'),
                  onPressed: () {
                    _blePlugin.disconnect;
                  }),
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
                  child: const Text('queryDeviceBattery()'),
                  onPressed: () => _blePlugin.queryDeviceBattery),
              ElevatedButton(
                  child: const Text('subscribeDeviceBattery()'),
                  onPressed: () => _blePlugin.subscribeDeviceBattery),
              ElevatedButton(
                  child: const Text('sendUserInfo()-MALE'),
                  onPressed: () => _blePlugin.sendUserInfo(UserBean(
                      weight: 50,
                      height: 180,
                      gender: UserBean.male,
                      age: 30))),
              ElevatedButton(
                  child: const Text('sendUserInfo()-FEMALE'),
                  onPressed: () => _blePlugin.sendUserInfo(UserBean(
                      weight: 50,
                      height: 170,
                      gender: UserBean.female,
                      age: 31))),
              ElevatedButton(
                  child: const Text('sendStepLength(5)'),
                  onPressed: () => _blePlugin.sendStepLength(5)),
              ElevatedButton(
                  child: const Text('sendTodayWeather()'),
                  onPressed: () => _blePlugin.sendTodayWeather(
                      TodayWeatherBean(
                          city: "111",
                          lunar: "111",
                          festival: "111",
                          pm25: 111,
                          temp: 111,
                          weatherId: 111))),
              ElevatedButton(
                  child: const Text('sendFutureWeather()'),
                  onPressed: () => _blePlugin.sendFutureWeather(
                      TodayWeatherBean(
                          city: "111",
                          lunar: "111",
                          festival: "111",
                          pm25: 111,
                          temp: 111,
                          weatherId: 111))),
              //余诗霞补充：start
              ElevatedButton(
                  child: const Text('syncStep'),
                  onPressed: () => _blePlugin.syncStep),
              ElevatedButton(
                  child: const Text('syncPastStep(YESTERDAY_STEPS)'),
                  onPressed: () => _blePlugin.syncPastStep(PastTimeType.YESTERDAY_STEPS)),
              ElevatedButton(
                  child: const Text('queryStepsCategory(CRPStepsCategoryDateType)'),
                  onPressed: () => _blePlugin.queryStepsCategory(StepsCategoryDateType.TODAY_STEPS_CATEGORY)),
             const Text("睡眠"),
              ElevatedButton(
                  child: const Text('syncSleep'),
                  onPressed: () => _blePlugin.syncSleep),
              ElevatedButton(
                  child: const Text('syncRemSleep'),
                  onPressed: () => _blePlugin.syncRemSleep),
              ElevatedButton(
                  child: const Text('syncPastSleep(YESTERDAY_STEPS)'),
                  onPressed: () => _blePlugin.syncPastSleep(PastTimeType.YESTERDAY_STEPS)),
              ElevatedButton(
                  child: const Text('syncPastSleep(DAY_BEFORE_YESTERDAY_STEPS)'),
                  onPressed: () => _blePlugin.syncPastSleep(PastTimeType.DAY_BEFORE_YESTERDAY_STEPS)),
              ElevatedButton(
                  child: const Text('syncPastSleep(YESTERDAY_SLEEP)'),
                  onPressed: () => _blePlugin.syncPastSleep(PastTimeType.YESTERDAY_SLEEP)),
              ElevatedButton(
                  child: const Text('syncPastSleep(DAY_BEFORE_YESTERDAY_SLEEP)'),
                  onPressed: () => _blePlugin.syncPastSleep(PastTimeType.DAY_BEFORE_YESTERDAY_SLEEP)),
              const Text("固件升级"),
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
              //余诗霞补充：end
              ElevatedButton(
                  onPressed: () {
                    if(isConn) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return System(
                              blePlugin: _blePlugin,
                            );
                          }));
                    }
                  },
                  child: const Text("系统测试")),
              ElevatedButton(
                  onPressed: () {
                    if(isConn) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return Xulei(
                              blePlugin: _blePlugin,
                            );
                          }));
                    }
                  },
                  child: const Text("许蕾页面")),
              ElevatedButton(
                  onPressed: () {
                    if(isConn) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return Yusixia(
                              blePlugin: _blePlugin,
                            );
                          }));
                    }
                  },
                  child: const Text("余诗霞页面")),
              ElevatedButton(
                  onPressed: () {
                    if(isConn) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return Lbz(
                              blePlugin: _blePlugin,
                            );
                          }));
                    }
                  },
                  child: const Text("李宝忠页面"))
              // libaozhong: end
            ],
          ),
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
      isConn = false;
      _newFirmwareInfo = checkOtaBeanToJson(versionInfo);
    });
  }

  Future<void> firmwareUpgrade(int mcu, String address) async {
    switch (mcu) {
      case 4:
      case 8:
      case 9:
      oTAType="OTA_FIRST";
        await _blePlugin.firmwareUpgradeByHsDfu(address);
        break;
      case 7:
      case 11:
      case 71:
      case 72:
      oTAType="OTA_SECOND";
        await _blePlugin.firmwareUpgradeByRtkDfu(address);
        break;
      case 10:
        oTAType="OTA_THIRD";
        await _blePlugin.firmwareUpgrade(true);
        break;
      default:
        oTAType="OTA_FOUR";
        await _blePlugin.firmwareUpgrade(false);
        break;
    }
  }

  Future<void> firmwareUpgradeAbort(String oTAType) async {
    switch (oTAType) {
      case "OTA_FIRST":
        await _blePlugin.firmwareAbortByHsDfu();
        break;
      case "OTA_SECOND":
        await _blePlugin.firmwareAbortByRtkDfu();
        break;
      default:
        await _blePlugin.firmwareAbort();
        break;
    }
  }
}
