package com.moyoung.moyoung_ble_plugin.conn;

import com.crrepa.ble.conn.CRPBleConnection;
import com.crrepa.ble.conn.listener.CRPWeatherChangeListener;
import com.moyoung.moyoung_ble_plugin.base.BaseConnEveChlHandler;

import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.MethodCall;

class WeatherChangeHandler extends BaseConnEveChlHandler {
    @Override
    public void setConnListener(CRPBleConnection connection, MethodCall call) {
        Map<String, Object> mapStr = new HashMap<>();
        connection.setWeatherChangeListener(new CRPWeatherChangeListener() {
            @Override
            public void onUpdateWeather() {
                mapStr.clear();
                mapStr.put("updateWeather",true);
                activity.runOnUiThread(() -> eventSink.success(mapStr));
            }

            @Override
            public void onTempUnitChange(int i) {
                mapStr.clear();
                mapStr.put("tempUnitChange", i);
                activity.runOnUiThread(() -> eventSink.success(mapStr));
            }
        });
    }

}

