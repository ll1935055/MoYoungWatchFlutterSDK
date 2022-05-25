import 'dart:async';

import 'package:moyoung_ble_plugin/impl/moyoung_beans.dart';
import 'package:moyoung_ble_plugin/impl/moyoung_ble_impl.dart';
// Export [moyoung_beans], [moyoung_contants] from the moyoung_ble
// so plugin users can use them directly.
export 'package:moyoung_ble_plugin/impl/moyoung_beans.dart';
export 'package:moyoung_ble_plugin/impl/moyoung_contants.dart';

class MoYoungBle {
  /// Constructs a singleton instance of [MoYoungBle].
  ///
  /// [MoYoungBle] is designed to work as a singleton.
  factory MoYoungBle() {
    _singleton ??= MoYoungBle._();
    return _singleton!;
  }

  MoYoungBle._();

  static MoYoungBle? _singleton;

  static MoyoungBleImpl get _platform {
    return MoyoungBleImpl.instance;
  }

  /// This method startScan
  Future<bool> get startScan {
    return _platform.startScan;
  }

  Future<bool> startScanWithPeriod(int scanPeriod) {
    return _platform.startScanWithPeriod(scanPeriod);
  }
  /// This method cancelScan
  Future<void> get cancelScan {
    return _platform.cancelScan;
  }

  /// This method isConnected
  Future<bool> isConnected(String address) {
    return _platform.isConnected(address);
  }

  /// This method connect
  Future<int> connect(String address) {
    return _platform.connect(address);
  }

  /// This method disconnect
  Future<bool> get disconnect {
    return _platform.disconnect();
  }

  Future<void> get syncTime {
    return _platform.syncTime;
  }

  Future<void> sendTimeSystem(int timeSystemType) {
    return _platform.sendTimeSystem(timeSystemType);
  }

  Future<int> get queryTimeSystem {
    return _platform.queryTimeSystem;
  }

  Future<String> get queryFirmwareVersion {
    return _platform.queryFirmwareVersion;
  }

  Future<void> get queryDeviceBattery {
    return _platform.queryDeviceBattery;
  }

  Future<void> get subscribeDeviceBattery{
    return  _platform.subscribeDeviceBattery;
  }

  Future<CheckOtaBean> checkFirmwareVersion(String version,int otaType) {
    return _platform.checkFirmwareVersion(version,otaType);
  }

  Future<void> sendUserInfo(UserBean userInfo) {

    return _platform.sendUserInfo(userInfo);
  }

  Future<void> sendStepLength(int stepLength) {
    return _platform.sendStepLength(stepLength);
  }

  Future<void> sendTodayWeather(TodayWeatherBean todayWeatherInfo) {
    return _platform.sendTodayWeather(todayWeatherInfo);
  }

  Future<void> sendFutureWeather(TodayWeatherBean todayWeatherInfo) {
    return _platform.sendFutureWeather(todayWeatherInfo);
  }

  Stream<BleScanBean> get bleScanEveStm {
    return _platform.bleScanEveStm;
  }

  Stream<int> get connStateEveStm {
    return _platform.connStateEveStm;
  }

  Stream<StepChangeBean> get stepChangeEveStm {
    return _platform.stepChangeEveStm;
  }

  //余诗霞补充
  Stream<Map<dynamic,dynamic>> get deviceBatteryEveStm {
    return _platform.deviceBatteryEveStm;
  }

  Stream<Map<dynamic,dynamic>> get weatherChangeEveStm {
    return _platform.weatherChangeEveStm;
  }
  Future<void> get syncStep  {
    return _platform.syncStep;
  }
  Future<void> syncPastStep(int crpPastTimeType)  {
    return _platform.syncPastStep(crpPastTimeType);
  }
  Future<void> queryStepsCategory(int crpStepsCategoryDateType)  {
    return _platform.queryStepsCategory(crpStepsCategoryDateType);
  }
  Stream<StepsCategoryBean> get stepsCategoryEveStm {
    return _platform.stepsCategoryEveStm;
  }
  Stream<SleepBean> get sleepChangeEveStm {
    return _platform.sleepChangeEveStm;
  }
  Future<void> get syncSleep  {
    return _platform.syncSleep;
  }
  Future<void> get syncRemSleep  {
    return _platform.syncRemSleep;
  }

