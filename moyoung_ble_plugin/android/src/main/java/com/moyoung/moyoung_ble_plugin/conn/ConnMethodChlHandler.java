package com.moyoung.moyoung_ble_plugin.conn;

import android.app.Activity;
import android.bluetooth.BluetoothAdapter;
import android.content.Intent;
import android.util.Log;

import com.crrepa.ble.conn.CRPBleConnection;
import com.crrepa.ble.conn.CRPBleDevice;
import com.crrepa.ble.conn.bean.CRPAlarmClockInfo;
import com.crrepa.ble.conn.bean.CRPContactInfo;
import com.crrepa.ble.conn.bean.CRPDrinkWaterPeriodInfo;
import com.crrepa.ble.conn.bean.CRPFirmwareVersionInfo;
import com.crrepa.ble.conn.bean.CRPFutureWeatherInfo;
import com.crrepa.ble.conn.bean.CRPHandWashingPeriodInfo;
import com.crrepa.ble.conn.bean.CRPMessageInfo;
import com.crrepa.ble.conn.bean.CRPPeriodTimeInfo;
import com.crrepa.ble.conn.bean.CRPPillReminderInfo;
import com.crrepa.ble.conn.bean.CRPSedentaryReminderPeriodInfo;
import com.crrepa.ble.conn.bean.CRPSupportWatchFaceInfo;
import com.crrepa.ble.conn.bean.CRPTodayWeatherInfo;
import com.crrepa.ble.conn.bean.CRPUserInfo;
import com.crrepa.ble.conn.bean.CRPWatchFaceInfo;
import com.crrepa.ble.conn.bean.CRPWatchFaceLayoutInfo;
import com.crrepa.ble.conn.callback.CRPDeviceNewFirmwareVersionCallback;
import com.crrepa.ble.conn.callback.CRPDeviceWatchFaceCallback;
import com.crrepa.ble.conn.callback.CRPDeviceWatchFaceStoreCallback;
import com.crrepa.ble.conn.type.CRPBloodOxygenTimeType;
import com.crrepa.ble.conn.type.CRPDeviceLanguageType;
import com.crrepa.ble.conn.type.CRPDeviceVersionType;
import com.crrepa.ble.conn.type.CRPFirmwareUpgradeType;
import com.crrepa.ble.conn.type.CRPHeartRateType;
import com.crrepa.ble.conn.type.CRPHistoryDynamicRateType;
import com.crrepa.ble.conn.type.CRPMetricSystemType;
import com.crrepa.ble.conn.type.CRPMovementHeartRateStateType;
import com.crrepa.ble.conn.type.CRPPastTimeType;
import com.crrepa.ble.conn.type.CRPStepsCategoryDateType;
import com.crrepa.ble.conn.type.CRPTempTimeType;
import com.crrepa.ble.conn.type.CRPTimeSystemType;
import com.crrepa.ble.conn.type.CRPWatchFaceType;
import com.crrepa.ble.ota.hs.HsDfuController;
import com.crrepa.ble.ota.realtek.RtkDfuController;
import com.moyoung.moyoung_ble_plugin.base.BaseChlHandler;
import com.moyoung.moyoung_ble_plugin.base.BaseConnEveChlHandler;
import com.moyoung.moyoung_ble_plugin.common.GsonUtils;
import com.moyoung.moyoung_ble_plugin.conn.model.CheckOTABean;
import com.moyoung.moyoung_ble_plugin.conn.model.ContactBean;
import com.moyoung.moyoung_ble_plugin.conn.model.DeviceLanguageBean;
import com.moyoung.moyoung_ble_plugin.conn.model.MaxHeartRateBean;
import com.moyoung.moyoung_ble_plugin.conn.model.MenstrualCycleBean;
import com.moyoung.moyoung_ble_plugin.conn.model.PeriodTimeBean;
import com.moyoung.moyoung_ble_plugin.conn.model.WatchFaceIDBean;
import com.moyoung.moyoung_ble_plugin.conn.model.WatchFaceStoreBean;
import com.moyoung.moyoung_ble_plugin.conn.model.WatchFaceStoreListBean;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import androidx.annotation.NonNull;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

import static com.moyoung.moyoung_ble_plugin.ChannelConstant.LAZY_EVE_CHL_CONN_CONTACT_AVATAR;
import static com.moyoung.moyoung_ble_plugin.ChannelConstant.LAZY_EVE_CHL_CONN_EGC;
import static com.moyoung.moyoung_ble_plugin.ChannelConstant.LAZY_EVE_CHL_CONN_FILE_TRANS;
import static com.moyoung.moyoung_ble_plugin.ChannelConstant.LAZY_EVE_CHL_CONN_FIRMWARE_UPGRADE;
import static com.moyoung.moyoung_ble_plugin.ChannelConstant.LAZY_EVE_CHL_CONN_WF_FILE_TRANS;

public class ConnMethodChlHandler extends BaseChlHandler implements MethodChannel.MethodCallHandler {
    private final static String TAG = ConnMethodChlHandler.class.getSimpleName();

    private final ConnEveChlRegister connEveChlRegister;
    private CRPBleConnection bleConnection;

    public ConnMethodChlHandler(ConnEveChlRegister connEveChlRegister) {
        this.connEveChlRegister = connEveChlRegister;
    }

    @Override
    public void bindActivity(Activity activity) {
        super.bindActivity(activity);
        connEveChlRegister.bindActivity(this.activity);
    }

