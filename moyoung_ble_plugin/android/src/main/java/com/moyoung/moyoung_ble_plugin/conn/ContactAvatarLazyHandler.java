package com.moyoung.moyoung_ble_plugin.conn;

import android.util.Log;

import com.crrepa.ble.conn.CRPBleConnection;
import com.crrepa.ble.conn.listener.CRPFileTransListener;
import com.moyoung.moyoung_ble_plugin.base.BaseConnEveChlHandler;
import com.moyoung.moyoung_ble_plugin.common.GsonUtils;
import com.moyoung.moyoung_ble_plugin.conn.model.ContactBean;

import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.MethodCall;

class ContactAvatarLazyHandler extends BaseConnEveChlHandler {
    Map<String, Object> mapStr = new HashMap<>();
    private final static String TAG = ContactAvatarLazyHandler.class.getSimpleName();

    @Override
    public void setConnListener(CRPBleConnection connection, MethodCall call) {
        String jsonStr = call.argument("contactBean");
        Log.d(TAG, jsonStr);
        ContactBean contactBean = GsonUtils.get().fromJson(jsonStr, ContactBean.class);
        connection.sendContactAvatar(contactBean.getId(),  contactBean.getAvatar(),
                contactBean.getTimeout(),  new CRPFileTransListener() {
            @Override
            public void onTransProgressStarting() {
                mapStr.clear();
                mapStr.put("isError", false);
                mapStr.put("progress", 0);
                activity.runOnUiThread(() -> eventSink.success(mapStr));
            }

            @Override
            public void onTransProgressChanged(int progress) {
                mapStr.clear();
                mapStr.put("isError", false);
                mapStr.put("progress", progress);
                activity.runOnUiThread(() -> eventSink.success(mapStr));
            }

            @Override
            public void onTransCompleted() {
                mapStr.clear();
                mapStr.put("isError", false);
                mapStr.put("progress", 100);
                activity.runOnUiThread(() -> eventSink.success(mapStr));
            }

            @Override
            public void onError(int i) {
                mapStr.clear();
                mapStr.put("isError", true);
                mapStr.put("progress", i);
                activity.runOnUiThread(() -> eventSink.success(mapStr));
            }
        });
    }

}

