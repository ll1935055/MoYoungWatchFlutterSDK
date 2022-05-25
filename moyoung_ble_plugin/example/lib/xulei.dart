import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

class Xulei extends StatefulWidget {
  MoYoungBle blePlugin;

  Xulei({
    Key? key,
    required this.blePlugin,
  }) : super(key: key);

  @override
  State<Xulei> createState() {
    return _YuleiPage(blePlugin);
  }
}

class _YuleiPage extends State<Xulei> {
  final MoYoungBle _blePlugin;

  _YuleiPage(this._blePlugin);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("许蕾"),
        ),
        body: Center(
          child: ListView(
            children: <Widget>[
              //xulei:start
              ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("返回")),
              ElevatedButton(
                  child: const Text('sendDeviceLanguage()'),
                  onPressed: () => _blePlugin.sendDeviceLanguage(DeviceLanguageType.LANGUAGE_CHINESE)),
              ElevatedButton(
                  child: const Text('queryDeviceLanguage()'),
                  onPressed: () => _blePlugin.queryDeviceLanguage),
              ElevatedButton(
                  child: const Text('sendOtherMessageState(false)'),
                  onPressed: () => _blePlugin.sendOtherMessageState(false)),
              ElevatedButton(
                  child: const Text('sendOtherMessageState(true)'),
                  onPressed: () => _blePlugin.sendOtherMessageState(true)),
              ElevatedButton(
                  child: const Text('queryOtherMessageState()'),
                  onPressed: () => _blePlugin.queryOtherMessageState),
              ElevatedButton(
                  child: const Text(
                      'sendMessage(CrpMessageInfo()'),
                  onPressed: () => _blePlugin.sendMessage(
                      MessageBean(
                          message: 'message',
                          type: BleMessageType.MESSAGE_PHONE,
                          versionCode: 229,
                          isHs: false,
                          isSmallScreen: false
                      ))),
              //存在问题
              ElevatedButton(
                  child: const Text('sendCall0ffHook()'),
                  onPressed: () => _blePlugin.sendCall0ffHook),
              ElevatedButton(
                  child: const Text('sendSedentaryReminder(false)'),
                  onPressed: () => _blePlugin.sendSedentaryReminder(false)),
              ElevatedButton(
                  child: const Text('sendSedentaryReminder(true)'),
                  onPressed: () => _blePlugin.sendSedentaryReminder(true)),
              ElevatedButton(
                  child: const Text('querySedentaryReminder()'),
                  onPressed: () => _blePlugin.querySedentaryReminder),
              ElevatedButton(
                  child: const Text('sendSedentaryReminderPeriod()'),
                  onPressed: () => _blePlugin.sendSedentaryReminderPeriod(
                      SedentaryReminderPeriodBean(
                          startHour: 10,
                          endHour: 20,
                          period: 30,
                          steps: 40
                      ))),
              ElevatedButton(
                  child: const Text('querySedentaryReminderPeriod()'),
                  onPressed: () => _blePlugin.querySedentaryReminderPeriod),
              //需要调试
              ElevatedButton(
                  child: const Text('shutDown()'),
                  onPressed: () => _blePlugin.shutDown),
              ElevatedButton(
                  child: const Text('findDevice()'),
                  onPressed: () => _blePlugin.findDevice),
              //需要改进
              ElevatedButton(
                  child: const Text('queryDoNotDisturbTime()'),
                  onPressed: () => _blePlugin.queryDoNotDisturbTime),
              ElevatedButton(
                  child: const Text('sendDoNotDisturbTime()'),
                  onPressed: () => _blePlugin.sendDoNotDisturbTime(
                      PeriodTimeBean(
                          startHour: 1,
                          endHour: 1,
                          startMinute: 1,
                          endMinute: 1
                      ))),
              ElevatedButton(
                  child: const Text('sendBreathingLight(false)'),
                  onPressed: () => _blePlugin.sendBreathingLight(false)),
              ElevatedButton(
                  child: const Text('sendBreathingLight(true)'),
                  onPressed: () => _blePlugin.sendBreathingLight(true)),
              ElevatedButton(
                  child: const Text('queryBreathingLight()'),
                  onPressed: () => _blePlugin.queryBreathingLight),
              //xulei:end
            ],
          ),
        ),
      ),
    );
  }
}