    public void unbindChannel(MethodChannel methodChannel) {
        methodChannel.setMethodCallHandler(null);
        connEveChlRegister.unregister();
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        if (!checkBluetoothEnable()) {
            return;
        }

        if ("connect".equals(call.method)) {
            bleConnection = connEveChlRegister.connect(call, activity.getApplicationContext());
            return;
        }

        if (bleConnection == null) {
            Log.v(TAG, "BleConnection is disconnected. Please connect first!");
            return;
        }

        switch (call.method) {
            case "disconnect":
                closeGatt(result);
                break;
            case "isConnected":
                isConnected(call, result);
                break;
            case "syncTime":
                bleConnection.syncTime();
                break;
            case "sendTimeSystem":
                sendTimeSystem(call);
                break;
            case "queryFirmwareVersion":
                queryFirmwareVersion(result);
                break;
            case "queryTimeSystem":
                queryTimeSystem(result);
                break;
            case "checkFirmwareVersion":
                checkFirmwareVersion(call, result);
                break;
            case "queryDeviceBattery":
                queryDeviceBattery();
                break;
            case "subscribeDeviceBattery":
                subscribeDeviceBattery();
                break;
            case "sendUserInfo":
                sendUserInfo(call);
                break;
            case "sendStepLength":
                sendStepLength(call);
                break;
            case "sendTodayWeather":
                sendTodayWeather(call);
                break;
            case "sendFutureWeather":
                sendFutureWeather(call);
                break;
            //余诗霞补充
            case "syncStep":
                syncStep();
                break;
            case "syncPastStep":
                syncPastStep(call);
                break;
            case "queryStepsCategory":
                queryStepsCategory(call);
                break;
            case "syncSleep":
                syncSleep();
                break;
            case "syncRemSleep":
                syncRemSleep();
                break;
            case "syncPastSleep":
                syncPastSleep(call);
                break;
            //此方法无
//            case "syncPastRemSleep":
//                syncPastRemSleep(call);
//                break;
            //固件升级
            case "firmwareUpgradeByHsDfu":
                firmwareUpgradeByHsDfu(call);
                break;
            case "firmwareUpgradeByRtkDfu":
                firmwareUpgradeByRtkDfu(call);
                break;
            case "firmwareUpgrade":
                firmwareUpgrade(call);
                break;
            case "firmwareAbortByHsDfu":
                firmwareAbortByHsDfu();
                break;
            case "firmwareAbortByRtkDfu":
                firmwareAbortByRtkDfu();
                break;
            case "firmwareAbort":
                firmwareAbort();
                break;

            case "queryDeviceDfuStatus":
                queryDeviceDfuStatus(result);
                break;
            case "queryHsDfuAddress":
                queryHsDfuAddress(result);
                break;
            case "enableHsDfu":
                enableHsDfu();
                break;
            case "queryDfuType":
                queryDfuType(result);
                break;
            //余诗霞:start
            case "queryMetricSystem":
                queryMetricSystem(result);
                break;
            case "sendMetricSystem":
                sendMetricSystem(call);
                break;
            case "sendQuickView":
                sendQuickView(call);
                break;
            case "queryQuickView":
                queryQuickView(result);
                break;
            case "sendQuickViewTime":
                sendQuickViewTime(call);
                break;
            case "queryQuickViewTime":
                queryQuickViewTime(result);
                break;
            case "sendGoalSteps":
                sendGoalSteps(call);
                break;
            case "queryGoalStep":
                queryGoalStep(result);
                break;
            //表盘
            case "sendDisplayWatchFace":
                sendDisplayWatchFace(call);
                break;
            case "queryDisplayWatchFace":
                queryDisplayWatchFace(result);
                break;
            case "queryWatchFaceLayout":
                queryWatchFaceLayout(result);
                break;
            case "sendWatchFaceLayout":
                sendWatchFaceLayout(call);
                break;
            case "querySupportWatchFace":
                querySupportWatchFace(result);
                break;
            case "queryWatchFaceStore":
                queryWatchFaceStore(call, result);
                break;
            case "queryWatchFaceOfID":
                queryWatchFaceOfID(call, result);
                break;
            case "sendWatchFace":
                sendWatchFace(call);
                break;
            case "sendAlarmClock":
                sendAlarmClock(call);
                break;
            case "queryAllAlarmClock":
                queryAllAlarmClock(result);
                break;
            case "queryLastDynamicRate":
                queryLastDynamicRate(call);
                break;
            case "enableTimingMeasureHeartRate":
                enableTimingMeasureHeartRate(call);
                break;
            case "disableTimingMeasureHeartRate":
                disableTimingMeasureHeartRate();
                break;
            case "queryTimingMeasureHeartRate":
                queryTimingMeasureHeartRate(result);
                break;
            case "queryTodayHeartRate":
                queryTodayHeartRate(call);
                break;
            case "queryPastHeartRate":
                queryPastHeartRate();
                break;
            case "queryMovementHeartRate":
                queryMovementHeartRate();
                break;
            case "startMeasureOnceHeartRate":
                startMeasureOnceHeartRate();
                break;
            case "stopMeasureOnceHeartRate":
                stopMeasureOnceHeartRate();
                break;
            case "queryHistoryHeartRate":
                queryHistoryHeartRate();
                break;
            //血压
            case "startMeasureBloodPressure":
                startMeasureBloodPressure();
                break;
            case "stopMeasureBloodPressure":
                stopMeasureBloodPressure();
                break;
            case "enableContinueBloodPressure":
                enableContinueBloodPressure();
                break;
            case "disableContinueBloodPressure":
                disableContinueBloodPressure();
                break;
            case "queryContinueBloodPressureState":
                queryContinueBloodPressureState();
                break;
            case "queryLast24HourBloodPressure":
                queryLast24HourBloodPressure();
                break;
            case "queryHistoryBloodPressure":
                queryHistoryBloodPressure();
                break;
            case "startMeasureBloodOxygen":
                startMeasureBloodOxygen();
                break;
            case "stopMeasureBloodOxygen":
                stopMeasureBloodOxygen();
                break;
            case "enableTimingMeasureBloodOxygen":
                enableTimingMeasureBloodOxygen(call);
                break;
            case "disableTimingMeasureBloodOxygen":
                disableTimingMeasureBloodOxygen();
                break;
            case "queryTimingBloodOxygenMeasureState":
                queryTimingBloodOxygenMeasureState();
                break;
            case "queryTimingBloodOxygen":
                queryTimingBloodOxygen(call);
                break;
            case "enableContinueBloodOxygen":
                enableContinueBloodOxygen();
                break;
            case "disableContinueBloodOxygen":
                disableContinueBloodOxygen();
                break;
            case "queryContinueBloodOxygenState":
                queryContinueBloodOxygenState();
                break;
            case "queryLast24HourBloodOxygen":
                queryLast24HourBloodOxygen();
                break;
            case "queryHistoryBloodOxygen":
                queryHistoryBloodOxygen();
                break;
            //拍照
            case "enterCameraView":
                enterCameraView();
                break;
            case "exitCameraView":
                exitCameraView();
                break;
            //rssi
            case "readDeviceRssi":
                readDeviceRssi();
                break;
            //egc
            case "setECGChangeListener":
                setECGChangeListener(call);
                break;
            case "startECGMeasure":
                startECGMeasure();
                break;
            case "stopECGMeasure":
                stopECGMeasure();
                break;
            case "isNewECGMeasurementVersion":
                isNewECGMeasurementVersion(result);
                break;
            case "queryLastMeasureECGData":
                queryLastMeasureECGData();
                break;
            case "sendECGHeartRate":
                sendECGHeartRate(call);
                break;
            case "sendWatchFaceBackground":
                sendWatchFaceBackground(call);
                break;
            //余诗霞:end

            //xulei:start
            case "sendDeviceLanguage":
                sendDeviceLanguage(call);
                break;
            case "queryDeviceLanguage":
                queryDeviceLanguage(result);
                break;
            case "sendOtherMessageState":
                sendOtherMessageState(call);
                break;
            case "queryOtherMessageState":
                queryOtherMessageState(result);
                break;
            case "sendMessage":
                sendMessage(call);
                break;
            case "sendCall0ffHook":
                sendCall0ffHook();
                break;
            case "sendSedentaryReminder":
                sendSedentaryReminder(call);
                break;
            case "querySedentaryReminderPeriod":
                querySedentaryReminderPeriod(result);
                break;
            case "sendSedentaryReminderPeriod":
                sendSedentaryReminderPeriod(call);
                break;
            case "querySedentaryReminder":
                querySedentaryReminder(result);
                break;
            case "findDevice":
                findDevice();
                break;
            case "shutDown":
                shutDown();
                break;
            case "sendDoNotDisturbTime":
                sendDoNotDisturbTime(call);
                break;
            case "queryDoNotDisturbTime":
                queryDoNotDisturbTime(result);
                break;
            case "sendBreathingLight":
                sendBreathingLight(call);
                break;
            case "queryBreathingLight":
                queryBreathingLight(result);
                break;
            //xulei:end
            // libaozhong: start
            case "sendMenstrualCycle":
                sendMenstrualCycle(call);
                break;
            case "queryMenstrualCycle":
                queryMenstrualCycle(result);
                break;
            case "startFindPhone":
                startFindPhone();
                break;
            case "stopFindPhone":
                stopFindPhone();
                break;
            case "setMusicPlayerState":
                setMusicPlayerState(call);
                break;
            case "sendSongTitle":
                sendSongTitle(call);
                break;
            case "sendLyrics":
                sendLyrics(call);
                break;
            case "closeMusicControl":
                closeMusicControl();
                break;
            case "sendCurrentVolume":
                sendCurrentVolume(call);
                break;
            case "sendMaxVolume":
                sendMaxVolume(call);
                break;
            case "enableDrinkWaterReminder":
                enableDrinkWaterReminder(call);
                break;
            case "disableDrinkWaterReminder":
                disableDrinkWaterReminder();
                break;
            case "queryDrinkWaterReminderPeriod":
                queryDrinkWaterReminderPeriod(result);
                break;
            case "setMaxHeartRate":
                setMaxHeartRate(call);
                break;
            case "queryMaxHeartRate":
                queryMaxHeartRate(result);
                break;
            case "startMovement":
                startMovement(call);
                break;
            case "setMovementState":
                setMovementState(call);
                break;
            case "getProtocolVersion":
                getProtocolVersion(result);
                break;
            case "startMeasureTemp":
                startMeasureTemp();
                break;
            case "stopMeasureTemp":
                stopMeasureTemp();
                break;
            case "enableTimingMeasureTemp":
                enableTimingMeasureTemp();
                break;
            case "disableTimingMeasureTemp":
                disableTimingMeasureTemp();
                break;
            case "queryTimingMeasureTempState":
                queryTimingMeasureTempState(result);
                break;
            case "queryTimingMeasureTemp":
                queryTimingMeasureTemp(call);
                break;
            case "sendDisplayTime":
                sendDisplayTime(call);
                break;
            case "queryDisplayTime":
                queryDisplayTime(result);
                break;
            case "enableHandWashingReminder":
                enableHandWashingReminder(call);
                break;
            case "disableHandWashingReminder":
                disableHandWashingReminder();
                break;
            case "queryHandWashingReminderPeriod":
                queryHandWashingReminderPeriod(result);
                break;
            case "sendLocalCity":
                sendLocalCity(call);
                break;
            case "sendTempUnit":
                sendTempUnit(call);
                break;
            case "queryTempUnit":
                queryTempUnit();
                break;
            case "sendBrightness":
                sendBrightness(call);
                break;
            case "queryBrightness":
                queryBrightness(result);
                break;
            case "queryBtAddress":
                queryBtAddress(result);
                break;
            case "checkSupportQuickContact":
                checkSupportQuickContact(result);
                break;
            case "queryContactCount":
                queryContactCount(result);
                break;
            case "sendContact":
                sendContact(call);
                break;
            case "deleteContact":
                deleteContact(call);
                break;
            case "queryBatterySaving":
                queryBatterySaving();
                break;
            case "sendBatterySaving":
                sendBatterySaving(call);
                break;
            case "queryPillReminder":
                queryPillReminder(result);
                break;
            case "sendPillReminder":
                sendPillReminder(call);
                break;
            case "deletePillReminder":
                deletePillReminder(call);
                break;
            case "clearPillReminder":
                clearPillReminder();
                break;
            case "queryTapToWakeState":
                queryTapToWakeState(result);
                break;
            case "sendTapToWakeState":
                sendTapToWakeState(call);
                break;
            case "queryHistoryTraining":
                queryHistoryTraining();
                break;
            case "queryTraining":
                queryTraining(call);
                break;
            // libaozhong: end
            default:
                result.notImplemented();

        }
    }

