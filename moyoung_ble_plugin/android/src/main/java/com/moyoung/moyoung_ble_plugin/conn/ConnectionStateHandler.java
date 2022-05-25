package com.moyoung.moyoung_ble_plugin.conn;

import android.util.Log;

import com.crrepa.ble.conn.CRPBleConnection;
import com.moyoung.moyoung_ble_plugin.base.BaseConnEveChlHandler;

import io.flutter.plugin.common.MethodCall;

class ConnectionStateHandler extends BaseConnEveChlHandler {
    private final static String TAG = ConnectionStateHandler.class.getSimpleName();

    @Override
    public void setConnListener(CRPBleConnection connection, MethodCall call) {
        connection.setConnectionStateListener(newState -> {
            Log.d(TAG, "onConnectionStateChange: " + newState);
            activity.runOnUiThread(() -> eventSink.success(newState));
        });
    }

}
