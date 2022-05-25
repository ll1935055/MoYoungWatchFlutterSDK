import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:moyoung_ble_plugin/impl/channel_names.dart';
import 'package:moyoung_ble_plugin/impl/moyoung_beans.dart';


import 'event_streams.dart';

class MoyoungBleImpl {
  static final MoyoungBleImpl _instance = MoyoungBleImpl();

  /// The default instance of [MoyoungBleImpl] to use.
  ///
  /// Defaults to [MoyoungBleImpl].
  static MoyoungBleImpl get instance => _instance;

  MethodChannel mBleScanMethodChannel =
      const MethodChannel(ChannelNames.METHOD_CHL_BLE_SCAN);
  MethodChannel mConnMethodChannel =
      const MethodChannel(ChannelNames.METHOD_CHL_CONN);

  Logger logger = Logger();

  final _bleEveChannels = MYEventStreams();

  Future<bool> get startScan async {
    return await mBleScanMethodChannel.invokeMethod('startScan');
  }
  Future<bool> startScanWithPeriod(int scanPeriod) async {
    return await mBleScanMethodChannel.invokeMethod('startScanWithPeriod',<String, int>{"scanPeriod": scanPeriod});
  }

  Future<String> get cancelScan async {
    return await mBleScanMethodChannel.invokeMethod('cancelScan');
  }

  Future<bool> isConnected(String address) async {
    bool isConnected = await mConnMethodChannel
        .invokeMethod('isConnected', <String, String>{"address": address});
    logger.d('isConnected=' + isConnected.toString());
    return isConnected;
  }

  Future<int> connect(String address) async {
    return await mConnMethodChannel
        .invokeMethod('connect', <String, String>{"address": address});
  }

  Future<bool> disconnect() async {
    bool isSuccess = await mConnMethodChannel.invokeMethod('disconnect');
    logger.d('isSuccess=' + isSuccess.toString());
    return isSuccess;
  }

  Future<void> get syncTime async {
    return await mConnMethodChannel.invokeMethod('syncTime');
  }

  Future<void> sendTimeSystem(int timeSystemType) async {
    return await mConnMethodChannel.invokeMethod(
        'sendTimeSystem', <String, int>{"timeSystemType": timeSystemType});
  }

  Future<int> get queryTimeSystem async {
    int time = await mConnMethodChannel.invokeMethod('queryTimeSystem');
    logger.d('queryTimeSystem=' + time.toString());
    return time;
  }

  Future<String> get queryFirmwareVersion async {
    return await mConnMethodChannel.invokeMethod('queryFirmwareVersion');
  }

  Future<void> get queryDeviceBattery async {
    return await mConnMethodChannel.invokeMethod('queryDeviceBattery');
  }

  Future<void> get subscribeDeviceBattery async {
    return await mConnMethodChannel.invokeMethod('subscribeDeviceBattery');
  }

  Future<CheckOtaBean> checkFirmwareVersion(String version,int otaType) async {
    String jsonStr =
        await mConnMethodChannel.invokeMethod('checkFirmwareVersion', <String, Object>{"version": version,"OTAType":otaType});
    return checkOtaBeanFromJson(jsonStr);
  }

  Future<void> sendUserInfo(UserBean userInfo) async {
    String jsonStr = userBeanToJson(userInfo);
    return await mConnMethodChannel
        .invokeMethod('sendUserInfo', <String, String>{"userInfo": jsonStr});
  }

  Future<void> sendStepLength(int stepLength) async {
    return await mConnMethodChannel.invokeMethod(
        'sendStepLength', <String, int>{"stepLength": stepLength});
  }

  Future<void> sendTodayWeather(TodayWeatherBean todayWeatherInfo) async {
    String jsonStr = todayWeatherBeanToJson(todayWeatherInfo);
    return await mConnMethodChannel.invokeMethod(
        'sendTodayWeather', <String, String>{"todayWeatherInfo": jsonStr});
  }

  Future<void> sendFutureWeather(TodayWeatherBean todayWeatherInfo) async {
    String jsonStr = todayWeatherBeanToJson(todayWeatherInfo);
    return await mConnMethodChannel.invokeMethod(
        'sendFutureWeather', <String, String>{"futureWeatherInfo": jsonStr});
  }

  Stream<BleScanBean> get bleScanEveStm {
    return _bleEveChannels.bleScanEveStm;
  }

  Stream<int> get connStateEveStm {
    return _bleEveChannels.connStateEveStm;
  }

  Stream<StepChangeBean> get stepChangeEveStm {
    return _bleEveChannels.stepChangeEveStm;
  }

  //余诗霞补充
  Stream<Map<dynamic, dynamic>> get deviceBatteryEveStm {
    return _bleEveChannels.deviceBatteryEveStm;
  }

  Stream<Map<dynamic, dynamic>> get weatherChangeEveStm {
    return _bleEveChannels.weatherChangeEveStm;
  }