    // libaozhong: start
    private void queryTraining(MethodCall call) {
        Integer id = call.argument("id");
        id = id == null ? -1 : id;
        Log.d(TAG, "" + id);
        bleConnection.queryTraining(id);
    }

    private void queryHistoryTraining() {
        Log.d(TAG, "----------");
        bleConnection.queryHistoryTraining();
    }

    private void sendTapToWakeState(MethodCall call) {
        Boolean enable = call.argument("enable");
        enable = enable != null && enable;
        Log.d(TAG, "" + enable);
        bleConnection.sendTapToWakeState(enable);
    }

    private void queryTapToWakeState(MethodChannel.Result result) {
        Log.d(TAG, "-------");
        bleConnection.queryTapToWakeState(result::success);
    }

    private void clearPillReminder() {
        Log.d(TAG, "----------");
        bleConnection.clearPillReminder();
    }

    private void deletePillReminder(MethodCall call) {
        Integer id = call.argument("id");
        id = id == null ? -1 : id;
        Log.d(TAG, "" + id);
        bleConnection.deletePillReminder(id);
    }

    private void sendPillReminder(MethodCall call) {
        String jsonStr = call.argument("pillReminderInfo");
        Log.d(TAG, jsonStr);
        CRPPillReminderInfo pillReminderInfo = GsonUtils.get().fromJson(jsonStr,
                CRPPillReminderInfo.class);
        Log.d(TAG, "" + pillReminderInfo);
        bleConnection.sendPillReminder(pillReminderInfo);
    }

    private void queryPillReminder(MethodChannel.Result result) {
        Log.d(TAG, "--------");
        bleConnection.queryPillReminder((supportCount, list) -> {
            Log.d(TAG, supportCount + "");
            String jsonStr = GsonUtils.get().toJson(list, List.class);
            result.success(jsonStr);
        });
    }

    private void sendBatterySaving(MethodCall call) {
        Boolean enable = call.argument("enable");
        enable = enable != null && enable;
        Log.d(TAG, "" + enable);
        bleConnection.sendBatterySaving(enable);
    }

    private void queryBatterySaving() {
        Log.d(TAG, "---------");
        bleConnection.queryBatterySaving();
    }

    private void deleteContact(MethodCall call) {
        Integer id = call.argument("id");
        id = id == null ? -1 : id;
        Log.d(TAG, id+"");
        bleConnection.deleteContact(id);
        bleConnection.deleteContactAvatar(id);
    }

    private void sendContactAvatar(MethodCall call) {
        BaseConnEveChlHandler lazyEveChlHandler
                = connEveChlRegister.getLazyEveChlHandler(LAZY_EVE_CHL_CONN_CONTACT_AVATAR);
        if (lazyEveChlHandler == null) {
            return;
        }

        lazyEveChlHandler.setConnListener(bleConnection, call);
    }

    private void sendContact(MethodCall call) {
        String jsonStr = call.argument("contactBean");
        Log.d(TAG, jsonStr);
        ContactBean contactBean = GsonUtils.get().fromJson(jsonStr,
                ContactBean.class);
        CRPContactInfo crpContactInfo = new CRPContactInfo(contactBean.getId(),
                contactBean.getWidth(),
                contactBean.getHeight(),
                contactBean.getAddress(),
                contactBean.getName(),
                contactBean.getNumber());
        Log.d(TAG, ""+crpContactInfo);
        bleConnection.sendContact(crpContactInfo);
        sendContactAvatar(call);
    }

    private void queryContactCount(MethodChannel.Result result) {
        bleConnection.queryContactCount(result::success);
    }

    private void checkSupportQuickContact(MethodChannel.Result result) {
        bleConnection.checkSupportQuickContact(contactConfigInfo -> {
            String jsonStr = GsonUtils.get().toJson(contactConfigInfo);
            result.success(jsonStr);
        });
    }

    private void queryBtAddress(MethodChannel.Result result) {
        bleConnection.queryBtAddress(result::success);
    }

