import 'dart:math';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:moyoung_ble_plugin/moyoung_ble.dart';
import 'package:path_provider/path_provider.dart';

class Yusixia extends StatefulWidget {
  MoYoungBle blePlugin;

  Yusixia({
    Key? key,
    required this.blePlugin,
  }) : super(key: key);

  @override
  State<Yusixia> createState() {
    return _YusixiaPage(blePlugin);
  }
}

class _YusixiaPage extends State<Yusixia> {
  final MoYoungBle _blePlugin;

  _YusixiaPage(this._blePlugin);
  WatchFaceLayoutBean? _crpWatchFaceLayoutInfo = null;
  String _firmwareVersion = "未获取";
  SupportWatchFaceBean? _crpSupportWatchFaceInfo = null;
  List<WatchFaceBean> _watchFacelist = [];
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("余思霞"),
        ),
        body: Center(
          child: ListView(
            children: <Widget>[
              //余诗霞:start
              ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("返回")),
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
                  child: const Text('sendQuickView(true)'),
                  onPressed: () => _blePlugin.sendQuickView(true)),
              ElevatedButton(
                  child: const Text('sendQuickView(false)'),
                  onPressed: () => _blePlugin.sendQuickView(false)),
              ElevatedButton(
                  child: const Text('queryQuickView()'),
                  onPressed: () => _blePlugin.queryQuickView),
              ElevatedButton(
                  child: const Text(
                      'sendQuickViewTime(CrpPeriodTimeInfo(0,0,0,0)'),
                  onPressed: () => _blePlugin.sendQuickViewTime(
                      PeriodTimeBean(
                          endHour: 0,
                          endMinute: 0,
                          startHour: 0,
                          startMinute: 0))),
              ElevatedButton(
                  child: const Text('queryQuickViewTime()'),
                  onPressed: () => _blePlugin.queryQuickViewTime),
              ElevatedButton(
                  child: const Text('sendGoalSteps(5000)'),
                  onPressed: () => _blePlugin.sendGoalSteps(5000)),
              ElevatedButton(
                  child: const Text('queryGoalStep()'),
                  onPressed: () => _blePlugin.queryGoalStep),
              const Text("表盘"),
              ElevatedButton(
                  child: const Text('sendDisplayWatchFace(FIRST_WATCH_FACE)'),
                  onPressed: () => _blePlugin
                      .sendDisplayWatchFace(WatchFaceType.FIRST_WATCH_FACE)),
              ElevatedButton(
                  child: const Text('sendDisplayWatchFace(SECOND_WATCH_FACE)'),
                  onPressed: () => _blePlugin
                      .sendDisplayWatchFace(WatchFaceType.SECOND_WATCH_FACE)),
              ElevatedButton(
                  child: const Text('sendDisplayWatchFace(THIRD_WATCH_FACE)'),
                  onPressed: () => _blePlugin
                      .sendDisplayWatchFace(WatchFaceType.THIRD_WATCH_FACE)),
              ElevatedButton(
                  child: const Text('sendDisplayWatchFace(NEW_CUSTOMIZE_WATCH_FACE)'),
                  onPressed: () => _blePlugin
                      .sendDisplayWatchFace(WatchFaceType.NEW_CUSTOMIZE_WATCH_FACE)),
              ElevatedButton(
                  child: const Text('queryDisplayWatchFace()'),
                  onPressed: () => _blePlugin.queryDisplayWatchFace),
              ElevatedButton(
                  child: const Text('queryWatchFaceLayout()'),
                  onPressed: () async => _crpWatchFaceLayoutInfo = await _blePlugin.queryWatchFaceLayout),
              ElevatedButton(
                  child: const Text(
                      'sendWatchFaceLayout(CrpWatchFaceLayoutInfo(2)'),
                  onPressed: () => {
                    if(_crpWatchFaceLayoutInfo != null) {
                      _blePlugin.sendWatchFaceLayout(_crpWatchFaceLayoutInfo!)}
                  }),
              ElevatedButton(
                  child: const Text('sendWatchFaceBackground()'),
                  onPressed: () => {
                    if(_crpWatchFaceLayoutInfo != null) {
                      sendWatchFaceBackground()
                    }
                  }),
              ElevatedButton(
                  child: const Text('querySupportWatchFace()'),
                  onPressed: () async => _crpSupportWatchFaceInfo = await _blePlugin.querySupportWatchFace),
              ElevatedButton(
                  child: Text(_firmwareVersion),
                  onPressed: queryFrimwareVersion),
              ElevatedButton(
                  child: const Text('queryWatchFaceStore()'),
                  onPressed: () async => {
                    if(_firmwareVersion != "未获取" && _crpSupportWatchFaceInfo != null) {
                      _watchFacelist = await _blePlugin.queryWatchFaceStore(
                      WatchFaceStoreBean(
                          watchFaceSupportList: _crpSupportWatchFaceInfo!.supportWatchFaceList,
                          firmwareVersion: _firmwareVersion,
                          pageCount: 9,
                          pageIndex: 1)),
                    }}),
              ElevatedButton(
                  child: const Text('queryWatchFaceOfID()'),
                  onPressed: () => {
                    if(_watchFacelist.isNotEmpty) {
                      print(_watchFacelist[0].id),
                      _blePlugin.queryWatchFaceOfID(_watchFacelist[0].id)
                    }
                  }),
              ElevatedButton(
                  child: const Text('sendWatchFace(_watchFacelist)'),
                  onPressed: () => sendWatchFace(_watchFacelist[0])),
              ElevatedButton(
                  child: const Text('sendAlarmClock()'),
                  onPressed: () => _blePlugin.sendAlarmClock(AlarmClockBean(
                      enable: true,
                      hour: 0,
                      id: AlarmClockBean.firstClock,
                      minute: 0,
                      repeatMode: AlarmClockBean.everyday))),
              ElevatedButton(
                  child: const Text('queryAllAlarmClock()'),
                  onPressed: () => _blePlugin.queryAllAlarmClock),
              //2.16-2.20许蕾完成
              const Text("心率"),
              ElevatedButton(
                  child: const Text('queryLastDynamicRate()'),
                  onPressed: () => _blePlugin.queryLastDynamicRate(HistoryDynamicRateType.FIRST_HEART_RATE)),
              ElevatedButton(
                  child: const Text('queryLastDynamicRate()'),
                  onPressed: () => _blePlugin.queryLastDynamicRate(HistoryDynamicRateType.SECOND_HEART_RATE)),
              ElevatedButton(
                  child: const Text('queryLastDynamicRate()'),
                  onPressed: () => _blePlugin.queryLastDynamicRate(HistoryDynamicRateType.THIRD_HEART_RATE)),
              ElevatedButton(
                  child: const Text('enableTimingMeasureHeartRate(10)'),
                  onPressed: () => _blePlugin.enableTimingMeasureHeartRate(10)),
              ElevatedButton(
                  child: const Text('disableTimingMeasureHeartRate()'),
                  onPressed: () => _blePlugin.disableTimingMeasureHeartRate),
              ElevatedButton(
                  child: const Text('queryTimingMeasureHeartRate()'),
                  onPressed: () => _blePlugin.queryTimingMeasureHeartRate),
              ElevatedButton(
                  child: const Text(
                      'queryTodayHeartRate(TIMING_MEASURE_HEART_RATE)'),
                  onPressed: () => _blePlugin.queryTodayHeartRate(
                      TodayHeartRateType.TIMING_MEASURE_HEART_RATE)),
              ElevatedButton(
                  child: const Text('queryTodayHeartRate(ALL_DAY_HEART_RATE)'),
                  onPressed: () => _blePlugin.queryTodayHeartRate(
                      TodayHeartRateType.ALL_DAY_HEART_RATE)),
              ElevatedButton(
                  child: const Text('queryPastHeartRate'),
                  onPressed: () => _blePlugin.queryPastHeartRate),
              ElevatedButton(
                  child: const Text('queryMovementHeartRate'),
                  onPressed: () => _blePlugin.queryMovementHeartRate),
              ElevatedButton(
                  child: const Text('startMeasureOnceHeartRate'),
                  onPressed: () => _blePlugin.startMeasureOnceHeartRate),
              ElevatedButton(
                  child: const Text('stopMeasureOnceHeartRate'),
                  onPressed: () => _blePlugin.stopMeasureOnceHeartRate),
              ElevatedButton(
                  child: const Text('queryHistoryHeartRate'),
                  onPressed: () => _blePlugin.queryHistoryHeartRate),
              //心率到这里结束
              const Text("血压"),
              ElevatedButton(
                  child: const Text('startMeasureBloodPressure'),
                  onPressed: () => _blePlugin.startMeasureBloodPressure),
              ElevatedButton(
                  child: const Text('stopMeasureBloodPressure'),
                  onPressed: () => _blePlugin.stopMeasureBloodPressure),
              ElevatedButton(
                  child: const Text('enableContinueBloodPressure'),
                  onPressed: () => _blePlugin.enableContinueBloodPressure),
              ElevatedButton(
                  child: const Text('disableContinueBloodPressure'),
                  onPressed: () => _blePlugin.disableContinueBloodPressure),
              ElevatedButton(
                  child: const Text('queryContinueBloodPressureState'),
                  onPressed: () => _blePlugin.queryContinueBloodPressureState),
              ElevatedButton(
                  child: const Text('queryLast24HourBloodPressure'),
                  onPressed: () => _blePlugin.queryLast24HourBloodPressure),
              ElevatedButton(
                  child: const Text('queryHistoryBloodPressure'),
                  onPressed: () => _blePlugin.queryHistoryBloodPressure),
              //血氧
              const Text("血氧"),
              ElevatedButton(
                  child: const Text('startMeasureBloodOxygen'),
                  onPressed: () => _blePlugin.startMeasureBloodOxygen),
              ElevatedButton(
                  child: const Text('stopMeasureBloodOxygen'),
                  onPressed: () => _blePlugin.stopMeasureBloodOxygen),
              ElevatedButton(
                  child: const Text('enableTimingMeasureBloodOxygen(1)'),
                  onPressed: () =>
                      _blePlugin.enableTimingMeasureBloodOxygen(1)),
              ElevatedButton(
                  child: const Text('disableTimingMeasureBloodOxygen'),
                  onPressed: () => _blePlugin.disableTimingMeasureBloodOxygen),
              ElevatedButton(
                  child: const Text('queryTimingBloodOxygenMeasureState'),
                  onPressed: () =>
                      _blePlugin.queryTimingBloodOxygenMeasureState),
              ElevatedButton(
                  child: const Text('queryTimingBloodOxygen(CRPBloodOxygenTimeType)'),
                  onPressed: () => _blePlugin.queryTimingBloodOxygen(BloodOxygenTimeType.TODAY)),
              ElevatedButton(
                  child: const Text('queryTimingBloodOxygen(CRPBloodOxygenTimeType)'),
                  onPressed: () => _blePlugin.queryTimingBloodOxygen(BloodOxygenTimeType.YESTERDAY)),
              ElevatedButton(
                  child: const Text('enableContinueBloodOxygen'),
                  onPressed: () => _blePlugin.enableContinueBloodOxygen),
              ElevatedButton(
                  child: const Text('disableContinueBloodOxygen'),
                  onPressed: () => _blePlugin.disableContinueBloodOxygen),
              ElevatedButton(
                  child: const Text('queryContinueBloodOxygenState'),
                  onPressed: () => _blePlugin.queryContinueBloodOxygenState),
              ElevatedButton(
                  child: const Text('queryLast24HourBloodOxygen'),
                  onPressed: () => _blePlugin.queryLast24HourBloodOxygen),
              ElevatedButton(
                  child: const Text('queryHistoryBloodOxygen'),
                  onPressed: () => _blePlugin.queryHistoryBloodOxygen),
              //拍照
              ElevatedButton(
                  child: const Text('enterCameraView'),
                  onPressed: () => _blePlugin.enterCameraView),
              ElevatedButton(
                  child: const Text('exitCameraView'),
                  onPressed: () => _blePlugin.exitCameraView),
              //rssi
              ElevatedButton(
                  child: const Text('readDeviceRssi'),
                  onPressed: () => _blePlugin.readDeviceRssi),
              //egc
              const Text("EGC"),
              ElevatedButton(
                  child: const Text('setECGChangeListener()'),
                  onPressed: () => _blePlugin.setECGChangeListener(EcgMeasureType.TI)),
              ElevatedButton(
                  child: const Text('startECGMeasure'),
                  onPressed: () => _blePlugin.startECGMeasure),
              ElevatedButton(
                  child: const Text('stopECGMeasure'),
                  onPressed: () => _blePlugin.stopECGMeasure),
              ElevatedButton(
                  child: const Text('isNewECGMeasurementVersion'),
                  onPressed: () => _blePlugin.isNewECGMeasurementVersion),
              ElevatedButton(
                  child: const Text('queryLastMeasureECGData'),
                  onPressed: () => _blePlugin.queryLastMeasureECGData),
              ElevatedButton(
                  child: const Text('sendECGHeartRate'),
                  onPressed: () => _blePlugin.sendECGHeartRate(78)),
              //余诗霞:end
            ],
          ),
        ),
      ),
    );
  }

  sendWatchFaceBackground() async {
    String filePath = "assets/images/text.png";
    ByteData bytes = await rootBundle.load(filePath);
    Uint8List logoUint8List = bytes.buffer.asUint8List();

    WatchFaceBackgroundBean bgBean=WatchFaceBackgroundBean(
      bitmap: logoUint8List,
      thumbBitmap: logoUint8List,
      type:_crpWatchFaceLayoutInfo!.compressionType,
      width: _crpWatchFaceLayoutInfo!.width,
      height: _crpWatchFaceLayoutInfo!.height,
      thumbWidth: _crpWatchFaceLayoutInfo!.thumWidth,
      thumbHeight: _crpWatchFaceLayoutInfo!.thumHeight,
    );
    _blePlugin.sendWatchFaceBackground(bgBean);
  }

  Future<void> queryFrimwareVersion() async {
    String firmwareVersion = await _blePlugin.queryFirmwareVersion;
    if (!mounted) return;
    setState(() {
      _firmwareVersion = firmwareVersion;
    });
  }

  sendWatchFace(WatchFaceBean watchFaceBean) async {
    //Download the file and save
    int index= watchFaceBean.file.lastIndexOf('/');
    String name=watchFaceBean.file.substring(index,watchFaceBean.file.length);
    String pathFile = "";
    await getExternalStorageDirectories().then((value) => value == null
        ? "./"
        : (value.map((e) => pathFile = e.path + name))
        .toString());

    BaseOptions options = BaseOptions(
      baseUrl: watchFaceBean.file,
      connectTimeout: 5000,
      receiveTimeout: 3000,
    );
    Dio dio = Dio(options);
    Response response = await dio.download(watchFaceBean.file, pathFile);

    //call native interface
    CustomizeWatchFaceBean info = CustomizeWatchFaceBean(
        index: watchFaceBean.id, file: pathFile);
    await _blePlugin.sendWatchFace(info,30);
  }
}
