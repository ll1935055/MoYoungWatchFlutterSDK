package com.moyoung.moyoung_ble_plugin.conn;

import com.crrepa.ble.conn.CRPBleConnection;
import com.crrepa.ble.conn.listener.CRPContactListener;
import com.moyoung.moyoung_ble_plugin.base.BaseConnEveChlHandler;

import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.MethodCall;

public class ContactHandler extends BaseConnEveChlHandler {
    Map<String, Object> mapStr = new HashMap<>();

    @Override
    public void setConnListener(CRPBleConnection connection, MethodCall call) {
        connection.setContactListener(new CRPContactListener() {
            @Override
            public void onSavedSuccess(int SavedSuccess) {
                mapStr.clear();
                mapStr.put("isSave", true);
                mapStr.put("savedSuccess", SavedSuccess);
                activity.runOnUiThread(() -> eventSink.success(mapStr));
            }

            @Override
            public void onSavedFail(int savedFail) {
                mapStr.clear();
                mapStr.put("isSave", false);
                mapStr.put("savedFail", savedFail);
                activity.runOnUiThread(() -> eventSink.success(mapStr));
            }
        });
    }
}