    private void queryBrightness(MethodChannel.Result result) {
        Log.d(TAG,"-------");
        bleConnection.queryBrightness((current, max) -> {
            Map<String, Object> mapStr = new HashMap<>();
            mapStr.put("current", current);
            mapStr.put("max", max);
            result.success(mapStr);
        });
    }

    private void sendBrightness(MethodCall call) {
        Integer brightness = call.argument("brightness");
        brightness = brightness == null ? -1 : brightness;
        Log.d(TAG, brightness+"");
        bleConnection.sendBrightness(brightness);
    }

    private void queryTempUnit() {
        Log.d("queryTempUnit----", "----");
        bleConnection.queryTempUnit();
    }

    private void sendTempUnit(MethodCall call) {
        Integer temp = call.argument("temp");
        temp = temp == null ? 1 : temp;
        Log.d("sendTempUnit-----", temp+"");
        bleConnection.sendTempUnit(temp.byteValue());
    }

    private void sendLocalCity(MethodCall call) {
        String city = call.argument("city");
        Log.d(TAG, city+"---");
        bleConnection.sendLocalCity(city);
    }

    private void queryHandWashingReminderPeriod(MethodChannel.Result result) {
        Log.d(TAG, "---------");
        bleConnection.queryHandWashingReminderPeriod(crpHandWashingPeriodInfo -> {
            String jsonStr = GsonUtils.get().toJson(crpHandWashingPeriodInfo);
            result.success(jsonStr);
        });
    }

    private void disableHandWashingReminder() {
        Log.d(TAG, "--------");
        bleConnection.disableHandWashingReminder();
    }

    private void enableHandWashingReminder(MethodCall call) {
        String jsonStr = call.argument("handWashingPeriodInfo");
        Log.d(TAG, jsonStr);
        CRPHandWashingPeriodInfo handWashingPeriodInfo = GsonUtils.get().fromJson(jsonStr,
                CRPHandWashingPeriodInfo.class);
        bleConnection.enableHandWashingReminder(handWashingPeriodInfo);
    }

    private void queryDisplayTime(MethodChannel.Result result) {
        bleConnection.queryDisplayTime(time -> {
            Log.d(time+"", "----------239");
            result.success(time);
        });
    }

    private void sendDisplayTime(MethodCall call) {
        Integer time = call.argument("time");
        time = time == null ? -1 : time ;
        Log.d(TAG,time+"");
        bleConnection.sendDisplayTime(time);
    }

    private void queryTimingMeasureTemp(MethodCall call) {
        String tempTimeType = call.argument("tempTimeType");
        tempTimeType = tempTimeType == null ? "TODAY" : tempTimeType;
        Log.d(TAG, ""+CRPTempTimeType.valueOf(tempTimeType));
        bleConnection.queryTimingMeasureTemp(CRPTempTimeType.valueOf(tempTimeType));
    }

    private void queryTimingMeasureTempState(MethodChannel.Result result) {
        Log.d(TAG, "--------");
        bleConnection.queryTimingMeasureTempState(timingTempState -> {
            Log.d(TAG, "==========");
            String jsonStr = GsonUtils.get().toJson(timingTempState);
            result.success(jsonStr);
        });
    }

    private void disableTimingMeasureTemp() {
        Log.d(TAG, "-------");
        bleConnection.disableTimingMeasureTemp();
    }

    private void enableTimingMeasureTemp() {
        Log.d("enableTimingMeasureTemp", "-------");
        bleConnection.enableTimingMeasureTemp();
    }

    private void stopMeasureTemp() {
        Log.d("stopMeasureTemp-----", "-----");
        bleConnection.stopMeasureTemp();
    }

    private void startMeasureTemp() {
        Log.d("startMeasureTemp----", "------");
        bleConnection.startMeasureTemp();
    }

    private void setMovementState(MethodCall call) {
        Integer type = call.argument("movement");
        type = type == null ? CRPMovementHeartRateStateType.MOVEMENT_COMPLETE : type;
        Log.d(TAG, ""+type);
        bleConnection.setMovementState(type.byteValue());
    }

    private void startMovement(MethodCall call) {
        Integer type = call.argument("type");
        type = type == null ? 0 : type;
        Log.d(TAG, ""+type);
        bleConnection.startMovement(type.byteValue());
    }

    private void queryMaxHeartRate(MethodChannel.Result result) {
        Log.d(TAG, "--------");
        bleConnection.queryMaxHeartRate((heartRate, enable) -> {
            MaxHeartRateBean maxHeartRate = new MaxHeartRateBean(heartRate,enable);
            String jsonStr = GsonUtils.get().toJson(maxHeartRate, MaxHeartRateBean.class);
            Log.i(TAG, "queryMaxHeartRate: "+ jsonStr);
            result.success(jsonStr);
        });
    }

    private void setMaxHeartRate(MethodCall call) {
        Integer heartRate = call.argument("heartRate");
        Boolean enable = call.argument("enable");
        heartRate = heartRate == null ? -1 : heartRate;
        enable = enable != null && enable;
        Log.d(TAG + heartRate, "----" + enable);
        bleConnection.setMaxHeartRate(heartRate.byteValue(), enable);
    }

    private void queryDrinkWaterReminderPeriod(MethodChannel.Result result) {
        bleConnection.queryDrinkWaterReminderPeriod(drinkWaterPeriodInfo -> {
            String jsonStr = GsonUtils.get().toJson(drinkWaterPeriodInfo);
            result.success(jsonStr);
        });
    }

    private void disableDrinkWaterReminder() {
        Log.d(TAG, "-----");
        bleConnection.disableDrinkWaterReminder();
    }

    private void enableDrinkWaterReminder(MethodCall call) {
        String jsonStr = call.argument("drinkWaterPeriodInfo");
        Log.d(TAG, jsonStr);
        CRPDrinkWaterPeriodInfo drinkWaterPeriodInfo = GsonUtils.get().fromJson(jsonStr,
                CRPDrinkWaterPeriodInfo.class);
        Log.d(TAG, drinkWaterPeriodInfo + "");
        bleConnection.enableDrinkWaterReminder(drinkWaterPeriodInfo);
    }

    private void sendMaxVolume(MethodCall call) {
        Integer volume = call.argument("volume");
        volume = volume == null ? 0 : volume;
        Log.d(TAG, volume+"");
        bleConnection.sendMaxVolume(volume);
    }

    private void sendCurrentVolume(MethodCall call) {
        Integer volume = call.argument("volume");
        volume = volume == null ? 0 : volume;
        Log.d(TAG, volume+"");
        bleConnection.sendCurrentVolume(volume);
    }

    private void closeMusicControl() {
        Log.d(TAG, "------");
        bleConnection.closeMusicControl();
    }

    private void sendLyrics(MethodCall call) {
        Log.d(TAG, "-----"+call.argument("lyrics"));
        bleConnection.sendLyrics(call.argument("lyrics"));
    }

    private void sendSongTitle(MethodCall call) {
        Log.d(call.argument("title") + "", "======");
        bleConnection.sendSongTitle(call.argument("title"));
    }

    private void setMusicPlayerState(MethodCall call) {
        int type = call.argument("CRPMusicPlayerStateType");
        Log.d("setMusicPlayerState--", ""+type);
        bleConnection.setMusicPlayerState((byte) type);
    }

    private void stopFindPhone() {
        Log.d(TAG, "-------");
        bleConnection.stopFindPhone();
    }

