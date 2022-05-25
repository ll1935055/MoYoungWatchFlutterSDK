package com.moyoung.moyoung_ble_plugin;

import android.app.Activity;
import android.util.Log;

import com.moyoung.moyoung_ble_plugin.blescan.BleMethodChlHandler;
import com.moyoung.moyoung_ble_plugin.blescan.BleScanEveChlHandler;
import com.moyoung.moyoung_ble_plugin.conn.ConnEveChlRegister;
import com.moyoung.moyoung_ble_plugin.conn.ConnMethodChlHandler;

import androidx.annotation.NonNull;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodChannel;

import static com.moyoung.moyoung_ble_plugin.ChannelConstant.EVE_CHL_BLE_SCAN;
import static com.moyoung.moyoung_ble_plugin.ChannelConstant.METHOD_CHL_BLE_SCAN;
import static com.moyoung.moyoung_ble_plugin.ChannelConstant.METHOD_CHL_CONN;

/**
 * MoyoungBlePlugin
 */
public class MoyoungBlePlugin implements FlutterPlugin, ActivityAware {
    
    private final static String TAG = MoyoungBlePlugin.class.getSimpleName();
    private Activity activity;
    private BinaryMessenger binaryMgr;

    private MethodChannel bleScanMethodChannel;
    private EventChannel bleScanEveChl;
    private BleMethodChlHandler bleMethodHandler;

    private MethodChannel connMethodChannel;
    private ConnMethodChlHandler connMethodChlHandler;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        Log.d(TAG, "onAttachedToEngine");
        binaryMgr = binding.getBinaryMessenger();

        BleScanEveChlHandler bleScanEveChlHandler = registerScanEveChl();
        registerBleScanMethodChl(bleScanEveChlHandler);

        registerConnMethodChl();
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        bleMethodHandler.unbindMethodChannel(bleScanMethodChannel, bleScanEveChl);
        connMethodChlHandler.unbindChannel(connMethodChannel);
    }

    private void registerBleScanMethodChl(BleScanEveChlHandler bleScanEveChlHandler ) {
        bleMethodHandler = new BleMethodChlHandler(bleScanEveChlHandler);
        bleScanMethodChannel = new MethodChannel(binaryMgr, METHOD_CHL_BLE_SCAN);
        bleScanMethodChannel.setMethodCallHandler(bleMethodHandler);
    }

    private void registerConnMethodChl() {
        ConnEveChlRegister connEveChlRegister = new ConnEveChlRegister(binaryMgr);
        connEveChlRegister.register();

        connMethodChlHandler = new ConnMethodChlHandler(connEveChlRegister);
        connMethodChannel = new MethodChannel(binaryMgr, METHOD_CHL_CONN);
        connMethodChannel.setMethodCallHandler(connMethodChlHandler);
    }

    private BleScanEveChlHandler registerScanEveChl() {
        BleScanEveChlHandler bleScanEveChlHandler = new BleScanEveChlHandler();
        bleScanEveChl = new EventChannel(binaryMgr, EVE_CHL_BLE_SCAN);
        bleScanEveChl.setStreamHandler(bleScanEveChlHandler);

        return bleScanEveChlHandler;
    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        Log.d(TAG, "onAttachedToActivity");
        activity = binding.getActivity();

        bleMethodHandler.bindActivity(activity);
        connMethodChlHandler.bindActivity(activity);
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
    }

    @Override
    public void onDetachedFromActivity() {
        activity = null;
    }

}
