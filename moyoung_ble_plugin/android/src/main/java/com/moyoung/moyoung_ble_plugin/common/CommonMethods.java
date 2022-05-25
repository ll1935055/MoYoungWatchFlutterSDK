package com.moyoung.moyoung_ble_plugin.common;

import android.content.Context;
import android.util.Log;

import com.crrepa.ble.CRPBleClient;
import com.crrepa.ble.conn.CRPBleConnection;
import com.crrepa.ble.conn.CRPBleDevice;

public class CommonMethods {
    public static CRPBleConnection connect(Context context, String deviceAddress) {
        CRPBleDevice bleDevice = getBleClient(context).getBleDevice(deviceAddress);
        if (bleDevice == null) {
            return null;
        }
        return bleDevice.connect();
    }

    public static CRPBleClient getBleClient(Context context) {
        return CRPBleClient.create(context.getApplicationContext());
    }
}