    private void startFindPhone() {
        Log.d(TAG, "====");
        bleConnection.startFindPhone();
    }

    private void sendMenstrualCycle (MethodCall call) {
        String jsonStr = call.argument("futureWeatherInfo");
        Log.d(TAG, jsonStr);

        MenstrualCycleBean menstrualCycleInfo = GsonUtils.get().fromJson(jsonStr,
                MenstrualCycleBean.class);
        Log.d(TAG, MenstrualCycleBean.convert(menstrualCycleInfo)+"");
        bleConnection.sendPhysiologcalPeriod(MenstrualCycleBean.convert(menstrualCycleInfo));
    }

    private void queryMenstrualCycle(MethodChannel.Result result) {
        bleConnection.queryPhysiologcalPeriod(crpPhysiologcalPeriodInfo -> {
            String jsonStr = GsonUtils.get().toJson(
                    crpPhysiologcalPeriodInfo.getPhysiologcalPeriod());
            result.success(jsonStr);
        });
    }

    private void getProtocolVersion(MethodChannel.Result result) {
        String jsonStr = GsonUtils.get().toJson(bleConnection.getProtocolVersion());
        Log.d(TAG, jsonStr+"");
        result.success(jsonStr);
    }
    // libaozhong: end

    private void sendFutureWeather(MethodCall call) {
        String jsonStr = call.argument("futureWeatherInfo");
        Log.d(TAG, jsonStr);
        CRPFutureWeatherInfo futureWeatherInfo = GsonUtils.get().fromJson(jsonStr,
                CRPFutureWeatherInfo.class);
        bleConnection.sendFutureWeather(futureWeatherInfo);
    }

    private void sendTodayWeather(MethodCall call) {
        String jsonStr = call.argument("todayWeatherInfo");
        Log.d(TAG, jsonStr);
        CRPTodayWeatherInfo todayWeatherInfo = GsonUtils.get().fromJson(jsonStr,
                CRPTodayWeatherInfo.class);
        bleConnection.sendTodayWeather(todayWeatherInfo);
    }

    private void sendStepLength(MethodCall call) {
        Integer stepLength = call.argument("stepLength");
        stepLength = stepLength == null ? -1 : stepLength;
        bleConnection.sendStepLength(stepLength.byteValue());
    }

    private void sendUserInfo(MethodCall call) {
        String jsonStr = call.argument("userInfo");
        Log.d(TAG, jsonStr);
        CRPUserInfo userInfo = GsonUtils.get().fromJson(jsonStr, CRPUserInfo.class);
        bleConnection.sendUserInfo(userInfo);
    }

    private void sendTimeSystem(@NonNull MethodCall call) {
        Integer timeSystemType = call.argument("timeSystemType");
        timeSystemType = timeSystemType == null ? CRPTimeSystemType.TIME_SYSTEM_12 : timeSystemType;

        bleConnection.sendTimeSystem(timeSystemType.byteValue());
    }

    private void queryTimeSystem(MethodChannel.Result result) {
        bleConnection.queryTimeSystem(result::success);
    }

    private void queryDeviceBattery() {//调用该方法，电量值会在CRPDeviceBatteryListener中回调
        bleConnection.queryDeviceBattery();
    }

    private void subscribeDeviceBattery() {
        bleConnection.subscribeDeviceBattery();
    }

    private void queryFirmwareVersion(MethodChannel.Result result) {
        bleConnection.queryFrimwareVersion(result::success);
    }

    private void checkFirmwareVersion(MethodCall call, MethodChannel.Result result) {
        String version = call.argument("version");
        Integer OTAType = call.argument("OTAType");
        version = version == null ? "-1" : version;
        OTAType = OTAType == null ? CRPFirmwareUpgradeType.NORMAL_UPGEADE_TYPE : OTAType;

        if (bleConnection == null) {
            result.success(null);
            return;
        }

        bleConnection.checkFirmwareVersion(new CRPDeviceNewFirmwareVersionCallback() {
            @Override
            public void onNewFirmwareVersion(CRPFirmwareVersionInfo crpFirmwareVersionInfo) {
                CheckOTABean otaBean = new CheckOTABean(true);
                otaBean.setFirmwareVersionInfo(crpFirmwareVersionInfo);
                String jsonStr = GsonUtils.get().toJson(otaBean);
                result.success(jsonStr);
            }

            @Override
            public void onLatestVersion() {
                CheckOTABean otaBean = new CheckOTABean(true);
                otaBean.setIsLatestVersion("already the latest version");
                String jsonStr = GsonUtils.get().toJson(otaBean);
                result.success(jsonStr);
            }
        }, version, OTAType.intValue());
    }

    private void isConnected(MethodCall call, MethodChannel.Result result) {
        String address = call.argument("address");
        result.success(isConnected(address));
    }

    private boolean isConnected(String address) {
        CRPBleDevice mBleDevice = bleClient.getBleDevice(address);
        return mBleDevice != null && mBleDevice.isConnected();
    }

    private boolean checkBluetoothEnable() {
        if (!bleClient.isBluetoothEnable()) {
            Intent enableBtIntent = new Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE);
            activity.startActivity(enableBtIntent);
        }

