package com.moyoung.moyoung_ble_plugin.conn;

import com.crrepa.ble.conn.CRPBleConnection;
import com.crrepa.ble.conn.bean.CRPStepsCategoryInfo;
import com.moyoung.moyoung_ble_plugin.base.BaseConnEveChlHandler;
import com.moyoung.moyoung_ble_plugin.common.GsonUtils;

import io.flutter.plugin.common.MethodCall;

class StepsCategoryHandler extends BaseConnEveChlHandler {
    @Override
    public void setConnListener(CRPBleConnection connection, MethodCall call) {
        connection.setStepsCategoryListener(crpStepsCategoryInfo -> {
            String stepStr = GsonUtils.get().toJson(crpStepsCategoryInfo, CRPStepsCategoryInfo.class);
            activity.runOnUiThread(() -> eventSink.success(stepStr));
        });
    }

}