  Future<void> get syncStep async {
    await mConnMethodChannel.invokeMethod('syncStep');
  }

  Future<void> syncPastStep(int crpPastTimeType) async {
    await mConnMethodChannel.invokeMethod(
        'syncPastStep', <String, int>{"pastTimeType": crpPastTimeType});
  }

  Future<void> queryStepsCategory(int crpStepsCategoryDateType) async {
    await mConnMethodChannel.invokeMethod('queryStepsCategory',
        <String, int>{"stepsCategoryDateType": crpStepsCategoryDateType});
  }

  Stream<StepsCategoryBean> get stepsCategoryEveStm {
    return _bleEveChannels.stepsCategoryEveStm;
  }

  Stream<SleepBean> get sleepChangeEveStm {
    return _bleEveChannels.sleepChangeEveStm;
  }

  Future<void> get syncSleep async {
    await mConnMethodChannel.invokeMethod('syncSleep');
  }

  Future<void> get syncRemSleep async {
    await mConnMethodChannel.invokeMethod('syncRemSleep');
  }

  Future<void> syncPastSleep(int pastTimeType) async {
    await mConnMethodChannel.invokeMethod(
        'syncPastSleep', <String, int>{"pastTimeType": pastTimeType});
  }

  // Future<void> syncPastRemSleep(int timeType) async {
  //   await mConnMethodChannel.invokeMethod('syncPastRemSleep', <String, int>{"timeType": timeType});
  // }
  Stream<Map<dynamic,dynamic>> get firmwareUpgradeEveStm {
    return _bleEveChannels.connFirmwareUpgradeEveStm;
  }

  //固件升级start
  Future<void> firmwareUpgradeByHsDfu(String address) async {
    await mConnMethodChannel.invokeMethod('firmwareUpgradeByHsDfu', <String, String>{"address": address});
  }

  Future<void> firmwareUpgradeByRtkDfu(String address) async {
    await mConnMethodChannel
        .invokeMethod('firmwareUpgradeByRtkDfu', <String, String>{"address": address});
  }

  Future<void> firmwareUpgrade(bool firmwareUpgradeFlag) async {
    await mConnMethodChannel
        .invokeMethod('firmwareUpgrade', <String, bool>{"firmwareUpgradeFlag": firmwareUpgradeFlag});
  }

  Future<void> firmwareAbortByHsDfu() async {
    await mConnMethodChannel.invokeMethod('firmwareAbortByHsDfu');
  }

  Future<void> firmwareAbortByRtkDfu() async {
    await mConnMethodChannel.invokeMethod('firmwareAbortByRtkDfu');
  }

  Future<void> firmwareAbort() async {
    await mConnMethodChannel.invokeMethod('firmwareAbort');
  }

  //固件升级end

  Future<int> get queryDeviceDfuStatus async {
    int deviceDfuStatus =
        await mConnMethodChannel.invokeMethod('queryDeviceDfuStatus');
    logger.d('queryDeviceDfuStatus=', deviceDfuStatus.toString());
    return deviceDfuStatus;
  }

  Future<int> get queryHsDfuAddress async {
    int address = await mConnMethodChannel.invokeMethod('queryHsDfuAddress');
    logger.d('queryHsDfuAddress=' + address.toString());
    return address;
  }

  Future<void> get enableHsDfu async {
    await mConnMethodChannel.invokeMethod('enableHsDfu');
  }

  Future<int> get queryDfuType async {
    int type = await mConnMethodChannel.invokeMethod('queryDfuType');
    logger.d('queryDfuType=' + type.toString());
    return type;
  }

  //余诗霞:start
  Future<int> get queryMetricSystem async {
    int metricSystem =
        await mConnMethodChannel.invokeMethod('queryMetricSystem');
    logger.d('queryMetricSystem=' + metricSystem.toString());
    return metricSystem;
  }

  Future<void> sendMetricSystem(int metricSystemType) async {
    await mConnMethodChannel.invokeMethod('sendMetricSystem',
        <String, int>{"metricSystemType": metricSystemType});
  }

  Future<void> sendQuickView(bool quickViewState) async {
    await mConnMethodChannel.invokeMethod(
        'sendQuickView', <String, bool>{"quickViewState": quickViewState});
  }

  Future<bool> get queryQuickView async {
    bool quickViewState =
        await mConnMethodChannel.invokeMethod('queryQuickView');
    logger.d('queryQuickView=' + quickViewState.toString());
    return quickViewState;
  }

  Future<void> sendQuickViewTime(PeriodTimeBean crpPeriodTimeInfo) async {
    String jsonStr = periodTimeBeanToJson(crpPeriodTimeInfo);
    await mConnMethodChannel.invokeMethod(
        'sendQuickViewTime', <String, String>{"periodTimeInfo": jsonStr});
  }

