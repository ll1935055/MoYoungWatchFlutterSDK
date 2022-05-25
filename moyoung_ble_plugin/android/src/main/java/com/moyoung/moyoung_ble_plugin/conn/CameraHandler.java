package com.moyoung.moyoung_ble_plugin.conn;

import com.crrepa.ble.conn.CRPBleConnection;
import com.moyoung.moyoung_ble_plugin.base.BaseConnEveChlHandler;

import io.flutter.plugin.common.MethodCall;

class CameraHandler extends BaseConnEveChlHandler {
    @Override
    public void setConnListener(CRPBleConnection connection, MethodCall call) {
        connection.setCameraOperationListener(() -> activity.runOnUiThread(() -> eventSink.success("takePhoto"))
        );
    }

}