  Future<void> syncPastSleep(int pastTimeType)  {
    return _platform.syncPastSleep(pastTimeType);
  }
  // Future<void> syncPastRemSleep(int timeType)  {
  //   return _platform.syncPastRemSleep(timeType);
  // }
  Stream<Map<dynamic,dynamic>> get firmwareUpgradeEveStm {
    return _platform.firmwareUpgradeEveStm;
  }

  //固件升级start
  Future<void> firmwareUpgradeByHsDfu(String address) {
    return _platform.firmwareUpgradeByHsDfu(address);
  }

  Future<void> firmwareUpgradeByRtkDfu(String address) {
    return _platform.firmwareUpgradeByRtkDfu(address);
  }

  Future<void> firmwareUpgrade(bool firmwareUpgradeFlag) {
    return _platform.firmwareUpgrade(firmwareUpgradeFlag);
  }

  Future<void> firmwareAbortByHsDfu() {
    return _platform.firmwareAbortByHsDfu();
  }

  Future<void> firmwareAbortByRtkDfu() {
    return _platform.firmwareAbortByRtkDfu();
  }

  Future<void> firmwareAbort() {
    return _platform.firmwareAbort();
  }

  //固件升级end

  Future<int> get queryDeviceDfuStatus {
    return _platform.queryDeviceDfuStatus;
  }

  Future<int> get queryHsDfuAddress  {
    return _platform.queryHsDfuAddress;
  }
  Future<void> get enableHsDfu  {
    return _platform.enableHsDfu;
  }
  Future<int> get queryDfuType {
    return _platform.queryDfuType;
  }



  //余诗霞:start
  Future<int> get queryMetricSystem  {
    return _platform.queryMetricSystem;
  }

  Future<void> sendMetricSystem(int metricSystemType) {
    return _platform.sendMetricSystem(metricSystemType);
  }

  Future<void> sendQuickView(bool quickViewState){
    return _platform.sendQuickView(quickViewState);
  }

  Future<bool> get queryQuickView{

    return _platform.queryQuickView;
  }

  Future<void> sendQuickViewTime(PeriodTimeBean crpPeriodTimeInfo){
    return _platform.sendQuickViewTime(crpPeriodTimeInfo);
  }

  Future<PeriodTimeResultBean> get queryQuickViewTime{
    return _platform.queryQuickViewTime;
  }

  Future<void> sendGoalSteps(int goalSteps){
    return _platform.sendGoalSteps(goalSteps);
  }

  Future<int> get queryGoalStep{
    return _platform.queryGoalStep;
  }

  Future<void> sendDisplayWatchFace(int watchFaceType){
    return _platform.sendDisplayWatchFace(watchFaceType);
  }

  Future<int> get queryDisplayWatchFace {
    return _platform.queryDisplayWatchFace;
  }

  Future<WatchFaceLayoutBean> get queryWatchFaceLayout {
    return _platform.queryWatchFaceLayout;
  }

  Future<void> sendWatchFaceLayout(
      WatchFaceLayoutBean crpWatchFaceLayoutInfo){

    return _platform.sendWatchFaceLayout(crpWatchFaceLayoutInfo);
  }

  Future<Map<dynamic, dynamic>> sendWatchFaceBackground(WatchFaceBackgroundBean watchFaceBackgroundInfo) async {
    return _platform.sendWatchFaceBackground(watchFaceBackgroundInfo);
  }

  Stream<Map<dynamic, dynamic>> get lazyFileTransEveStm {
    return _platform.lazyFileTransEveStm;
  }

  Future<SupportWatchFaceBean> get querySupportWatchFace {
    return _platform.querySupportWatchFace;
  }

