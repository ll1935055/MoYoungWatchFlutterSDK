package com.moyoung.moyoung_ble_plugin.conn;

import android.app.Activity;
import android.content.Context;
import android.util.Log;

import com.crrepa.ble.CRPBleClient;
import com.crrepa.ble.conn.CRPBleConnection;
import com.crrepa.ble.conn.CRPBleDevice;
import com.moyoung.moyoung_ble_plugin.base.BaseConnEveChlHandler;

import java.util.ArrayList;
import java.util.List;

import androidx.annotation.NonNull;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;

import static com.moyoung.moyoung_ble_plugin.ChannelConstant.EVE_CHL_CONN_BLOOD_OXYGEN;
import static com.moyoung.moyoung_ble_plugin.ChannelConstant.EVE_CHL_CONN_BLOOD_PRESSURE;
import static com.moyoung.moyoung_ble_plugin.ChannelConstant.EVE_CHL_CONN_CAMERA;
import static com.moyoung.moyoung_ble_plugin.ChannelConstant.EVE_CHL_CONN_DEVICE_BATTERY;
import static com.moyoung.moyoung_ble_plugin.ChannelConstant.EVE_CHL_CONN_DEVICE_RSSI;
import static com.moyoung.moyoung_ble_plugin.ChannelConstant.EVE_CHL_CONN_PHONE;
import static com.moyoung.moyoung_ble_plugin.ChannelConstant.EVE_CHL_CONN_SLEEP_CHANGE;
import static com.moyoung.moyoung_ble_plugin.ChannelConstant.EVE_CHL_CONN_STATE;
import static com.moyoung.moyoung_ble_plugin.ChannelConstant.EVE_CHL_CONN_STEPS_CATEGORY;
import static com.moyoung.moyoung_ble_plugin.ChannelConstant.EVE_CHL_CONN_STEP_CHANGE;
import static com.moyoung.moyoung_ble_plugin.ChannelConstant.EVE_CHL_CONN_HEART_RATE;
import static com.moyoung.moyoung_ble_plugin.ChannelConstant.EVE_CHL_CONN_MOVEMENT_STATE;
import static com.moyoung.moyoung_ble_plugin.ChannelConstant.EVE_CHL_CONN_TEMP_CHANGE;
import static com.moyoung.moyoung_ble_plugin.ChannelConstant.EVE_CHL_CONN_CONTACT;
import static com.moyoung.moyoung_ble_plugin.ChannelConstant.EVE_CHL_CONN_BATTERY_SAVING;
import static com.moyoung.moyoung_ble_plugin.ChannelConstant.EVE_CHL_CONN_TRAIN;
import static com.moyoung.moyoung_ble_plugin.ChannelConstant.EVE_CHL_CONN_WEATHER_CHANGE;
import static com.moyoung.moyoung_ble_plugin.ChannelConstant.LAZY_EVE_CHL_CONN_CONTACT_AVATAR;
import static com.moyoung.moyoung_ble_plugin.ChannelConstant.LAZY_EVE_CHL_CONN_EGC;
import static com.moyoung.moyoung_ble_plugin.ChannelConstant.LAZY_EVE_CHL_CONN_FILE_TRANS;
import static com.moyoung.moyoung_ble_plugin.ChannelConstant.LAZY_EVE_CHL_CONN_FIRMWARE_UPGRADE;
import static com.moyoung.moyoung_ble_plugin.ChannelConstant.LAZY_EVE_CHL_CONN_WF_FILE_TRANS;

public class ConnEveChlRegister {
    private final static String TAG = ConnEveChlRegister.class.getSimpleName();

    private final List<EventChannel> eveChlList = new ArrayList<>();
    private final List<BaseConnEveChlHandler> defaultConnHandlerList = new ArrayList<>();
    private final List<BaseConnEveChlHandler> connLazyHandlerList = new ArrayList<>();
    private final BinaryMessenger binaryMgr;

    public ConnEveChlRegister(BinaryMessenger binaryMessenger) {
        this.binaryMgr = binaryMessenger;
    }

