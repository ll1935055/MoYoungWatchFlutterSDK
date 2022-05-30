import 'dart:async';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

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
import 'package:moyoung_ble_plugin_example/modules/BloodOxygen.dart';
import 'package:moyoung_ble_plugin_example/modules/ClassicBluetoothAddress.dart';
import 'package:moyoung_ble_plugin_example/modules/ECG.dart';
import 'package:moyoung_ble_plugin_example/modules/FindWatch.dart';
import 'package:moyoung_ble_plugin_example/modules/Language.dart';
import 'package:moyoung_ble_plugin_example/modules/MusicPlayer.dart';
import 'package:moyoung_ble_plugin_example/modules/PillReminder.dart';
import 'package:moyoung_ble_plugin_example/modules/RSSI.dart';
import 'package:moyoung_ble_plugin_example/modules/TapWake.dart';
import 'package:moyoung_ble_plugin_example/modules/Training.dart';
import 'package:moyoung_ble_plugin_example/modules/alarm.dart';
import 'package:moyoung_ble_plugin_example/modules/battery.dart';
import 'package:moyoung_ble_plugin_example/modules/batterySaving.dart';
import 'package:moyoung_ble_plugin_example/modules/bloodPressurePage.dart';
import 'package:moyoung_ble_plugin_example/modules/bodyTemperature.dart';
import 'package:moyoung_ble_plugin_example/modules/breathingLight.dart';
import 'package:moyoung_ble_plugin_example/modules/brightness.dart';
import 'package:moyoung_ble_plugin_example/modules/contacts.dart';
import 'package:moyoung_ble_plugin_example/modules/displayTime.dart';
import 'package:moyoung_ble_plugin_example/modules/drinkWaterReminder.dart';
import 'package:moyoung_ble_plugin_example/modules/findPhone.dart';
import 'package:moyoung_ble_plugin_example/modules/firmware.dart';
import 'package:moyoung_ble_plugin_example/modules/goalSteps.dart';
import 'package:moyoung_ble_plugin_example/modules/handWashingReminder.dart';
import 'package:moyoung_ble_plugin_example/modules/heartRate.dart';
import 'package:moyoung_ble_plugin_example/modules/heartRateAlarm.dart';
import 'package:moyoung_ble_plugin_example/modules/menstrualCycle.dart';
import 'package:moyoung_ble_plugin_example/modules/movementTraining.dart';
import 'package:moyoung_ble_plugin_example/modules/notDisturb.dart';
import 'package:moyoung_ble_plugin_example/modules/notification.dart';

class DevicePage extends StatefulWidget {
  final BleScanBean device;

  const DevicePage({
    Key? key,
    required this.device,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DevicePage(device);
  }
}

class _DevicePage extends State<DevicePage> {
  late BleScanBean device;

  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  final MoYoungBle _blePlugin = MoYoungBle();

  int _connetionState = -1;
  bool isConn = false;

  Logger logger = Logger();
  String oTAType="";

  _DevicePage(this.device);

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
          title: const Text('Device Page'),
        ),
        body: Center(
          child: ListView(
            children: <Widget>[
              Text(device.name + ',' + device.address),

              Text('connectionState= $_connetionState'),

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
              const Text("Module functions are as follows:",
              style: TextStyle(
                fontSize: 20,
                height: 2.0,
              )),
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
                  child: const Text("2.36-Training")),
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
            ],
          ),
        ),
      ),
    );
  }
}