  Future<List<WatchFaceBean>> queryWatchFaceStore(
      WatchFaceStoreBean watchFaceStoreBean){

    return _platform.queryWatchFaceStore(watchFaceStoreBean);
  }

  Future<WatchFaceIdBean> queryWatchFaceOfID(int id){
    return _platform.queryWatchFaceOfID(id);
  }

  Future<Map<dynamic, dynamic>> sendWatchFace(CustomizeWatchFaceBean customizeWatchFaceInfo,int timeout) async {
    return _platform.sendWatchFace(customizeWatchFaceInfo, timeout);
  }

  //表盘到这里结束
  Future<void> sendAlarmClock(AlarmClockBean crpAlarmClockInfo){
    return _platform.sendAlarmClock(crpAlarmClockInfo);
  }

  Future<List<AlarmClockBean>> get queryAllAlarmClock{
    return _platform.queryAllAlarmClock;
  }

  //2.16-2.20许蕾完成
  //心率
  Stream<HeartRateBean> get heartRateEveStm {
    return _platform.heartRateEveStm;
  }

  Future<void> queryLastDynamicRate(String type){
    return _platform.queryLastDynamicRate(type);
  }

  Future<void> enableTimingMeasureHeartRate(int interval){
    return _platform.enableTimingMeasureHeartRate(interval);
  }

  Future<void> get disableTimingMeasureHeartRate {
    return _platform.disableTimingMeasureHeartRate;
  }

   Future<int> get queryTimingMeasureHeartRate {
    return _platform.queryTimingMeasureHeartRate;
  }

  Future<void> queryTodayHeartRate(int heartRateType) {
    return _platform.queryTodayHeartRate(heartRateType);
  }

  Future<void> get queryPastHeartRate {
    return _platform.queryPastHeartRate;
  }

  Future<void> get queryMovementHeartRate {
    return _platform.queryMovementHeartRate;
  }

  Future<void> get startMeasureOnceHeartRate {
    return _platform.startMeasureOnceHeartRate;
  }

  Future<void> get stopMeasureOnceHeartRate {
    return _platform.stopMeasureOnceHeartRate;
  }

  Future<void> get queryHistoryHeartRate {
    return _platform.queryHistoryHeartRate;
  }

  //血压
  Stream<BloodPressureBean> get bloodPressureEveStm {
    return _platform.bloodPressureEveStm;
  }

  Future<void> get startMeasureBloodPressure {
    return _platform.startMeasureBloodPressure;
  }

  Future<void> get stopMeasureBloodPressure {
    return _platform.stopMeasureBloodPressure;
  }

  Future<void> get enableContinueBloodPressure {
    return _platform.enableContinueBloodPressure;
  }

  Future<void> get disableContinueBloodPressure {
    return _platform.disableContinueBloodPressure;
  }

  Future<void> get queryContinueBloodPressureState {
    return _platform.queryContinueBloodPressureState;
  }

  Future<void> get queryLast24HourBloodPressure {
    return _platform.queryLast24HourBloodPressure;
  }

  Future<void> get queryHistoryBloodPressure {
    return _platform.queryHistoryBloodPressure;
  }

  //血氧
  Stream<BloodOxygenBean> get bloodOxygenEveStm {
    return _platform.bloodOxygenEveStm;
  }

  Future<void> get startMeasureBloodOxygen {
    return _platform.startMeasureBloodOxygen;
  }

  Future<void> get stopMeasureBloodOxygen {
    return _platform.stopMeasureBloodOxygen;
  }

  Future<void> enableTimingMeasureBloodOxygen(int interval) {
    return _platform.enableTimingMeasureBloodOxygen(interval);
  }

  Future<void> get disableTimingMeasureBloodOxygen {
    return _platform.disableTimingMeasureBloodOxygen;
  }

  Future<void> get queryTimingBloodOxygenMeasureState {
    return _platform.queryTimingBloodOxygenMeasureState;
  }

  Future<void> queryTimingBloodOxygen(String bloodOxygenTimeType) {
    return _platform.queryTimingBloodOxygen(bloodOxygenTimeType);
  }