  Future<PeriodTimeResultBean> get queryQuickViewTime async {
    String  jsonStr =
        await mConnMethodChannel.invokeMethod('queryQuickViewTime');
    PeriodTimeResultBean quickViewTime = periodTimeResultBeanFromJson(jsonStr);
    logger.d('queryQuickViewTime=' + quickViewTime.toString());
    return quickViewTime;
  }

  Future<void> sendGoalSteps(int goalSteps) async {
    await mConnMethodChannel
        .invokeMethod('sendGoalSteps', <String, int>{"goalSteps": goalSteps});
  }

  Future<int> get queryGoalStep async {
    int goalSteps = await mConnMethodChannel.invokeMethod('queryGoalStep');
    logger.d('queryGoalStep=' + goalSteps.toString());
    return goalSteps;
  }

  Future<void> sendDisplayWatchFace(int watchFaceType) async {
    await mConnMethodChannel.invokeMethod(
        'sendDisplayWatchFace', <String, int>{"watchFaceType": watchFaceType});
  }

  Future<int> get queryDisplayWatchFace async {
    int watchFaceType =
        await mConnMethodChannel.invokeMethod('queryDisplayWatchFace');
    logger.d('queryDisplayWatchFace=' + watchFaceType.toString());
    return watchFaceType;
  }

  Future<WatchFaceLayoutBean> get queryWatchFaceLayout async {
    String jsonStr = await mConnMethodChannel.invokeMethod('queryWatchFaceLayout');
    WatchFaceLayoutBean crpWatchFaceLayoutInfo =
        watchFaceLayoutBeanFromJson(jsonStr);
    logger.d('queryWatchFaceLayout=' + jsonStr);
    return crpWatchFaceLayoutInfo;
  }

  Future<void> sendWatchFaceLayout(
      WatchFaceLayoutBean crpWatchFaceLayoutInfo) async {
    String jsonStr = watchFaceLayoutBeanToJson(crpWatchFaceLayoutInfo);
    await mConnMethodChannel.invokeMethod('sendWatchFaceLayout',
        <String, String>{"watchFaceLayoutInfo": jsonStr});
  }

  Future<Map<dynamic, dynamic>> sendWatchFaceBackground(
      WatchFaceBackgroundBean watchFaceBackgroundInfo) async {
    String jsonStr = watchFaceBackgroundBeanToJson(watchFaceBackgroundInfo);
    Map<dynamic, dynamic> result = await mConnMethodChannel.invokeMethod(
        'sendWatchFaceBackground',
        <String, String>{"watchFaceBackgroundInfo": jsonStr});
    return result;
  }

  Stream<Map<dynamic, dynamic>> get lazyFileTransEveStm {
    return _bleEveChannels.connLazyFileTransEveStm;
  }

  Future<SupportWatchFaceBean> get querySupportWatchFace async {
    String jsonStr =
        await mConnMethodChannel.invokeMethod('querySupportWatchFace');
    SupportWatchFaceBean supportWatchFaceInfo =
        supportWatchFaceBeanFromJson(jsonStr);
    logger.d("querySupportWatchFace=" + jsonStr);
    return supportWatchFaceInfo;
  }

  Future<List<WatchFaceBean>> queryWatchFaceStore(
      WatchFaceStoreBean watchFaceStoreBean) async {
    String jsonStr = watchFaceStoreBeanToJson(watchFaceStoreBean);
    logger.d(jsonStr);
   String str = await mConnMethodChannel.invokeMethod(
        'queryWatchFaceStore', <String, String>{"watchFaceStoreBean": jsonStr});
    WatchFaceStoreListBean watchFaceStore = watchFaceStoreListBeanFromJson(str);
    WatchFaceStore watchFaceInfo =watchFaceStore.watchFaceStore;
    logger.d(watchFaceInfo.list[0]);
    return watchFaceInfo.list;
  }

  Future<WatchFaceIdBean> queryWatchFaceOfID(int id) async {
    String jsonStr = await mConnMethodChannel
        .invokeMethod('queryWatchFaceOfID', <String, int>{"id": id});
    WatchFaceIdBean? watchFaceId = watchFaceIdBeanFromJson(jsonStr);
    logger.d("queryWatchFaceOfID=" + watchFaceId.toString());
    return watchFaceId;
  }

  Future<Map<dynamic, dynamic>> sendWatchFace(
       customizeWatchFaceInfo, int timeout) async {
    String jsonStr = customizeWatchFaceBeanToJson(customizeWatchFaceInfo);
    Map<dynamic, dynamic> result = await mConnMethodChannel.invokeMethod(
        'sendWatchFace',
        <String, Object>{"watchFaceFlutterBean": jsonStr, "timeout": timeout});
    return result;
  }

  Stream<WfFileTransLazyBean> get lazyWFFileTransEveStm {
    return _bleEveChannels.connLazyWFFileTransEveStm;
  }

