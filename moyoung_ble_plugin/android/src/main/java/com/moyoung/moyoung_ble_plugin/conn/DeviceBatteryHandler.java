package com.moyoung.moyoung_ble_plugin.conn;

import com.crrepa.ble.conn.CRPBleConnection;
import com.crrepa.ble.conn.listener.CRPDeviceBatteryListener;
import com.moyoung.moyoung_ble_plugin.base.BaseConnEveChlHandler;

import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.MethodCall;

class DeviceBatteryHandler extends BaseConnEveChlHandler {
    @Override
    public void setConnListener(CRPBleConnection connection, MethodCall call) {
        Map<String, Object> mapStr = new HashMap<>();
        connection.setDeviceBatteryListener(new CRPDeviceBatteryListener() {
            @Override
            public void onSubscribe(boolean b) {
                mapStr.clear();
                mapStr.put("subscribe", b);
                activity.runOnUiThread(() -> eventSink.success(mapStr));
            }

            @Override
            public void onDeviceBattery(int i) {
                mapStr.clear();
                mapStr.put("deviceBattery", i);
                activity.runOnUiThread(() -> eventSink.success(mapStr));
            }
        });
    }

}

