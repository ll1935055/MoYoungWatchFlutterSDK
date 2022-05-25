package com.moyoung.moyoung_ble_plugin.base;

import com.crrepa.ble.conn.CRPBleConnection;

import io.flutter.plugin.common.MethodCall;


public abstract class BaseConnEveChlHandler extends BaseEveChlHandler {
    public abstract void setConnListener(CRPBleConnection connection, MethodCall call);
}