  Future<void> get enableContinueBloodOxygen {
    return _platform.enableContinueBloodOxygen;
  }

  Future<void> get disableContinueBloodOxygen {
    return _platform.disableContinueBloodOxygen;
  }

  Future<void> get queryContinueBloodOxygenState {
    return _platform.queryContinueBloodOxygenState;
  }

  Future<void> get queryLast24HourBloodOxygen {
    return _platform.queryLast24HourBloodOxygen;
  }

  Future<void> get queryHistoryBloodOxygen {
    return _platform.queryHistoryBloodOxygen;
  }

  //拍照
  Future<void> get enterCameraView {
    return _platform.enterCameraView;
  }

  Future<void> get exitCameraView {
    return _platform.exitCameraView;
  }

  Stream<String> get cameraEveStm {
    return _platform.cameraEveStm;
  }

  //电话
  Stream<int> get phoneEveStm {
    return _platform.phoneEveStm;
  }

  //rssi
  Stream<int> get deviceRssiEveStm {
    return _platform.deviceRssiEveStm;
  }

  Future<void> get readDeviceRssi {
    return _platform.readDeviceRssi;
  }

  Future<void> setECGChangeListener(String ecgMeasureType) {
    return _platform.setECGChangeListener(ecgMeasureType);
  }

  //egc
  Stream<EgcBean> get lazyEgcEveStm {
    return _platform.lazyEgcEveStm;
  }

  Future<void> get startECGMeasure {
    return _platform.startECGMeasure;
  }

  Future<void> get stopECGMeasure {
    return _platform.stopECGMeasure;
  }

  Future<bool> get isNewECGMeasurementVersion {
    return _platform.isNewECGMeasurementVersion;
  }

  Future<void> get queryLastMeasureECGData {
    return _platform.queryLastMeasureECGData;
  }

  Future<void> sendECGHeartRate(int heartRate) {
    return _platform.sendECGHeartRate(heartRate);
  }

  Stream<Map<dynamic, dynamic>> get lazyContactAvatarEveStm {
    return _platform.lazyContactAvatarEveStm;
  }

  //余诗霞:end
  //yushixia:end

//xulei:start
  //发送手表版本
  Future<void> sendDeviceLanguage(int language) {
    return _platform.sendDeviceLanguage(language);
  }

  Future<DeviceLanguageBean> get queryDeviceLanguage {
    return _platform.queryDeviceLanguage;
  }

  Future<void> sendOtherMessageState(bool messageState) {
    return _platform.sendOtherMessageState(messageState);
  }

  Future<bool> get queryOtherMessageState {
    return _platform.queryOtherMessageState;
  }
  Future<void> sendMessage(MessageBean crpMessageInfo) {
    return _platform.sendMessage(crpMessageInfo);
  }

  Future<void> get sendCall0ffHook {
    return _platform.sendCall0ffHook;
  }

  Future<void> sendSedentaryReminder(bool sedentaryReminder) {
    return _platform.sendSedentaryReminder(sedentaryReminder);
  }

  Future<bool> get querySedentaryReminder {
    return _platform.querySedentaryReminder;
  }

  Future<void> sendSedentaryReminderPeriod(
      SedentaryReminderPeriodBean crpSedentaryReminderPeriodInfo) {
    return _platform.sendSedentaryReminderPeriod(crpSedentaryReminderPeriodInfo);
  }

  Future<SedentaryReminderPeriodBean> get querySedentaryReminderPeriod {
    return _platform.querySedentaryReminderPeriod;
  }

  Future<void> get findDevice {
    return _platform.findDevice;
  }

  Future<void> get shutDown {
    return _platform.shutDown;
  }

  Future<PeriodTimeResultBean> get queryDoNotDisturbTime {
    return _platform.queryDoNotDisturbTime;
  }

  Future<void> sendDoNotDisturbTime(PeriodTimeBean crpPeriodTimeInfo) {
    return _platform.sendDoNotDisturbTime(crpPeriodTimeInfo);
  }