  Future<void> sendAlarmClock(AlarmClockBean crpAlarmClockInfo) async {
    String jsonStr = alarmClockBeanToJson(crpAlarmClockInfo);
    await mConnMethodChannel.invokeMethod(
        'sendAlarmClock', <String, String>{"alarmClockInfo": jsonStr});
  }

  Future<List<AlarmClockBean>> get queryAllAlarmClock async {
    String jsonStr =
        await mConnMethodChannel.invokeMethod('queryAllAlarmClock');
    var listDynamic = jsonDecode(jsonStr);
    List<AlarmClockBean> listStr = (listDynamic as List<dynamic>)
        .map((e) => AlarmClockBean.fromJson((e as Map<String, dynamic>)))
        .toList();

    logger.d('queryAllAlarmClock=' + jsonStr);
    return listStr;
  }

  //心率
  Stream<HeartRateBean> get heartRateEveStm {
    return _bleEveChannels.connHeartRateEveStm;
  }

  Future<void> queryLastDynamicRate(String type) async {
    await mConnMethodChannel.invokeMethod('queryLastDynamicRate', <String, String>{"type": type});
  }

  Future<void> enableTimingMeasureHeartRate(int interval) async {
    await mConnMethodChannel.invokeMethod(
        'enableTimingMeasureHeartRate', <String, int>{"interval": interval});
  }

  Future<void> get disableTimingMeasureHeartRate async {
    await mConnMethodChannel.invokeMethod('disableTimingMeasureHeartRate');
  }

  Future<int> get queryTimingMeasureHeartRate async {
    int timeHR =
        await mConnMethodChannel.invokeMethod('queryTimingMeasureHeartRate');
    logger.d('queryTimingMeasureHeartRate=' + timeHR.toString());
    return timeHR;
  }

  Future<void> queryTodayHeartRate(int heartRateType) async {
    await mConnMethodChannel.invokeMethod(
        'queryTodayHeartRate', <String, int>{"heartRateType": heartRateType});
  }

  Future<void> get queryPastHeartRate async {
    await mConnMethodChannel.invokeMethod('queryPastHeartRate');
  }

  Future<void> get queryMovementHeartRate async {
    await mConnMethodChannel.invokeMethod('queryMovementHeartRate');
  }

  Future<void> get startMeasureOnceHeartRate async {
    await mConnMethodChannel.invokeMethod('startMeasureOnceHeartRate');
  }

  Future<void> get stopMeasureOnceHeartRate async {
    await mConnMethodChannel.invokeMethod('stopMeasureOnceHeartRate');
  }

  Future<void> get queryHistoryHeartRate async {
    await mConnMethodChannel.invokeMethod('queryHistoryHeartRate');
  }

  //血压
  Stream<BloodPressureBean> get bloodPressureEveStm {
    return _bleEveChannels.bloodPressureEveStm;
  }

  Future<void> get startMeasureBloodPressure async {
    await mConnMethodChannel.invokeMethod('startMeasureBloodPressure');
  }

  Future<void> get stopMeasureBloodPressure async {
    await mConnMethodChannel.invokeMethod('stopMeasureBloodPressure');
  }

  Future<void> get enableContinueBloodPressure async {
    await mConnMethodChannel.invokeMethod('enableContinueBloodPressure');
  }

  Future<void> get disableContinueBloodPressure async {
    await mConnMethodChannel.invokeMethod('disableContinueBloodPressure');
  }

  Future<void> get queryContinueBloodPressureState async {
    await mConnMethodChannel.invokeMethod('queryContinueBloodPressureState');
  }

  Future<void> get queryLast24HourBloodPressure async {
    await mConnMethodChannel.invokeMethod('queryLast24HourBloodPressure');
  }

  Future<void> get queryHistoryBloodPressure async {
    await mConnMethodChannel.invokeMethod('queryHistoryBloodPressure');
  }

  //血氧
  Stream<BloodOxygenBean> get bloodOxygenEveStm {
    return _bleEveChannels.connBloodOxygenEveStm;
  }

  Future<void> get startMeasureBloodOxygen async {
    await mConnMethodChannel.invokeMethod('startMeasureBloodOxygen');
  }

  Future<void> get stopMeasureBloodOxygen async {
    await mConnMethodChannel.invokeMethod('stopMeasureBloodOxygen');
  }

  Future<void> enableTimingMeasureBloodOxygen(int interval) async {
    await mConnMethodChannel.invokeMethod(
        'enableTimingMeasureBloodOxygen', <String, int>{"interval": interval});
  }

  Future<void> get disableTimingMeasureBloodOxygen async {
    await mConnMethodChannel.invokeMethod('disableTimingMeasureBloodOxygen');
  }