    public void register() {
        registerEveChl(new ConnectionStateHandler(), EVE_CHL_CONN_STATE);
        registerEveChl(new StepChangeHandler(), EVE_CHL_CONN_STEP_CHANGE);
        //余诗霞补充
        registerEveChl(new DeviceBatteryHandler(), EVE_CHL_CONN_DEVICE_BATTERY);
        registerEveChl(new WeatherChangeHandler(), EVE_CHL_CONN_WEATHER_CHANGE);
        registerEveChl(new StepsCategoryHandler(), EVE_CHL_CONN_STEPS_CATEGORY);
        registerEveChl(new SleepChangeHandler(), EVE_CHL_CONN_SLEEP_CHANGE);
        registerLazyEveChl(new FileFirmwareUpgradeHandler(), LAZY_EVE_CHL_CONN_FIRMWARE_UPGRADE);
        //余诗霞：start
        registerEveChl(new HeartRateHandler(), EVE_CHL_CONN_HEART_RATE);
        registerEveChl(new BloodPressureHandler(), EVE_CHL_CONN_BLOOD_PRESSURE);
        registerEveChl(new BloodOxygenHandler(), EVE_CHL_CONN_BLOOD_OXYGEN);
        registerEveChl(new CameraHandler(), EVE_CHL_CONN_CAMERA);
        registerEveChl(new PhoneHandler(), EVE_CHL_CONN_PHONE);
        registerEveChl(new DeviceRssiHandler(), EVE_CHL_CONN_DEVICE_RSSI);
        registerLazyEveChl(new FileTransLazyHandler(), LAZY_EVE_CHL_CONN_FILE_TRANS);
        registerLazyEveChl(new WFFileTransLazyHandler(), LAZY_EVE_CHL_CONN_WF_FILE_TRANS);
        registerLazyEveChl(new EGCHandler(), LAZY_EVE_CHL_CONN_EGC);
        //该监听为李宝忠的监听
        registerLazyEveChl(new ContactAvatarLazyHandler(), LAZY_EVE_CHL_CONN_CONTACT_AVATAR);
        //余诗霞：end
        // libaozhong: start
        registerEveChl(new MovementStateHandler(), EVE_CHL_CONN_MOVEMENT_STATE);
        registerEveChl(new TempChangeHandler(), EVE_CHL_CONN_TEMP_CHANGE);
        registerEveChl(new ContactHandler(), EVE_CHL_CONN_CONTACT);
        registerEveChl(new BatterySavingHandler(), EVE_CHL_CONN_BATTERY_SAVING);
        registerEveChl(new TrainHandler(), EVE_CHL_CONN_TRAIN);
        // libaozhong: end
    }

    public void unregister() {
        for (EventChannel eventChannel : eveChlList) {
            eventChannel.setStreamHandler(null);
        }
    }

    public void bindActivity(Activity activity) {
        for (BaseConnEveChlHandler chlHandler : defaultConnHandlerList) {
            chlHandler.bindActivity(activity);
        }
        for (BaseConnEveChlHandler chlHandler : connLazyHandlerList) {
            chlHandler.bindActivity(activity);
        }
    }

    public BaseConnEveChlHandler getEveChlHandler(String chlName) {
        for (BaseConnEveChlHandler baseConnEveChlHandler : defaultConnHandlerList) {
            if (chlName.equals(baseConnEveChlHandler.getBelongChl())) {
                return baseConnEveChlHandler;
            }
        }

        return null;
    }

    public BaseConnEveChlHandler getLazyEveChlHandler(String chlName) {
        for (BaseConnEveChlHandler baseConnLazyEveChlHandler : connLazyHandlerList) {
            if (chlName.equals(baseConnLazyEveChlHandler.getBelongChl())) {
                return baseConnLazyEveChlHandler;
            }
        }

        return null;
    }

    public CRPBleConnection connect(@NonNull MethodCall call, Context context) {
        String address = call.argument("address");
        CRPBleDevice bleDevice = CRPBleClient.create(context.getApplicationContext()).getBleDevice(address);
        if (bleDevice == null) {
            Log.d(TAG, "CRPBleDevice获取为空");
            return null;
        }
        CRPBleConnection connection = bleDevice.connect();
        if (connection == null) {
            Log.d(TAG, "Connection获取为空");
            return null;
        }

        for (BaseConnEveChlHandler handler : defaultConnHandlerList) {
            handler.setConnListener(connection, call);
        }
        return connection;
    }

    private void registerEveChl(BaseConnEveChlHandler eveChlHandler, String chlName) {
        EventChannel bleConnectEveChl = new EventChannel(binaryMgr, chlName);
        bleConnectEveChl.setStreamHandler(eveChlHandler);

        eveChlHandler.setBelongChl(chlName);

        eveChlList.add(bleConnectEveChl);
        defaultConnHandlerList.add(eveChlHandler);
    }

    private void registerLazyEveChl(BaseConnEveChlHandler lazyEveChlHandler, String chlName) {
        EventChannel bleConnectEveChl = new EventChannel(binaryMgr, chlName);
        bleConnectEveChl.setStreamHandler(lazyEveChlHandler);

        lazyEveChlHandler.setBelongChl(chlName);

        eveChlList.add(bleConnectEveChl);
        connLazyHandlerList.add(lazyEveChlHandler);
    }
}