  Future<void> sendBreathingLight(bool breathingLight) {
    return _platform.sendBreathingLight(breathingLight);
  }

  Future<bool> get queryBreathingLight {
    return _platform.queryBreathingLight;
  }
//xulei:end

  /// libaozhong: start
  /// 设置女生生理周期提醒
  Future<void> sendMenstrualCycle(PhysiologcalPeriodBean info) {
    return _platform.sendMenstrualCycle(info);
  }

  /// 获取女生生理周期提醒
  Future<String> get queryMenstrualCycle {
    return _platform.queryMenstrualCycle;
  }

  /// 开始找寻手机
  Future<void> get startFindPhone {
    return _platform.startFindPhone;
  }

  /// 结束找寻手机
  Future<void> get stopFindPhone {
    return _platform.stopFindPhone;
  }

  /// 2.35
  /// 设置播放器状态
  Future<void> setMusicPlayerState(int musicPlayer) {
    return _platform.setMusicPlayerState(musicPlayer);
  }

  /// 设置歌的标题
  Future<void> sendSongTitle(String title) {
    return _platform.sendSongTitle(title);
  }

  /// 设置歌词
  Future<void> sendLyrics(String lyrics) {
    return _platform.sendLyrics(lyrics);
  }

  /// 关闭音乐控制
  Future<void> get closeMusicControl {
    return _platform.closeMusicControl;
  }

  /// 设置当前音量
  Future<void> sendCurrentVolume(int volume) {
    return _platform.sendCurrentVolume(volume);
  }

  /// 设置最大音量
  Future<void> sendMaxVolume(int volume) {
    return _platform.sendMaxVolume(volume);
  }

  /// 2.36
  /// 喝水提醒
  Future<void> enableDrinkWaterReminder(
      DrinkWaterPeriodBean drinkWaterPeriodInfo) {
    return _platform.enableDrinkWaterReminder(drinkWaterPeriodInfo);
  }

  /// 禁用水提醒
  Future<void> get disableDrinkWaterReminder {
    return _platform.disableDrinkWaterReminder;
  }

  /// 查询喝水提醒
  Future<DrinkWaterPeriodBean> get queryDrinkWaterReminderPeriod {
    return _platform.queryDrinkWaterReminderPeriod;
  }

  /// 2.37
  ///  设置心率告警值
  Future<void> setMaxHeartRate(int heartRate,bool enable) {
    return _platform.setMaxHeartRate(heartRate,enable);
  }

  /// 查询心跳告警值
  Future<MaxHeartRateBean> get queryMaxHeartRate {
    return _platform.queryMaxHeartRate;
  }

  /// 开始锻炼
  Future<void> startMovement(int type) {
    return _platform.startMovement(type);
  }

  /// 设置锻炼状态
  Future<void> setMovementState(int movement) {
    return _platform.setMovementState(movement);
  }

  /// 监控锻炼状态
  Stream<String> get movementStateEveStm {
    return _platform.movementStateEveStm;
  }

  /// 获取协议版本
  Future<String> get getProtocolVersion {
    return _platform.getProtocolVersion;
  }

  /// 开始测量第一次温度
  Future<void> get startMeasureTemp {
    return _platform.startMeasureTemp;
  }

  /// 温度一次停止测量
  Future<void> get stopMeasureTemp {
    return _platform.stopMeasureTemp;
  }

  /// 开启定时温度测量
  Future<void> get enableTimingMeasureTemp {
    return _platform.enableTimingMeasureTemp;
  }

  /// 禁用定时温度测量
  Future<void> get disableTimingMeasureTemp {
    return _platform.disableTimingMeasureTemp;
  }

  /// 使用实例查询温度检测状态定时开关
  Future<String> get queryTimingMeasureTempState {
    return _platform.queryTimingMeasureTempState;
  }

  /// 查询定时测温结果
  Future<void> queryTimingMeasureTemp(String tempTimeType) {
    return _platform.queryTimingMeasureTemp(tempTimeType);
  }