  Future<void> get queryTimingBloodOxygenMeasureState async {
    await mConnMethodChannel.invokeMethod('queryTimingBloodOxygenMeasureState');
  }

  Future<void> queryTimingBloodOxygen(String bloodOxygenTimeType) async {
    await mConnMethodChannel.invokeMethod('queryTimingBloodOxygen',<String, String>{"bloodOxygenTimeType": bloodOxygenTimeType});
  }

  Future<void> get enableContinueBloodOxygen async {
    await mConnMethodChannel.invokeMethod('enableContinueBloodOxygen');
  }

  Future<void> get disableContinueBloodOxygen async {
    await mConnMethodChannel.invokeMethod('disableContinueBloodOxygen');
  }

  Future<void> get queryContinueBloodOxygenState async {
    await mConnMethodChannel.invokeMethod('queryContinueBloodOxygenState');
  }

  Future<void> get queryLast24HourBloodOxygen async {
    await mConnMethodChannel.invokeMethod('queryLast24HourBloodOxygen');
  }

  Future<void> get queryHistoryBloodOxygen async {
    await mConnMethodChannel.invokeMethod('queryHistoryBloodOxygen');
  }

  //拍照
  Future<void> get enterCameraView async {
    await mConnMethodChannel.invokeMethod('enterCameraView');
  }

  Future<void> get exitCameraView async {
    await mConnMethodChannel.invokeMethod('exitCameraView');
  }

  Stream<String> get cameraEveStm {
    return _bleEveChannels.cameraEveStm;
  }

  //电话
  Stream<int> get phoneEveStm {
    return _bleEveChannels.phoneEveStm;
  }

  //rssi
  Stream<int> get deviceRssiEveStm {
    return _bleEveChannels.deviceRssiEveStm;
  }

  Future<void> get readDeviceRssi async {
    await mConnMethodChannel.invokeMethod('readDeviceRssi');
  }

  //egc
  Future<void> setECGChangeListener(String ecgMeasureType) async {
     await mConnMethodChannel.invokeMethod('setECGChangeListener',
        <String, String>{"ecgMeasureType": ecgMeasureType});
  }

  Stream<EgcBean> get lazyEgcEveStm {
    return _bleEveChannels.lazyEgcEveStm;
  }

  Future<void> get startECGMeasure async {
    await mConnMethodChannel.invokeMethod('startECGMeasure');
  }

  Future<void> get stopECGMeasure async {
    await mConnMethodChannel.invokeMethod('stopECGMeasure');
  }

  Future<bool> get isNewECGMeasurementVersion async {
    bool newMeasurementVersion=await mConnMethodChannel.invokeMethod('isNewECGMeasurementVersion');
    logger.d('isNewECGMeasurementVersion=' + newMeasurementVersion.toString());
    return newMeasurementVersion;
  }

  Future<void> get queryLastMeasureECGData async {
    await mConnMethodChannel.invokeMethod('queryLastMeasureECGData');
  }

  Future<void> sendECGHeartRate(int heartRate) async {
    await mConnMethodChannel.invokeMethod(
        'sendECGHeartRate', <String, int>{"heartRate": heartRate});
  }

  //以下流是李宝忠的
  Stream<Map<dynamic, dynamic>> get lazyContactAvatarEveStm {
    return _bleEveChannels.lazyContactAvatarEveStm;
  }

  //余诗霞:end
  //yushixia:end

//xulei:start
  //发送手表版本
  Future<void> sendDeviceLanguage(int language) async {
    await mConnMethodChannel.invokeMethod(
        'sendDeviceLanguage',<String, int>{"language": language});
  }

  Future<DeviceLanguageBean> get queryDeviceLanguage async {
    String jsonStr =  await mConnMethodChannel.invokeMethod('queryDeviceLanguage');
    DeviceLanguageBean deviceLanguage= deviceLanguageBeanFromJson(jsonStr);
    logger.d('queryDeviceLanguage=' + jsonStr);
    return deviceLanguage;
  }

  Future<void> sendOtherMessageState(bool messageState) async{
    await mConnMethodChannel.invokeMethod(
        'sendOtherMessageState',<String,bool>{"messageState":messageState});
  }

  Future<bool> get queryOtherMessageState async{
    bool messageState = await mConnMethodChannel.invokeMethod('queryOtherMessageState');
    logger.d('queryOtherMessageState=',messageState.toString());
    return messageState;
  }

  Future<void> sendMessage(MessageBean crpMessageInfo) async{
    String jsonStr = messageBeanToJson(crpMessageInfo);
    await mConnMethodChannel.invokeMethod(
        'sendMessage', <String, String>{"messageInfo": jsonStr});
  }

  Future<void> get sendCall0ffHook async{
    await mConnMethodChannel.invokeMethod('sendCall0ffHook');
  }
  // 久坐提醒
  Future<void> sendSedentaryReminder(bool sedentaryReminder) async{
    await mConnMethodChannel.invokeMethod('sendSedentaryReminder',
        <String,bool>{"sedentaryReminder":sedentaryReminder});
  }

