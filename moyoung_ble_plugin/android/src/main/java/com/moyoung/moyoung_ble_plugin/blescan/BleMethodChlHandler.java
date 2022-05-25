package com.moyoung.moyoung_ble_plugin.blescan;

import android.app.Activity;
import android.bluetooth.BluetoothAdapter;
import android.content.Intent;
import android.util.Log;

import com.moyoung.moyoung_ble_plugin.base.BaseChlHandler;
import com.moyoung.moyoung_ble_plugin.common.PermissionUtils;

import java.util.Map;

import androidx.annotation.NonNull;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

import static com.moyoung.moyoung_ble_plugin.common.PermissionUtils.PERMISSION_UPDATE_BAND_CONFIG;

public class BleMethodChlHandler extends BaseChlHandler implements MethodChannel.MethodCallHandler {
    private final BleScanEveChlHandler bleScanEveHandler;

    public BleMethodChlHandler(BleScanEveChlHandler bleScanEveHandler) {
        this.bleScanEveHandler = bleScanEveHandler;
    }

    @Override
    public void bindActivity(Activity activity) {
        super.bindActivity(activity);
        bleScanEveHandler.bindActivity(this.activity);
    }

    public void unbindMethodChannel(MethodChannel methodChannel, EventChannel eventChannel) {
        methodChannel.setMethodCallHandler(null);
        eventChannel.setStreamHandler(null);
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        switch (call.method) {
            case "startScan" :
                startScan(call, result);
                break;
            case "startScanWithPeriod" :
                startScan(call, result);
                break;
            case "cancelScan" :
                cancelScan(result);
                break;
        }
    }

    private void startScan(MethodCall call, MethodChannel.Result result) {

        boolean isNoPermissions = !PermissionUtils.hasSelfPermissions(
                activity.getApplicationContext(), PERMISSION_UPDATE_BAND_CONFIG);
        if (isNoPermissions) {
            sendNoPermissionMsg(result);
            return;
        }

        if (!checkBluetoothEnable()) {
            return;
        }
        Integer scanPeriod = call.argument("scanPeriod");
        if (scanPeriod == null || scanPeriod <= 0) {
            bleScanEveHandler.startScan();
        } else {
            bleScanEveHandler.startScan(scanPeriod);
        }
    }

    public void startScan(MethodCall call) {
        int scanPeriod = call.argument("scanPeriod");
        bleScanEveHandler.startScan(scanPeriod);
    }

    public void cancelScan(MethodChannel.Result result) {
        bleClient.cancelScan();
        result.success("cancelScan() Execute successfully");
    }

    private boolean checkBluetoothEnable() {
        if (!bleClient.isBluetoothEnable()) {
            Intent enableBtIntent = new Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE);
            activity.startActivity(enableBtIntent);
        }

        return bleClient.isBluetoothEnable();
    }

    private void sendNoPermissionMsg(MethodChannel.Result result) {
        Map<String, String> noPermissionMsgMap = PermissionUtils.getNoPermissionsMsg(
                activity.getApplicationContext(), PERMISSION_UPDATE_BAND_CONFIG);

        if (noPermissionMsgMap == null) {
            return;
        }

        String errorCode = noPermissionMsgMap.get("errorCode");
        String errorMessage = noPermissionMsgMap.get("errorMessage");
        result.error(errorCode, errorMessage, "omit");
    }
}