  /// 设置温度测量结果监听器
  Stream<String> get tempChangeEveStm {
    return _platform.tempChangeEveStm;
  }

  /// 设置显示的时间
  Future<void> sendDisplayTime(int time) {
    return _platform.sendDisplayTime(time);
  }

  /// 查询显示时间
  Future<int> get queryDisplayTime {
    return _platform.queryDisplayTime;
  }

  /// 开启洗手提醒功能
  Future<void> enableHandWashingReminder(HandWashingPeriodBean info) {
    return _platform.enableHandWashingReminder(info);
  }

  /// 禁用洗手提醒
  Future<void> get disableHandWashingReminder {
    return _platform.disableHandWashingReminder;
  }

  /// 查询洗手提醒
  Future<HandWashingPeriodBean> get queryHandWashingReminderPeriod {
    return _platform.queryHandWashingReminderPeriod;
  }

  /// 设置本地城市
  Future<void> sendLocalCity(String city) {
    return _platform.sendLocalCity(city);
  }

  /// 切换手链的温度系统
  Future<void> sendTempUnit(int temp) {
    return _platform.sendTempUnit(temp);
  }

  /// 查询系统温度
  Future<void> get queryTempUnit {
    return _platform.queryTempUnit;
  }

  /// 设置亮度
  Future<void> sendBrightness(int brightness) {
    return _platform.sendBrightness(brightness);
  }

  /// 获取亮度
  Future<BrightnessBean> get queryBrightness {
    return _platform.queryBrightness;
  }

  /// 获取经典的蓝牙地址
  Future<String> get queryBtAddress {
    return _platform.queryBtAddress;
  }

  /// 检查支持联系人
  Future<String> get checkSupportQuickContact {
    return _platform.checkSupportQuickContact;
  }

  /// 查询当前联系人数
  Future<int> get queryContactCount {
    return _platform.queryContactCount;
  }

  /// 设置联系人侦听器
  Stream<Map<dynamic, dynamic>> get contactEveStm {
    return _platform.contactEveStm;
  }

  /// 设置联系人
  Future<void> sendContact(ContactBean info) {
    return _platform.sendContact(info);
  }

  /// 删除联系人
  Future<void> deleteContact(int id) {
    return _platform.deleteContact(id);
  }

  /// 设置省电监听器
  Stream<bool> get batterySavingEveStm {
    return _platform.batterySavingEveStm;
  }

  /// 设置省电状态
  Future<void> sendBatterySaving(bool enable) {
    return _platform.sendBatterySaving(enable);
  }

  /// 获取省电状态
  Future<void> get queryBatterySaving {
    return _platform.queryBatterySaving;
  }

  /// 查询支持药丸提醒
  Future<String> get queryPillReminder {
    return _platform.queryPillReminder;
  }

  /// 设置药丸提醒
  Future<void> sendPillReminder(PillReminderBean info) {
    return _platform.sendPillReminder(info);
  }

  /// 删除药丸提醒
  Future<void> deletePillReminder(int id) {
    return _platform.deletePillReminder(id);
  }

  /// 清晰的药丸提醒
  Future<void> get clearPillReminder {
    return _platform.clearPillReminder;
  }

  /// 查询轻按，进入唤醒状态
  Future<bool> get queryTapToWakeState {
    return _platform.queryTapToWakeState;
  }

  /// 设置“轻按”为唤醒状态
  Future<void> sendTapToWakeState(bool enable) {
    return _platform.sendTapToWakeState(enable);
  }

  /// 设置培训侦听器
  Stream<String> get trainingEveStm {
    return _platform.trainingEveStm;
  }

  /// 查询历史培训
  Future<void> get queryHistoryTraining {
    return _platform.queryHistoryTraining;
  }

  /// 查询培训细节
  Future<void> queryTraining(int id) {
    return _platform.queryTraining(id);
  }

  Stream<WfFileTransLazyBean> get lazyWFFileTransEveStm {
      return _platform.lazyWFFileTransEveStm;
  }
/// libaozhong: end
}