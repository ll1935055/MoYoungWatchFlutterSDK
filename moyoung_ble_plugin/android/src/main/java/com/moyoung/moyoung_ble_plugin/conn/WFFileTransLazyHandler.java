package com.moyoung.moyoung_ble_plugin.conn;

import android.util.Log;

import com.crrepa.ble.conn.CRPBleConnection;
import com.crrepa.ble.conn.bean.CRPCustomizeWatchFaceInfo;
import com.crrepa.ble.conn.listener.CRPFileTransListener;
import com.moyoung.moyoung_ble_plugin.base.BaseConnEveChlHandler;
import com.moyoung.moyoung_ble_plugin.common.GsonUtils;
import com.moyoung.moyoung_ble_plugin.conn.model.WFFileTransLazyBean;
import com.moyoung.moyoung_ble_plugin.conn.model.WatchFaceFlutterBean;

import java.io.File;
import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.MethodCall;

class WFFileTransLazyHandler extends BaseConnEveChlHandler {
    private final static String TAG = WFFileTransLazyHandler.class.getSimpleName();

    @Override
    public void setConnListener(CRPBleConnection connection, MethodCall call) {
        Map<String, Object> mapStr = new HashMap<>();
        Log.d(TAG, "ConnWFFileTransLazyEveChlHandler: +监听");
        String jsonStr = call.argument("watchFaceFlutterBean");
        Integer timeout = call.argument("timeout");
        timeout = timeout == null ? 30 : timeout;
        WatchFaceFlutterBean watchFaceFlutterBean = GsonUtils.get().fromJson(jsonStr, WatchFaceFlutterBean.class);
        File file = new File(watchFaceFlutterBean.getFile());
        WFFileTransLazyBean  transLazy = new WFFileTransLazyBean(true);
        CRPCustomizeWatchFaceInfo customizeWatchFaceInfo = new CRPCustomizeWatchFaceInfo(watchFaceFlutterBean.getIndex(), file);

        connection.sendWatchFace(customizeWatchFaceInfo, new CRPFileTransListener() {
            @Override
            public void onTransProgressStarting() {
                transLazy.setProgress(0);
                String jsonStr = GsonUtils.get().toJson(transLazy, WFFileTransLazyBean.class);
                activity.runOnUiThread(() -> eventSink.success(jsonStr));
            }

            @Override
            public void onTransProgressChanged(int progress) {
                transLazy.setProgress(progress);
                String jsonStr = GsonUtils.get().toJson(transLazy, WFFileTransLazyBean.class);
                activity.runOnUiThread(() -> eventSink.success(jsonStr));
            }

            @Override
            public void onTransCompleted() {
                transLazy.setProgress(100);
                String jsonStr = GsonUtils.get().toJson(transLazy, WFFileTransLazyBean.class);
                activity.runOnUiThread(() -> eventSink.success(jsonStr));
            }

            @Override
            public void onError(int error) {
                transLazy.setError(error);
                String jsonStr = GsonUtils.get().toJson(transLazy, WFFileTransLazyBean.class);
                activity.runOnUiThread(() -> eventSink.success(jsonStr));
            }
        }, timeout);
    }
}

