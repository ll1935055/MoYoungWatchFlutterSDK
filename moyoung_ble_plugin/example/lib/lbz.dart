import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

import 'contact_list_page.dart';

class Lbz extends StatefulWidget {
  MoYoungBle blePlugin;

  Lbz({
    Key? key,
    required this.blePlugin,
  }) : super(key: key);

  @override
  State<Lbz> createState() {
    return _LbzPage(blePlugin);
  }
}

class _LbzPage extends State<Lbz> {
  final MoYoungBle _blePlugin;
  _LbzPage(this._blePlugin);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("李宝忠"),
        ),
        body: Center(
          child: ListView(
            children: <Widget>[
              ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("返回")),
              const Text("李宝忠Start"),
              ElevatedButton(
                  onPressed: () => _blePlugin.sendMenstrualCycle(PhysiologcalPeriodBean(
                      physiologcalPeriod: 1,
                      menstrualPeriod: 1,
                      startDate: DateTime.now().millisecondsSinceEpoch,
                      menstrualReminder: true,
                      ovulationReminder: true,
                      ovulationDayReminder: true,
                      ovulationEndReminder: true,
                      reminderHour: 1,
                      reminderMinute: 1
                  )),
                  child: const Text("sendMenstrualCycle()")),
              ElevatedButton(
                  onPressed: () => _blePlugin.queryMenstrualCycle,
                  child: const Text("queryMenstrualCycle()")),
              ElevatedButton(
                  onPressed: () => _blePlugin.startFindPhone,
                  child: const Text('startFindPhone()')),
              ElevatedButton(
                  onPressed: () => _blePlugin.stopFindPhone,
                  child: const Text("stopFindPhone()")),
              ElevatedButton(
                  onPressed: () => _blePlugin.setMusicPlayerState(MusicPlayerStateType.MUSIC_PLAYER_PAUSE),
                  child: const Text("setMusicPlayerState(0)")),
              ElevatedButton(
                  onPressed: () => _blePlugin.setMusicPlayerState(MusicPlayerStateType.MUSIC_PLAYER_PLAY),
                  child: const Text("setMusicPlayerState(1)")),
              ElevatedButton(
                  onPressed: () => _blePlugin.sendSongTitle("111"),
                  child: const Text("sendSongTitle()")),
              ElevatedButton(
                  onPressed: () => _blePlugin.sendLyrics("lyrics"),
                  child: const Text("sendLyrics()")),
              ElevatedButton(
                  onPressed: () => _blePlugin.closeMusicControl,
                  child: const Text("closeMusicControl()")),
              ElevatedButton(
                  onPressed: () => _blePlugin.sendCurrentVolume(50),
                  child: const Text("sendCurrentVolume()")),
              ElevatedButton(
                  onPressed: () => _blePlugin.sendMaxVolume(100),
                  child: const Text("sendMaxVolume()")),
              ElevatedButton(
                  onPressed: () => _blePlugin.enableDrinkWaterReminder(DrinkWaterPeriodBean(
                      enable: true,
                      startHour: 1,
                      startMinute: 1,
                      count: 1,
                      period: 1,
                      currentCups: 1)),
                  child: const Text("enableDrinkWaterReminder()")),
              ElevatedButton(
                  onPressed: () => _blePlugin.disableDrinkWaterReminder,
                  child: const Text("disableDrinkWaterReminder()")),
              ElevatedButton(
                  onPressed: () => _blePlugin.queryDrinkWaterReminderPeriod,
                  child: const Text("queryDrinkWaterReminderPeriod()")),
              ElevatedButton(
                  onPressed: () => _blePlugin.setMaxHeartRate(50, true),
                  child: const Text("setMaxHeartRate()")),
              ElevatedButton(
                  onPressed: () => _blePlugin.queryMaxHeartRate,
                  child: const Text("queryMaxHeartRate()")),
              ElevatedButton(
                  onPressed: () => _blePlugin.startMovement(10),
                  child: const Text("startMovement()")),
              ElevatedButton(
                  onPressed: () => _blePlugin.setMovementState(MovementHeartRateStateType.MOVEMENT_COMPLETE),
                  child: const Text("setMaxHeartRate(-1)")),
              ElevatedButton(
                  onPressed: () => _blePlugin.setMovementState(MovementHeartRateStateType.MOVEMENT_CONTINUE),
                  child: const Text("setMaxHeartRate(-2)")),
              ElevatedButton(
                  onPressed: () => _blePlugin.setMovementState(MovementHeartRateStateType.MOVEMENT_PAUSE),
                  child: const Text("setMaxHeartRate(-3)")),
              ElevatedButton(
                  onPressed: () => _blePlugin.getProtocolVersion,
                  child: const Text("getProtocolVersion()")),
              // 2.40
              ElevatedButton(
                  onPressed: () => _blePlugin.startMeasureTemp,
                  child: const Text("startMeasureTemp()")),
              ElevatedButton(
                  onPressed: () => _blePlugin.stopMeasureTemp,
                  child: const Text("stopMeasureTemp()")),
              ElevatedButton(
                  onPressed: () => _blePlugin.enableTimingMeasureTemp,
                  child: const Text("enableTimingMeasureTemp()")),
              ElevatedButton(
                  onPressed: () => _blePlugin.disableTimingMeasureTemp,
                  child: const Text("disableTimingMeasureTemp()")),
              ElevatedButton(
                  onPressed: () => _blePlugin.queryTimingMeasureTempState,
                  child: const Text("queryTimingMeasureTempState()")),
              ElevatedButton(
                  onPressed: () => _blePlugin.queryTimingMeasureTemp(TempTimeType.YESTERDAY),
                  child: const Text("queryTimingMeasureTemp()")),
              ElevatedButton(
                  onPressed: () => _blePlugin.queryTimingMeasureTemp(TempTimeType.TODAY),
                  child: const Text("queryTimingMeasureTemp()")),
              ElevatedButton(
                  onPressed: () => _blePlugin.sendDisplayTime(20),
                  child: const Text("sendDisplayTime()")),
              ElevatedButton(
                  onPressed: () => _blePlugin.queryDisplayTime,
                  child: const Text("queryDisplayTime()")),
              ElevatedButton(
                  onPressed: () => _blePlugin.enableHandWashingReminder(HandWashingPeriodBean(
                    enable: true,
                    startHour: 1,
                    startMinute: 1,
                    count: 1,
                    period: 1,
                  )),
                  child: const Text("enableHandWashingReminder()")),
              ElevatedButton(
                  onPressed: () => _blePlugin.disableHandWashingReminder,
                  child: const Text("disableHandWashingReminder()")),
              ElevatedButton(
                  onPressed: () => _blePlugin.queryHandWashingReminderPeriod,
                  child: const Text("queryHandWashingReminderPeriod()")),
              ElevatedButton(
                  onPressed: () => _blePlugin.sendLocalCity("永州"),
                  child: const Text("sendLocalCity()")),
              ElevatedButton(
                  onPressed: () => _blePlugin.sendTempUnit(TempUnit.CELSIUS),
                  child: const Text("sendTempUnit()")),
              ElevatedButton(
                  onPressed: () => _blePlugin.sendTempUnit(TempUnit.FAHRENHEIT),
                  child: const Text("sendTempUnit()")),
              ElevatedButton(
                  onPressed: () => _blePlugin.queryTempUnit,
                  child: const Text("queryTempUnit()")),
              ElevatedButton(
                  onPressed: () => _blePlugin.sendBrightness(5),
                  child: const Text("sendBrightness(5)")),
              ElevatedButton(
                  onPressed: () => _blePlugin.queryBrightness,
                  child: const Text("queryBrightness()")),
              ElevatedButton(
                  onPressed: () => _blePlugin.queryBtAddress,
                  child: const Text("queryBtAddress()")),
              ElevatedButton(
                  onPressed: () => _blePlugin.checkSupportQuickContact,
                  child: const Text("checkSupportQuickContact()")),
              ElevatedButton(
                  onPressed: () => _blePlugin.queryContactCount,
                  child: const Text("queryContactCount()")),
              ElevatedButton(
                  onPressed: () => selectContact(),
                  child: Text(_contactStr)),
              ElevatedButton(
                  onPressed: () => _blePlugin.deleteContact(0),
                  child: const Text("deleteContact()")),
              // ElevatedButton(
              //     onPressed: () => _blePlugin.deleteContactAvatar(1),
              //     child: const Text("deleteContactAvatar()")),
              ElevatedButton(
                  onPressed: () => _blePlugin.sendBatterySaving(true),
                  child: const Text("sendBatterySaving(true)")),
              ElevatedButton(
                  onPressed: () => _blePlugin.sendBatterySaving(false),
                  child: const Text("sendBatterySaving(false)")),
              ElevatedButton(
                  onPressed: () => _blePlugin.queryBatterySaving,
                  child: const Text("queryBatterySaving()")),
              ElevatedButton(
                  onPressed: () => _blePlugin.queryPillReminder,
                  child: const Text("queryPillReminder()")),
              ElevatedButton(
                  onPressed: () => _blePlugin.sendPillReminder(PillReminderBean(
                      id: 1,
                      dateOffset: 1,
                      name: "name",
                      repeat: 1,
                      reminderTimeList: []
                  )),
                  child: const Text("sendPillReminder()")),
              ElevatedButton(
                  onPressed: () => _blePlugin.deletePillReminder(1),
                  child: const Text("deletePillReminder()")),
              ElevatedButton(
                  onPressed: () => _blePlugin.clearPillReminder,
                  child: const Text("clearPillReminder()")),
              ElevatedButton(
                  onPressed: () => _blePlugin.queryTapToWakeState,
                  child: const Text("queryTapToWakeState()")),
              ElevatedButton(
                  onPressed: () => _blePlugin.sendTapToWakeState(true),
                  child: const Text("sendTapToWakeState(true)")),
              ElevatedButton(
                  onPressed: () => _blePlugin.sendTapToWakeState(false),
                  child: const Text("sendTapToWakeState(false)")),
              ElevatedButton(
                  onPressed: () => _blePlugin.queryHistoryTraining,
                  child: const Text("queryHistoryTraining()")),
              ElevatedButton(
                  onPressed: () => _blePlugin.queryTraining(1),
                  child: const Text("queryTraining()")),
              const Text("李宝忠End"),
            ],
          ),
        ),
      ),
    );
  }

  String _contactStr = 'sendContact()';
  Future<void> selectContact() async {
    final Contact contact = await Navigator.push(context, MaterialPageRoute(
        builder: (context) => FlutterContactsExample(context),
      )
    );

    _blePlugin.sendContact(ContactBean(
      id: int.parse(contact.id),
      width: 100,
      height: 100,
      address: 1,
      name: contact.name.first,
      number: contact.phones.first.number,
      avatar: contact.thumbnail,
      timeout: 30,
    ));

    if (!mounted) return;

    setState(() {
      String name = contact.name.first;
      String number = contact.phones.first.number;
      _contactStr = '$name, $number';
    });
  }

}