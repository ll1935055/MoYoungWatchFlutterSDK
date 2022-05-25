package com.moyoung.moyoung_ble_plugin.base;

import android.app.Activity;
import android.content.Context;

import com.crrepa.ble.CRPBleClient;


public abstract class BaseChlHandler {

    protected Activity activity;
    protected CRPBleClient bleClient;

    public void bindActivity(Activity activity) {
        this.activity = activity;
        bleClient = getBleClient(activity.getApplicationContext());
    }

    private CRPBleClient getBleClient(Context context) {
        return CRPBleClient.create(context.getApplicationContext());
    }
}