  Future<bool> get querySedentaryReminder async{
    bool sedentaryReminder = await mConnMethodChannel.invokeMethod('querySedentaryReminder');
    logger.d('querySedentaryReminder=',sedentaryReminder.toString());
    return sedentaryReminder;
  }

  Future<void> sendSedentaryReminderPeriod(SedentaryReminderPeriodBean crpSedentaryReminderPeriodInfo) async{
    String jsonStr = sedentaryReminderPeriodBeanToJson(crpSedentaryReminderPeriodInfo);
    await mConnMethodChannel.invokeMethod(
        'sendSedentaryReminderPeriod', <String, String>{"crpSedentaryReminderPeriodInfo": jsonStr});
  }

  Future<SedentaryReminderPeriodBean> get querySedentaryReminderPeriod async {
    String jsonStr =
    await mConnMethodChannel.invokeMethod('querySedentaryReminderPeriod');
    SedentaryReminderPeriodBean crpSedentaryReminderPeriodInfo=sedentaryReminderPeriodBeanFromJson(jsonStr);
    logger.d('querySedentaryReminderPeriod=' + jsonStr);
    return crpSedentaryReminderPeriodInfo;
  }

  //寻找手表
  Future<void> get findDevice async{
    await mConnMethodChannel.invokeMethod('findDevice');
  }

  Future<void> get shutDown async{
    await mConnMethodChannel.invokeMethod('shutDown');
  }

  Future<PeriodTimeResultBean> get queryDoNotDisturbTime async{
    String jsonStr =  await mConnMethodChannel.invokeMethod('queryDoNotDisturbTime');
    PeriodTimeResultBean doNotDisturbTime = periodTimeResultBeanFromJson(jsonStr);
    logger.d("queryDoNotDisturbTime = " + doNotDisturbTime.toString());
    return doNotDisturbTime;
  }

  Future<void> sendDoNotDisturbTime(PeriodTimeBean crpPeriodTimeInfo) async{
    String jsonStr = periodTimeBeanToJson(crpPeriodTimeInfo);
    await mConnMethodChannel.invokeMethod(
        'sendDoNotDisturbTime', <String, String>{"crpPeriodTimeInfo": jsonStr});
  }

  Future<void> sendBreathingLight(bool breathingLight) async{
    await mConnMethodChannel.invokeMethod('sendBreathingLight',
        <String,bool>{"breathingLight":breathingLight});
  }

  Future<bool> get queryBreathingLight async{
    bool breathingLight = await mConnMethodChannel.invokeMethod('queryBreathingLight');
    logger.d('queryBreathingLight=',breathingLight.toString());
    return breathingLight;
  }
//xulei:end

  /// libaozhong: start
  /// 设置女生生理周期提醒
  Future<void> sendMenstrualCycle(PhysiologcalPeriodBean info) async {
    String jsonStr = physiologcalPeriodBeanToJson(info);
    await mConnMethodChannel.invokeMethod(
        "sendMenstrualCycle",
        <String, String>{ "futureWeatherInfo":jsonStr });
  }

  /// 获取女生生理周期提醒
  Future<String> get queryMenstrualCycle async {
    String resultJson =
        await mConnMethodChannel.invokeMethod("queryMenstrualCycle");
    logger.d(resultJson);
    return resultJson;
  }

  /// 开始找寻手机
  Future<void> get startFindPhone async {
    await mConnMethodChannel.invokeMethod("startFindPhone");
  }

  /// 结束找寻手机
  Future<void> get stopFindPhone async {
    await mConnMethodChannel.invokeMethod("stopFindPhone");
  }

  /// 2.35
  /// 设置播放器状态
  Future<void> setMusicPlayerState(int musicPlayer) async {
    await mConnMethodChannel.invokeMethod("setMusicPlayerState",
        <String, int>{"CRPMusicPlayerStateType": musicPlayer});
  }

  /// 设置歌的标题
  Future<void> sendSongTitle(String title) async {
    await mConnMethodChannel
        .invokeMethod("sendSongTitle", <String, String>{"title": title});
  }

  /// 设置歌词
  Future<void> sendLyrics(String lyrics) async {
    await mConnMethodChannel
        .invokeMethod("sendLyrics", <String, String>{"lyrics": lyrics});
  }

  /// 关闭音乐控制
  Future<void> get closeMusicControl async {
    await mConnMethodChannel.invokeMethod("closeMusicControl");
  }

  /// 设置当前音量
  Future<void> sendCurrentVolume(int volume) async {
    await mConnMethodChannel
        .invokeMethod("sendCurrentVolume", <String, int>{"volume": volume});
  }

