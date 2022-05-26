import 'dart:async';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import 'package:moyoung_ble_plugin_example/modules/protoclVersion.dart';
import 'package:moyoung_ble_plugin_example/modules/quickView.dart';
import 'package:moyoung_ble_plugin_example/modules/sedentaryReminder.dart';
import 'package:moyoung_ble_plugin_example/modules/setsLocalCity.dart';
import 'package:moyoung_ble_plugin_example/modules/shutDown.dart';
import 'package:moyoung_ble_plugin_example/modules/sleep.dart';
import 'package:moyoung_ble_plugin_example/modules/steps.dart';
import 'package:moyoung_ble_plugin_example/modules/takePhoto.dart';
import 'package:moyoung_ble_plugin_example/modules/temperatureSystem.dart';
import 'package:moyoung_ble_plugin_example/modules/time.dart';
import 'package:moyoung_ble_plugin_example/modules/unitsystem.dart';
import 'package:moyoung_ble_plugin_example/modules/userInfo.dart';
import 'package:moyoung_ble_plugin_example/modules/watchFace.dart';
import 'package:moyoung_ble_plugin_example/modules/weather.dart';

import 'package:moyoung_ble_plugin/moyoung_ble.dart';

import 'modules/BloodOxygen.dart';
import 'modules/ClassicBluetoothAddress.dart';
import 'modules/ECG.dart';
import 'modules/FindWatch.dart';
import 'modules/Language.dart';
import 'modules/MusicPlayer.dart';
import 'modules/PillReminder.dart';
import 'modules/RSSI.dart';
import 'modules/TapWake.dart';
import 'modules/Training.dart';
import 'modules/alarm.dart';
import 'modules/battery.dart';
import 'modules/batterySaving.dart';
import 'modules/bloodPressurePage.dart';
import 'modules/bodyTemperature.dart';
import 'modules/breathingLight.dart';
import 'modules/brightness.dart';
import 'modules/contacts.dart';
import 'modules/displayTime.dart';
import 'modules/drinkWaterReminder.dart';
import 'modules/findPhone.dart';
import 'modules/firmware.dart';
import 'modules/goalSteps.dart';
import 'modules/handWashingReminder.dart';
import 'modules/heartRate.dart';
import 'modules/heartRateAlarm.dart';
import 'modules/menstrualCycle.dart';
import 'modules/movementTraining.dart';
import 'modules/notDisturb.dart';
import 'modules/notification.dart';

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
  final MoYoungBle _blePlugin = MoYoungBle();

  int _connetionState = -1;
  bool isConn = false;

  Logger logger = Logger();
  String oTAType="";

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
      _blePlugin.deviceBatteryEveStm.listen(
        (DeviceBatteryBean event) {
          setState(() {
            // _connStepChange = event;
          });
        },
      ),
    );

    _streamSubscriptions.add(
      _blePlugin.weatherChangeEveStm.listen(
        (int event) {
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
        (FirmwareUpgradeBean event) {
          setState(() {
            // _connStepChange = event;
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
          (WatchFaceBgProgressBean event) {
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
        (FileTransLazyBean event) {
          setState(() {
            logger.d('connLazyWFFileTransEveStm===' + event.toString());
          });
        },
      ),
    );
    _streamSubscriptions.add(
      _blePlugin.lazyEcgEveStm.listen(
        (event) {
          setState(() {
            logger.d('connLazyEcgEveStm===' + event.ints.toString());
          });
        },
      ),
    );
    _streamSubscriptions.add(
      _blePlugin.lazyContactAvatarEveStm.listen(
        (FileTransLazyBean event) {
          setState(() {
            logger.d('connLazyContactAvatarEveStm===' + event.toString());
          });
        },
      ),
    );

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
        (TempChangeBean event) {
          setState(() {
            logger.d("connTempChangeEveStm======" + event.toString());
          });
        },
      ),
    );

    _streamSubscriptions.add(
      _blePlugin.contactEveStm.listen(
        (ContactListenBean event) {
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
        (TrainBean event) {
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
              Text(device.name + ',' + device.address),

              // Text("StepsChange=" + _connStepChange.stepInfo.steps.toString()),

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
                    isConn = false;
                    _blePlugin.disconnect;
                  }),
              const Text("Module functions are as follows"),
              ElevatedButton(
                  onPressed: () {
                    if(isConn) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return TimePage(
                              blePlugin: _blePlugin,
                            );
                          }));
                    }
                  },
                  child: const Text("2.4-Time")),
              ElevatedButton(
                  onPressed: () {
                    if(isConn) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return FirmwarePage(
                              blePlugin: _blePlugin,
                              device: device,
                            );
                          }));
                    }
                  },
                  child: const Text("2.5-Firmware")),
              ElevatedButton(
                  onPressed: () {
                    if(isConn) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return BatteryPage(
                              blePlugin: _blePlugin,
                            );
                          })
                      );
                    }
                  },
                  child: const Text("2.6-Battery")),
              ElevatedButton(
                  onPressed: () {
                    if(isConn) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return UserInfoPage(
                              blePlugin: _blePlugin,
                            );
                          }));
                    }
                  },
                  child: const Text("2.7-UserInfo")),
              ElevatedButton(
                  onPressed: () {
                    if(isConn) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return WeatherPage(
                              blePlugin: _blePlugin,
                            );
                          }));
                    }
                  },
                  child: const Text("2.8-Weather")),
              ElevatedButton(
                  onPressed: () {
                    if(isConn) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return StepsPage(
                              blePlugin: _blePlugin,
                            );
                          }));
                    }
                  },
                  child: const Text("2.9-Steps")),
              ElevatedButton(
                  onPressed: () {
                    if(isConn) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return SleepPage(
                              blePlugin: _blePlugin,
                            );
                          }));
                    }
                  },
                  child: const Text("2.10-Sleep")),
              ElevatedButton(
                  onPressed: () {
                    if(isConn) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return UnitSystemPage(
                              blePlugin: _blePlugin,
                            );
                          }));
                    }
                  },
                  child: const Text("2.11-UnitSystem")),
              ElevatedButton(
                  onPressed: () {
                    if(isConn) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return QuickViewPage(
                              blePlugin: _blePlugin,
                            );
                          }));
                    }
                  },
                  child: const Text("2.12-QuickView")),
              ElevatedButton(
                  onPressed: () {
                    if(isConn) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return GoalStepsPage(
                              blePlugin: _blePlugin,
                            );
                          }));
                    }
                  },
                  child: const Text("2.13-GoalSteps")),
              ElevatedButton(
                  onPressed: () {
                    if(isConn) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return WatchFacePage(
                              blePlugin: _blePlugin,
                            );
                          }));
                    }
                  },
                  child: const Text("2.14-WatchFace")),
              ElevatedButton(
                  onPressed: () {
                    if(isConn) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return AlarmPage(
                              blePlugin: _blePlugin,
                            );
                          }));
                    }
                  },
                  child: const Text("2.15-Alarm")),
              ElevatedButton(
                  onPressed: () {
                    if(isConn) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return LanguagePage(
                              blePlugin: _blePlugin,
                            );
                          }));
                    }
                  },
                  child: const Text("2.16-Language")),
              ElevatedButton(
                  onPressed: () {
                    if(isConn) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return NotificationPage(
                              blePlugin: _blePlugin,
                            );
                          }));
                    }
                  },
                  child: const Text("2.17-Notification")),
              ElevatedButton(
                  onPressed: () {
                    if(isConn) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return SedentaryReminderPage(
                              blePlugin: _blePlugin,
                            );
                          }));
                    }
                  },
                  child: const Text("2.19-SedentaryReminder")),
              ElevatedButton(
                  onPressed: () {
                    if(isConn) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return FindWatchPage(
                              blePlugin: _blePlugin,
                            );
                          }));
                    }
                  },
                  child: const Text("2.20-FindWatch")),
              ElevatedButton(
                  onPressed: () {
                    if(isConn) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return HearRatePage(
                              blePlugin: _blePlugin,
                            );
                          }));
                    }
                  },
                  child: const Text("2.21-Hearate")),
              ElevatedButton(
                  onPressed: () {
                    if(isConn) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return BloodPressurePage(
                              blePlugin: _blePlugin,
                            );
                          }));
                    }
                  },
                  child: const Text("2.22-BloodPressure")),
              ElevatedButton(
                  onPressed: () {
                    if(isConn) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return BloodOxygenPage(
                              blePlugin: _blePlugin,
                            );
                          }));
                    }
                  },
                  child: const Text("2.23-BloodOxygen")),
              ElevatedButton(
                  onPressed: () {
                    if(isConn) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return TakePhotoPage(
                              blePlugin: _blePlugin,
                            );
                          }));
                    }
                  },
                  child: const Text("2.24-TakePhoto")),
              ElevatedButton(
                  onPressed: () {
                    if(isConn) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return RSSIPage(
                              blePlugin: _blePlugin,
                            );
                          }));
                    }
                  },
                  child: const Text("2.26-RSSI")),
              ElevatedButton(
                  onPressed: () {
                    if(isConn) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return ShutDownPage(
                              blePlugin: _blePlugin,
                            );
                          }));
                    }
                  },
                  child: const Text("2.27-ShutDown")),
              ElevatedButton(
                  onPressed: () {
                    if(isConn) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return NotDisturbPage(
                              blePlugin: _blePlugin,
                            );
                          }));
                    }
                  },
                  child: const Text("2.28-NotDisturb")),
              ElevatedButton(
                  onPressed: () {
                    if(isConn) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return BreathingLightPage(
                              blePlugin: _blePlugin,
                            );
                          }));
                    }
                  },
                  child: const Text("2.29-BreathingLight")),
              ElevatedButton(
                  onPressed: () {
                    if(isConn) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return ECGPage(
                              blePlugin: _blePlugin,
                            );
                          }));
                    }
                  },
                  child: const Text("2.30-ECG")),
              ElevatedButton(
                  onPressed: () {
                    if(isConn) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return MenstrualCyclePage(
                              blePlugin: _blePlugin,
                            );
                          }));
                    }
                  },
                  child: const Text("2.31-MenstrualCycle")),
              ElevatedButton(
                  onPressed: () {
                    if(isConn) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return FindPhonePage(
                              blePlugin: _blePlugin,
                            );
                          }));
                    }
                  },
                  child: const Text("2.32-FindPhone")),
              ElevatedButton(
                  onPressed: () {
                    if(isConn) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return MusicPlayerPage(
                              blePlugin: _blePlugin,
                            );
                          }));
                    }
                  },
                  child: const Text("2.33-MusicPlayer")),
              ElevatedButton(
                  onPressed: () {
                    if(isConn) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return DrinkWaterReminderPage(
                              blePlugin: _blePlugin,
                            );
                          }));
                    }
                  },
                  child: const Text("2.34-DrinkWaterReminder")),
              ElevatedButton(
                  onPressed: () {
                    if(isConn) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return HeartRateAlarmPage(
                              blePlugin: _blePlugin,
                            );
                          }));
                    }
                  },
                  child: const Text("2.35-HeartRateAlarm")),
              ElevatedButton(
                  onPressed: () {
                    if(isConn) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return MovementTrainingPage(
                              blePlugin: _blePlugin,
                            );
                          }));
                    }
                  },
                  child: const Text("2.36-MovementTraining")),
              ElevatedButton(
                  onPressed: () {
                    if(isConn) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return ProtocolVersionPage(
                              blePlugin: _blePlugin,
                            );
                          }));
                    }
                  },
                  child: const Text("2.37-ProtocolVersion")),
              ElevatedButton(
                  onPressed: () {
                    if(isConn) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return BodyTemperaturePage(
                              blePlugin: _blePlugin,
                            );
                          }));
                    }
                  },
                  child: const Text("2.38-BodyTemperature")),
              ElevatedButton(
                  onPressed: () {
                    if(isConn) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return DisplayTimePage(
                              blePlugin: _blePlugin,
                            );
                          }));
                    }
                  },
                  child: const Text("2.39-DisplayTime")),
              ElevatedButton(
                  onPressed: () {
                    if(isConn) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return HandWashingReminderPage(
                              blePlugin: _blePlugin,
                            );
                          }));
                    }
                  },
                  child: const Text("2.40-HandWashingReminder")),
              ElevatedButton(
                  onPressed: () {
                    if(isConn) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return SetsLocalCityPage(
                              blePlugin: _blePlugin,
                            );
                          }));
                    }
                  },
                  child: const Text("2.41-SetsLocalCity")),
              ElevatedButton(
                  onPressed: () {
                    if(isConn) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return TemperatureSystemPage(
                              blePlugin: _blePlugin,
                            );
                          }));
                    }
                  },
                  child: const Text("2.42-TemperatureSystem")),
              ElevatedButton(
                  onPressed: () {
                    if(isConn) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return BrightnessPage(
                              blePlugin: _blePlugin,
                            );
                          }));
                    }
                  },
                  child: const Text("2.43-Brightness")),
              ElevatedButton(
                  onPressed: () {
                    if(isConn) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return ClassicBluetoothAddressPage(
                              blePlugin: _blePlugin,
                            );
                          }));
                    }
                  },
                  child: const Text("2.44-ClassicBluetoothAddress")),
              ElevatedButton(
                  onPressed: () {
                    if(isConn) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return ContactsPage(
                              blePlugin: _blePlugin,
                            );
                          }));
                    }
                  },
                  child: const Text("2.45-Contacts")),
              ElevatedButton(
                  onPressed: () {
                    if(isConn) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return BatterySavingPage(
                              blePlugin: _blePlugin,
                            );
                          }));
                    }
                  },
                  child: const Text("2.46-BatterySaving")),
              ElevatedButton(
                  onPressed: () {
                    if(isConn) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return PillReminderPage(
                              blePlugin: _blePlugin,
                            );
                          }));
                    }
                  },
                  child: const Text("2.47-PillReminder")),
              ElevatedButton(
                  onPressed: () {
                    if(isConn) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return TapWakePage(
                              blePlugin: _blePlugin,
                            );
                          }));
                    }
                  },
                  child: const Text("2.48-TapWake")),
              ElevatedButton(
                  onPressed: () {
                    if(isConn) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return TrainingPage(
                              blePlugin: _blePlugin,
                            );
                          }));
                    }
                  },
                  child: const Text("2.49-Training")),
              // libaozhong: end
            ],
          ),
        ),
      ),
    );
  }
}