        return bleClient.isBluetoothEnable();
    }

    private void closeGatt(MethodChannel.Result result) {
        if (bleConnection != null) {
            bleConnection.close();
            bleConnection = null;
            result.success(true);
        }
    }

    //余诗霞补充
    private void syncStep() {
        bleConnection.syncStep();
    }

    private void syncPastStep(MethodCall call) {
        Integer pastTimeType = call.argument("pastTimeType");
        pastTimeType = pastTimeType == null ?
                CRPPastTimeType.YESTERDAY_STEPS : pastTimeType;
        bleConnection.syncPastStep(pastTimeType.byteValue());
    }

    private void queryStepsCategory(MethodCall call) {
        Integer stepsCategoryDateType = call.argument("stepsCategoryDateType");
        stepsCategoryDateType = stepsCategoryDateType == null ?
                CRPStepsCategoryDateType.TODAY_STEPS_CATEGORY : stepsCategoryDateType;
        bleConnection.queryStepsCategory(stepsCategoryDateType.byteValue());
    }

    private void syncSleep() {
        bleConnection.syncSleep();
    }

    private void syncRemSleep() {
        bleConnection.syncRemSleep();
    }

    private void syncPastSleep(MethodCall call) {
        Integer pastTimeType = call.argument("pastTimeType");
        pastTimeType = pastTimeType == null ?
                CRPPastTimeType.YESTERDAY_SLEEP : pastTimeType;
        bleConnection.syncPastSleep(pastTimeType.byteValue());
    }

    //固件升级
    private void firmwareUpgradeByHsDfu(MethodCall call) {
        FileFirmwareUpgradeHandler eveChlHandler
                = (FileFirmwareUpgradeHandler) connEveChlRegister.getLazyEveChlHandler(LAZY_EVE_CHL_CONN_FIRMWARE_UPGRADE);
        if (eveChlHandler == null) {
            return;
        }
        eveChlHandler.setHsLazyConnListener(call);
    }

    private void firmwareUpgradeByRtkDfu(MethodCall call) {
        FileFirmwareUpgradeHandler eveChlHandler
                = (FileFirmwareUpgradeHandler) connEveChlRegister.getLazyEveChlHandler(LAZY_EVE_CHL_CONN_FIRMWARE_UPGRADE);
        if (eveChlHandler == null) {
            return;
        }
        eveChlHandler.setRtkUpgradeListener(call);
    }

    private void firmwareUpgrade(MethodCall call) {
        BaseConnEveChlHandler lazyEveChlHandler
                = connEveChlRegister.getLazyEveChlHandler(LAZY_EVE_CHL_CONN_FIRMWARE_UPGRADE);
        if (lazyEveChlHandler == null) {
            return;
        }
        lazyEveChlHandler.setConnListener(bleConnection, call);
    }

    private void firmwareAbortByHsDfu() {
        HsDfuController hsDfuController = HsDfuController.getInstance();
        hsDfuController.abort();
    }

    private void firmwareAbortByRtkDfu() {
        RtkDfuController rtkDfuController = RtkDfuController.getInstance();
        rtkDfuController.abort();
    }

    private void firmwareAbort() {
        bleConnection.abortFirmwareUpgrade();
    }

    private void queryDeviceDfuStatus(MethodChannel.Result result) {
        bleConnection.queryDeviceDfuStatus(result::success);
    }

    private void queryHsDfuAddress(MethodChannel.Result result) {
        Log.d(TAG, "queryHsDfuAddress: ---------");
        bleConnection.queryHsDfuAddress(s -> {
            Log.d(TAG, "onAddress: "+s);
            result.success(s);
        });
    }

    private void enableHsDfu() {
        bleConnection.enableHsDfu();
    }

    private void queryDfuType(MethodChannel.Result result) {
        bleConnection.queryDfuType(result::success);
    }

    //余诗霞:start
    private void queryMetricSystem(MethodChannel.Result result) {
        bleConnection.queryMetricSystem(result::success);
    }

    private void sendMetricSystem(MethodCall call) {
        Integer metricSystemType = call.argument("metricSystemType");
        metricSystemType = metricSystemType == null ?
                CRPMetricSystemType.METRIC_SYSTEM : metricSystemType;

        bleConnection.sendMetricSystem(metricSystemType.byteValue());
    }

    private void sendQuickView(MethodCall call) {
        Boolean quickViewState = call.argument("quickViewState");
        quickViewState = quickViewState != null && quickViewState;

        bleConnection.sendQuickView(quickViewState);
    }

    private void queryQuickView(MethodChannel.Result result) {
        Log.d(TAG, "-------");
        bleConnection.queryQuickView(result::success);
    }

    private void sendQuickViewTime(MethodCall call) {
        String jsonStr = call.argument("periodTimeInfo");
        Log.d(TAG, jsonStr);
        CRPPeriodTimeInfo periodTimeInfo = GsonUtils.get().fromJson(jsonStr,
                CRPPeriodTimeInfo.class);

        bleConnection.sendQuickViewTime(periodTimeInfo);
    }

    private void queryQuickViewTime(MethodChannel.Result result) {
        bleConnection.queryQuickViewTime((int periodTimeType, CRPPeriodTimeInfo periodTimeInfo) -> {
            PeriodTimeBean quickViewTime = new PeriodTimeBean(periodTimeType,periodTimeInfo);
            String jsonStr = GsonUtils.get().toJson(quickViewTime, PeriodTimeBean.class);
            Log.i(TAG, "queryQuickViewTime: " + jsonStr );
            result.success(jsonStr);
        });
    }

    private void sendGoalSteps(MethodCall call) {
        Integer goalSteps = call.argument("goalSteps");
        goalSteps = goalSteps == null ? 8000 : goalSteps;

        bleConnection.sendGoalSteps(goalSteps);
    }

    private void queryGoalStep(MethodChannel.Result result) {
        bleConnection.queryGoalStep(result::success);
    }

    private void sendDisplayWatchFace(MethodCall call) {
        Integer watchFaceType = call.argument("watchFaceType");
        watchFaceType = watchFaceType == null ? CRPWatchFaceType.FIRST_WATCH_FACE : watchFaceType;

        bleConnection.sendDisplayWatchFace(watchFaceType.byteValue());
    }

    private void queryDisplayWatchFace(MethodChannel.Result result) {
        bleConnection.queryDisplayWatchFace(result::success);
    }

    private void queryWatchFaceLayout(MethodChannel.Result result) {
        bleConnection.queryWatchFaceLayout(crpWatchFaceLayoutInfo -> {
            String jsonStr = GsonUtils.get().toJson(crpWatchFaceLayoutInfo, CRPWatchFaceLayoutInfo.class);
            result.success(jsonStr);
        });
    }

    private void sendWatchFaceLayout(MethodCall call) {
        String jsonStr = call.argument("watchFaceLayoutInfo");
        Log.d(TAG, jsonStr);
        CRPWatchFaceLayoutInfo watchFaceLayoutInfo = GsonUtils.get().fromJson(jsonStr, CRPWatchFaceLayoutInfo.class);

        bleConnection.sendWatchFaceLayout(watchFaceLayoutInfo);
    }

    private void sendWatchFaceBackground(MethodCall call) {
        BaseConnEveChlHandler lazyEveChlHandler
                = connEveChlRegister.getLazyEveChlHandler(LAZY_EVE_CHL_CONN_FILE_TRANS);
        if (lazyEveChlHandler == null) {
            return;
        }

        lazyEveChlHandler.setConnListener(bleConnection, call);
    }

    private void querySupportWatchFace(MethodChannel.Result result) {
        bleConnection.querySupportWatchFace(crpSupportWatchFaceInfo -> {
            String jsonStr = GsonUtils.get().toJson(crpSupportWatchFaceInfo, CRPSupportWatchFaceInfo.class);
            result.success(jsonStr);
        });
    }

    private void queryWatchFaceStore(MethodCall call, MethodChannel.Result result) {
        String jsonStr = call.argument("watchFaceStoreBean");
        Log.d(TAG, jsonStr);
        WatchFaceStoreBean watchFaceLayoutInfo = GsonUtils.get().fromJson(jsonStr, WatchFaceStoreBean.class);
        Log.d(TAG,""+watchFaceLayoutInfo.getWatchFaceSupportList());
        Log.d(TAG,""+watchFaceLayoutInfo.getFirmwareVersion());

        bleConnection.queryWatchFaceStore(watchFaceLayoutInfo.getWatchFaceSupportList(), watchFaceLayoutInfo.getFirmwareVersion(),
                watchFaceLayoutInfo.getPageCount(), watchFaceLayoutInfo.getPageIndex(), new CRPDeviceWatchFaceStoreCallback() {
                    @Override
                    public void onWatchFaceStoreChange(CRPWatchFaceInfo crpWatchFaceInfo) {
                        WatchFaceStoreListBean watchFaceStore = new WatchFaceStoreListBean(crpWatchFaceInfo,"noError");
                        String jsonStr = GsonUtils.get().toJson(watchFaceStore, WatchFaceStoreListBean.class);
                        result.success(jsonStr);
                    }

                    @Override
                    public void onError(String error) {
                        CRPWatchFaceInfo watchFaceInfo = new CRPWatchFaceInfo(-1,-1,-1,new LinkedList<>());
                        WatchFaceStoreListBean watchFaceStore = new WatchFaceStoreListBean(watchFaceInfo,error);
                        String jsonStr = GsonUtils.get().toJson(watchFaceStore, WatchFaceStoreListBean.class);
                        result.success(jsonStr);
                    }
                });
    }

    private void queryWatchFaceOfID(MethodCall call, MethodChannel.Result result) {
        Integer id = call.argument("id");
        id = id == null ? -1: id;
        bleConnection.queryWatchFaceOfID(id, new CRPDeviceWatchFaceCallback() {
            @Override
            public void onWatchFaceChange(CRPWatchFaceInfo.WatchFaceBean watchFace) {
                int result_OK = 0;
                WatchFaceIDBean watchFaceID = new WatchFaceIDBean(result_OK);
                watchFaceID.setWatchFace(watchFace);
                watchFaceID.setError("");
                String jsonStr = GsonUtils.get().toJson(watchFaceID, WatchFaceIDBean.class);
                Log.i(TAG, "onWatchFaceChange: " + jsonStr);
                result.success(jsonStr);
            }

            @Override
            public void onError(String error) {
                int errorCode = 101;
                WatchFaceIDBean watchFaceID = new WatchFaceIDBean(errorCode);
                watchFaceID.setError(error);
                watchFaceID.setWatchFace(new CRPWatchFaceInfo.WatchFaceBean(-1,null,null));
                String jsonStr = GsonUtils.get().toJson(watchFaceID, WatchFaceIDBean.class);
                Log.i(TAG, "onError: " + jsonStr);
                result.success(jsonStr);
            }
        });
    }

    private void sendWatchFace(MethodCall call) {
        BaseConnEveChlHandler lazyEveChlHandler
                = connEveChlRegister.getLazyEveChlHandler(LAZY_EVE_CHL_CONN_WF_FILE_TRANS);
        if (lazyEveChlHandler == null) {
            return;
        }

        lazyEveChlHandler.setConnListener(bleConnection, call);
    }

    private void sendAlarmClock(MethodCall call) {
        String jsonStr = call.argument("alarmClockInfo");
        Log.d(TAG, jsonStr);
        CRPAlarmClockInfo crpAlarmClockInfo = GsonUtils.get().fromJson(jsonStr, CRPAlarmClockInfo.class);

        bleConnection.sendAlarmClock(crpAlarmClockInfo);
    }

    private void queryAllAlarmClock(MethodChannel.Result result) {
        bleConnection.queryAllAlarmClock(list -> {
            List<String> jsonStr = new ArrayList<>();
            for (int i = 0; i < list.size(); i++) {
                jsonStr.add(GsonUtils.get().toJson(list.get(i), CRPAlarmClockInfo.class));
            }
            result.success(jsonStr.toString());
        });
    }

    //心率
    private void queryLastDynamicRate(MethodCall call) {
        String type = call.argument("type");
        bleConnection.queryLastDynamicRate(CRPHistoryDynamicRateType.valueOf(type));
    }

    private void enableTimingMeasureHeartRate(MethodCall call) {
        Integer interval = call.argument("interval");
        interval = interval == null ? 5 : interval;
        Log.d(TAG, ""+interval);
        bleConnection.enableTimingMeasureHeartRate(interval);
    }

    private void disableTimingMeasureHeartRate() {
        Log.d(TAG, "---");
        bleConnection.disableTimingMeasureHeartRate();
    }

    private void queryTimingMeasureHeartRate(MethodChannel.Result result) {
        bleConnection.queryTimingMeasureHeartRate(result::success);
    }

    private void queryTodayHeartRate(MethodCall call) {
        Integer heartRateType = call.argument("heartRateType");
        heartRateType = heartRateType == null ? CRPHeartRateType.ALL_DAY_HEART_RATE : heartRateType;
        Log.d(TAG, heartRateType+"");
        bleConnection.queryTodayHeartRate(heartRateType);
    }

    private void queryPastHeartRate() {
        Log.d(TAG, "-------");
        bleConnection.queryPastHeartRate();
    }

    private void queryMovementHeartRate() {
        Log.d("queryMovementHeartRate", "-------");
        bleConnection.queryMovementHeartRate();
    }

    private void startMeasureOnceHeartRate() {
        Log.d(TAG, "-------");
        bleConnection.startMeasureOnceHeartRate();
    }

    private void stopMeasureOnceHeartRate() {
        Log.d(TAG, "-------");
        bleConnection.stopMeasureOnceHeartRate();
    }

    private void queryHistoryHeartRate() {
        Log.d(TAG, "-------");
        bleConnection.queryHistoryHeartRate();
    }

    //血压
    private void startMeasureBloodPressure() {
        Log.d(TAG, "-------");
        bleConnection.startMeasureBloodPressure();
    }

    private void stopMeasureBloodPressure() {
        Log.d(TAG, "-------");
        bleConnection.stopMeasureBloodPressure();
    }

    private void enableContinueBloodPressure() {
        Log.d(TAG, "-----");
        bleConnection.enableContinueBloodPressure();
    }

    private void disableContinueBloodPressure() {
        Log.d(TAG, "-----");
        bleConnection.disableContinueBloodPressure();
    }

    private void queryContinueBloodPressureState() {
        Log.d(TAG, "-----");
        bleConnection.queryContinueBloodPressureState();
    }

    private void queryLast24HourBloodPressure() {
        Log.d(TAG, "-----");
        bleConnection.queryLast24HourBloodPressure();
    }

    private void queryHistoryBloodPressure() {
        Log.d(TAG, "-----");
        bleConnection.queryHistoryBloodPressure();
    }

    //血氧
    private void startMeasureBloodOxygen() {
        Log.d(TAG, "-----");
        bleConnection.startMeasureBloodOxygen();
    }

    private void stopMeasureBloodOxygen() {
        Log.d(TAG, "-----");
        bleConnection.stopMeasureBloodOxygen();
    }

    private void enableTimingMeasureBloodOxygen(MethodCall call) {
        Integer interval = call.argument("interval");
        interval = interval == null ? 5 : interval;
        Log.d(TAG, ""+interval);
        bleConnection.enableTimingMeasureBloodOxygen(interval);
    }

    private void disableTimingMeasureBloodOxygen() {
        Log.d(TAG, "-----");
        bleConnection.disableTimingMeasureBloodOxygen();
    }

    private void queryTimingBloodOxygenMeasureState() {
        Log.d(TAG, "-----");
        bleConnection.queryTimingBloodOxygenMeasureState();
    }

    private void queryTimingBloodOxygen(MethodCall call) {
        String bloodOxygenTimeType = call.argument("bloodOxygenTimeType");
        bloodOxygenTimeType = bloodOxygenTimeType == null ? CRPBloodOxygenTimeType.TODAY.toString() : bloodOxygenTimeType;
        Log.d(TAG,bloodOxygenTimeType);
        bleConnection.queryTimingBloodOxygen(CRPBloodOxygenTimeType.valueOf(bloodOxygenTimeType));
    }

    private void enableContinueBloodOxygen() {
        Log.d(TAG, "-----");
        bleConnection.enableContinueBloodOxygen();
    }

    private void disableContinueBloodOxygen() {
        Log.d(TAG, "-----");
        bleConnection.disableContinueBloodOxygen();
    }

    private void queryContinueBloodOxygenState() {
        Log.d(TAG, "-----");
        bleConnection.queryContinueBloodOxygenState();
    }


    private void queryLast24HourBloodOxygen() {
        Log.d(TAG, "-----");
        bleConnection.queryLast24HourBloodOxygen();
    }

    private void queryHistoryBloodOxygen() {
        Log.d(TAG, "-----");
        bleConnection.queryHistoryBloodOxygen();
    }

    //拍照
    private void enterCameraView() {
        Log.d(TAG, "-----");
        bleConnection.enterCameraView();
    }

    private void exitCameraView() {
        Log.d(TAG, "-----");
        bleConnection.exitCameraView();
    }

    //rssi
    private void readDeviceRssi() {
        Log.d(TAG, "-----");
        bleConnection.readDeviceRssi();
    }

    //egc
    private void setECGChangeListener(MethodCall call) {
        BaseConnEveChlHandler lazyEveChlHandler
                = connEveChlRegister.getLazyEveChlHandler(LAZY_EVE_CHL_CONN_EGC);
        if (lazyEveChlHandler == null) {
            return;
        }
        Log.d(TAG, "setECGChangeListener: ====");
        lazyEveChlHandler.setConnListener(bleConnection, call);
    }

    private void startECGMeasure() {
        Log.d(TAG, "-----");
        bleConnection.startECGMeasure();
    }

    private void stopECGMeasure() {
        Log.d(TAG, "-----");
        bleConnection.stopECGMeasure();
    }

    private void isNewECGMeasurementVersion(MethodChannel.Result result) {
        boolean newMeasurementVersion = bleConnection.isNewECGMeasurementVersion();

        Log.d(TAG, "isNewECGMeasurementVersion: " + newMeasurementVersion);
        result.success(newMeasurementVersion);

    }

    private void queryLastMeasureECGData() {
        Log.d(TAG, "-----");
        bleConnection.queryLastMeasureECGData();
    }

    private void sendECGHeartRate(MethodCall call) {
        Integer heartRate = call.argument("heartRate");
        heartRate = heartRate == null ? 0 : heartRate;
        Log.d("sendECGHeartRate-----", ""+heartRate);
        bleConnection.sendECGHeartRate(heartRate);
    }
    //余诗霞::end

    //xulei:start
    //2.17 Language
    private void sendDeviceLanguage(MethodCall call) {
        Integer language = call.argument("language");
        language = language == null ? CRPDeviceLanguageType.LANGUAGE_CHINESE : language;
        // 简体中文设置为中文版，非简体中文设置为国际版
        byte version = CRPDeviceVersionType.INTERNATIONAL_EDITION;
        if (language == CRPDeviceLanguageType.LANGUAGE_CHINESE) {
            version = CRPDeviceVersionType.CHINESE_EDITION;
        }
        Log.d(TAG,""+version);
        Log.d(TAG, ""+language.byteValue());
        bleConnection.sendDeviceVersion(version);
        bleConnection.sendDeviceLanguage(language.byteValue());
    }

    private void queryDeviceLanguage(MethodChannel.Result result) {
        bleConnection.queryDeviceLanguage((int type, int[] languageType) -> {

            DeviceLanguageBean deviceLanguage = new DeviceLanguageBean(type,languageType);
            String jsonStr = GsonUtils.get().toJson(deviceLanguage, DeviceLanguageBean.class);
            result.success(jsonStr);
        });
    }

    //2.18 Notification
    //打开或关闭其他消息
    private void sendOtherMessageState(MethodCall call) {
        Boolean messageState = call.argument("messageState");
        messageState =   messageState != null && messageState;
        Log.d(TAG, ""+messageState);
        bleConnection.sendOtherMessageState(messageState);
    }

    //查询其他消息启用状态
    private void queryOtherMessageState(MethodChannel.Result result) {
        bleConnection.queryOtherMessageState(result::success);
    }

    //向手表发送各种类型的消息内容
    private void sendMessage(MethodCall call) {
        String jsonStr = call.argument("messageInfo");
        Log.d(TAG, jsonStr);
        CRPMessageInfo messageInfo = GsonUtils.get().fromJson(jsonStr, CRPMessageInfo.class);
        bleConnection.sendMessage(messageInfo);
    }

    //当手表连接或手机挂断时，呼叫此接口停止手表振动 -------有问题
    private void sendCall0ffHook() {
        Log.d("---sendCall0ffHook:---", "----");
        bleConnection.sendCall0ffHook();
    }

    //2.19 Sedentary reminder
    //久坐不动的提醒器是否打开
    private void sendSedentaryReminder(MethodCall call) {
        Boolean sedentaryReminder = call.argument("sedentaryReminder");
        sedentaryReminder =   sedentaryReminder != null && sedentaryReminder;
        Log.d(TAG,""+sedentaryReminder);
        bleConnection.sendSedentaryReminder(sedentaryReminder);
    }

    //查询久坐提醒器状态
    private void querySedentaryReminder(MethodChannel.Result result) {
        bleConnection.querySedentaryReminder(result::success);
    }

    //设置久坐提醒的有效期
    private void sendSedentaryReminderPeriod(MethodCall call) {
        String jsonStr = call.argument("crpSedentaryReminderPeriodInfo");
        Log.d(TAG, jsonStr);
        CRPSedentaryReminderPeriodInfo sedentaryReminderPeriodInfo =
                GsonUtils.get().fromJson(jsonStr, CRPSedentaryReminderPeriodInfo.class);
        bleConnection.sendSedentaryReminderPeriod(sedentaryReminderPeriodInfo);
    }

    //获得久坐不动的提醒时间
    private void querySedentaryReminderPeriod(MethodChannel.Result result) {
        bleConnection.querySedentaryReminderPeriod(crpSedentaryReminderPeriodInfo -> {
            String jsonStr = GsonUtils.get().toJson(crpSedentaryReminderPeriodInfo, CRPSedentaryReminderPeriodInfo.class);
            result.success(jsonStr);
        });
    }

    //2.20 寻找手表，在收到这个命令后，手表会振动几秒钟
    private void findDevice() {
        Log.d("findDevice------", "----");
        bleConnection.findDevice();
    }

    //2.27 Shut down 手表关机
    private void shutDown() {
        Log.d("shutDown------", "------");
        bleConnection.shutDown();
    }

    //2.28 免打扰
    private void sendDoNotDisturbTime(MethodCall call) {
        String jsonStr = call.argument("crpPeriodTimeInfo");
        Log.d(TAG, jsonStr);
        CRPPeriodTimeInfo crpPeriodTimeInfo =
                GsonUtils.get().fromJson(jsonStr, CRPPeriodTimeInfo.class);
        bleConnection.sendDoNotDistrubTime(crpPeriodTimeInfo);
    }

    private void queryDoNotDisturbTime(MethodChannel.Result result){
        bleConnection.queryDoNotDistrubTime((periodTimeType, periodTimeInfo) -> {
            PeriodTimeBean doNotDisturbTime = new PeriodTimeBean(periodTimeType,periodTimeInfo);
            String jsonStr = GsonUtils.get().toJson(doNotDisturbTime, PeriodTimeBean.class);
            Log.i(TAG, "onPeriodTime: " + jsonStr);
            result.success(jsonStr);
        });
    }

    //2.29 呼吸灯
    // 呼吸灯是否打开
    private void sendBreathingLight(MethodCall call) {
        Boolean breathingLight = call.argument("breathingLight");
        breathingLight = breathingLight != null && breathingLight;
        Log.d("sendBreathingLight-----", "" + breathingLight);
        bleConnection.sendBreathingLight(breathingLight);
    }

    private void queryBreathingLight(MethodChannel.Result result) {
        Log.d("queryBreathingLight---", "-----");
        bleConnection.queryBreathingLight(result::success);
    }

    //xulei:end
}