  /// 设置最大音量
  Future<void> sendMaxVolume(int volume) async {
    await mConnMethodChannel
        .invokeMethod("sendMaxVolume", <String, int>{"volume": volume});
  }

  /// 2.36
  /// 喝水提醒
  Future<void> enableDrinkWaterReminder(DrinkWaterPeriodBean drinkWaterPeriodInfo) async {
    String jsonStr = drinkWaterPeriodBeanToJson(drinkWaterPeriodInfo);
    await mConnMethodChannel.invokeMethod('enableDrinkWaterReminder',
        <String, String>{"drinkWaterPeriodInfo": jsonStr});
  }

  /// 禁用水提醒
  Future<void> get disableDrinkWaterReminder async {
    await mConnMethodChannel.invokeMethod("disableDrinkWaterReminder");
  }

  /// 查询喝水提醒
  Future<DrinkWaterPeriodBean> get queryDrinkWaterReminderPeriod async {
     String jsonStr =  await mConnMethodChannel.invokeMethod("queryDrinkWaterReminderPeriod");
     logger.d(jsonStr);
     return drinkWaterPeriodBeanFromJson(jsonStr);
  }

  /// 2.37
  ///  设置心率告警值
  Future<void> setMaxHeartRate(int heartRate,bool enable) async {
    await mConnMethodChannel.invokeMethod("setMaxHeartRate", <String, dynamic>{"heartRate": heartRate, "enable": enable});
  }

  /// 查询心跳告警值
  Future<MaxHeartRateBean> get queryMaxHeartRate async {
    String jsonStr = await mConnMethodChannel.invokeMethod("queryMaxHeartRate");
    MaxHeartRateBean maxHeartRate = maxHeartRateBeanFromJson(jsonStr);
    logger.d(maxHeartRate);
    return maxHeartRate;
  }

  /// 开始锻炼
  Future<void> startMovement(int type) async {
    await mConnMethodChannel.invokeMethod("startMovement", <String, int>{"type": type});
  }

  /// 设置锻炼状态
  Future<void> setMovementState(int movement) async {
    await mConnMethodChannel.invokeMethod("setMovementState", <String, int>{"movement": movement});
  }

  /// 监听锻炼状态
  Stream<String> get movementStateEveStm {
    return _bleEveChannels.connMovementStateEveStm;
  }

  /// 获取协议版本
  Future<String> get getProtocolVersion async {
    String protocolVersion =  await mConnMethodChannel.invokeMethod("getProtocolVersion");
    logger.d(protocolVersion);
    return protocolVersion;
  }

  /// 开始测量第一次温度
  Future<void> get startMeasureTemp async {
    await mConnMethodChannel.invokeMethod("startMeasureTemp");
  }

  /// 温度一次停止测量
  Future<void> get stopMeasureTemp async {
    await mConnMethodChannel.invokeMethod("stopMeasureTemp");
  }

  /// 开启定时温度测量
  Future<void> get enableTimingMeasureTemp async {
    await mConnMethodChannel.invokeMethod("enableTimingMeasureTemp");
  }

  /// 禁用定时温度测量
  Future<void> get disableTimingMeasureTemp async {
    return await mConnMethodChannel.invokeMethod("disableTimingMeasureTemp");
  }

  /// 使用实例查询温度检测状态定时开关
  Future<String> get queryTimingMeasureTempState async {
    String tempState = await mConnMethodChannel.invokeMethod("queryTimingMeasureTempState");
    logger.d(tempState);
    return tempState;
  }

  /// 查询定时测温结果
  Future<void> queryTimingMeasureTemp(String tempTimeType) async {
    await mConnMethodChannel.invokeMethod("queryTimingMeasureTemp", <String, String>{ "tempTimeType":tempTimeType });
  }

  /// 设置温度测量结果监听器
  Stream<String> get tempChangeEveStm {
    return _bleEveChannels.tempChangeEveStm;
  }

  /// 设置显示的时间
  Future<void> sendDisplayTime(int time) async {
    await mConnMethodChannel.invokeMethod("sendDisplayTime", <String, int>{ "time":time });
  }

  /// 查询显示时间
  Future<int> get queryDisplayTime async {
    int time = await mConnMethodChannel.invokeMethod("queryDisplayTime");
    logger.d(time);
    return time;
  }

  /// 开启洗手提醒功能
  Future<void> enableHandWashingReminder(HandWashingPeriodBean handWashingPeriodInfo) async{
    String jsonStr = handWashingPeriodBeanToJson(handWashingPeriodInfo);
    await mConnMethodChannel.invokeMethod("enableHandWashingReminder",
        <String, String>{ "handWashingPeriodInfo":jsonStr });
  }

  /// 禁用洗手提醒
  Future<void> get disableHandWashingReminder async {
    await mConnMethodChannel.invokeMethod("disableHandWashingReminder");
  }

