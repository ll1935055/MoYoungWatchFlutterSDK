package com.moyoung.moyoung_ble_plugin.conn;

import com.crrepa.ble.conn.CRPBleConnection;
import com.crrepa.ble.conn.bean.CRPTempInfo;
import com.crrepa.ble.conn.listener.CRPTempChangeListener;
import com.moyoung.moyoung_ble_plugin.base.BaseConnEveChlHandler;
import com.moyoung.moyoung_ble_plugin.common.GsonUtils;

import io.flutter.plugin.common.MethodCall;

public class TempChangeHandler extends BaseConnEveChlHandler {
    @Override
    public void setConnListener(CRPBleConnection connection, MethodCall call) {
        connection.setTempChangeListener(new CRPTempChangeListener() {
            public void onContinueState(boolean isContinue) {
                String jsonStr = GsonUtils.get().toJson(isContinue, boolean.class);
                activity.runOnUiThread(() -> eventSink.success(jsonStr));
            }

            public void onMeasureTemp(float var1) {
                String jsonStr = GsonUtils.get().toJson(var1, float.class);
                activity.runOnUiThread(() -> eventSink.success(jsonStr));
            }

            public void onMeasureState(boolean var1) {
                String jsonStr = GsonUtils.get().toJson(var1, boolean.class);
                activity.runOnUiThread(() -> eventSink.success(jsonStr));
            }

            public void onContinueTemp(CRPTempInfo var1) {
                String jsonStr = GsonUtils.get().toJson(var1, CRPTempInfo.class);
                activity.runOnUiThread(() -> eventSink.success(jsonStr));
            }
        });
    }
}