  /// 查询洗手提醒
  Future<HandWashingPeriodBean> get queryHandWashingReminderPeriod async {
    String period = await mConnMethodChannel.invokeMethod("queryHandWashingReminderPeriod");
    logger.d(period);
    return handWashingPeriodBeanFromJson(period);
  }

  /// 设置本地城市
  Future<void> sendLocalCity(String city) async {
    await mConnMethodChannel.invokeMethod("sendLocalCity",<String, String>{"city": city});
  }

  /// 切换手链的温度系统
  Future<void> sendTempUnit(int temp) async {
    await mConnMethodChannel.invokeMethod("sendTempUnit", <String, int>{"temp": temp});
  }

  /// 查询系统温度
  Future<void> get queryTempUnit async {
    await mConnMethodChannel.invokeMethod("queryTempUnit");
  }

  /// 设置亮度
  Future<void> sendBrightness(int brightness) async {
    await mConnMethodChannel.invokeMethod("sendBrightness", <String, int>{"brightness": brightness});
  }

  /// 获取亮度
  Future<BrightnessBean> get queryBrightness async{
    String jsonStr  = await mConnMethodChannel.invokeMethod("queryBrightness");
    BrightnessBean brightness = brightnessBeanFromJson(jsonStr);
    logger.d(brightness);
    return brightness;
  }

  /// 获取经典的蓝牙地址
  Future<String> get queryBtAddress async {
    String address = await mConnMethodChannel.invokeMethod("queryBtAddress");
    logger.d(address);
    return address;
  }

  /// 检查支持联系人
  Future<String> get checkSupportQuickContact async {
     String contactConfigInfo = await mConnMethodChannel.invokeMethod("checkSupportQuickContact");
     logger.d(contactConfigInfo);
     return contactConfigInfo;
  }

  /// 查询当前联系人数
  Future<int> get queryContactCount async {
    int count = await mConnMethodChannel.invokeMethod("queryContactCount");
    logger.d(count);
    return count;
  }

  /// 设置联系人侦听器
  Stream<Map<dynamic, dynamic>> get contactEveStm {
    return _bleEveChannels.contactEveStm;
  }

  /// 设置联系人
  Future<void> sendContact(ContactBean info) async {
    String jsonStr = contactBeanToJson(info);
    logger.d(jsonStr);
    await mConnMethodChannel.invokeMethod("sendContact",<String, String>{"contactBean": jsonStr});
  }

  /// 删除联系人
  Future<void> deleteContact(int id) async {
    await mConnMethodChannel.invokeMethod("deleteContact", <String, int>{"id": id});
  }

  /// 设置省电监听器
  Stream<bool> get batterySavingEveStm {
    return _bleEveChannels.batterySavingEveStm;
  }

  /// 设置省电状态
  Future<void> sendBatterySaving(bool enable) async {
    logger.d(enable);
    await mConnMethodChannel.invokeMethod("sendBatterySaving", <String, bool>{"enable": enable});
  }

  /// 获取省电状态
  Future<void> get queryBatterySaving async {
    await mConnMethodChannel.invokeMethod("queryBatterySaving");
  }

  /// 查询支持药丸提醒
  Future<String> get queryPillReminder async {
    String jsonStr = await mConnMethodChannel.invokeMethod("queryPillReminder");
    logger.d(jsonStr);
    return jsonStr;
  }

  /// 设置药丸提醒
  Future<void> sendPillReminder(PillReminderBean info) async {
    String jsonStr = pillReminderBeanToJson(info);
    await mConnMethodChannel.invokeMethod("sendPillReminder", <String, String>{"pillReminderInfo": jsonStr});
  }

  /// 删除药丸提醒
  Future<void> deletePillReminder(int id) async {
    await mConnMethodChannel.invokeMethod("deletePillReminder", <String, int>{"id": id});
  }

  /// 清除的药丸提醒
  Future<void> get clearPillReminder async {
    await mConnMethodChannel.invokeMethod("clearPillReminder");
  }

  /// 查询轻按，进入唤醒状态
  Future<bool> get queryTapToWakeState async {
    bool state = await mConnMethodChannel.invokeMethod("queryTapToWakeState");
    logger.d(state);
    return state;
  }

  /// 设置“轻按”为唤醒状态
  Future<void> sendTapToWakeState(bool enable) async {
    await mConnMethodChannel.invokeMethod("sendTapToWakeState", <String, bool>{"enable": enable});
  }

  /// 设置训练侦听器
  Stream<String> get trainingEveStm {
    return _bleEveChannels.trainingEveStm;
  }

  /// 查询历史训练
  Future<void> get queryHistoryTraining async {
    await mConnMethodChannel.invokeMethod("queryHistoryTraining");
  }

  /// 查询训练细节
  Future<void> queryTraining(int id) async {
    await mConnMethodChannel.invokeMethod("queryTraining", <String, int>{"id": id});
  }
  /// libaozhong: end
}
