package com.moyoung.moyoung_ble_plugin.conn;

import android.app.Activity;

import com.crrepa.ble.conn.listener.CRPBleFirmwareUpgradeListener;

import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.EventChannel;

public class firmwareUpgradeListener implements CRPBleFirmwareUpgradeListener {
    Map<String, Object> mapStr = new HashMap<>();
    protected EventChannel.EventSink eventSink;
    protected Activity activity;

    public firmwareUpgradeListener(EventChannel.EventSink eventSink, Activity activity) {
        this.eventSink = eventSink;
        this.activity = activity;
    }

    @Override
    public void onFirmwareDownloadStarting() {
        mapStr.clear();
        mapStr.put("firmwareDownload", 1);
        activity.runOnUiThread(() -> eventSink.success(mapStr));
    }

    @Override
    public void onFirmwareDownloadComplete() {
        mapStr.clear();
        mapStr.put("firmwareDownload", 100);
        activity.runOnUiThread(() -> eventSink.success(mapStr));
    }

    @Override
    public void onUpgradeProgressStarting() {
        mapStr.clear();
        mapStr.put("upgradeProgress", 1);
        activity.runOnUiThread(() -> eventSink.success(mapStr));
    }

    @Override
    public void onUpgradeProgressChanged(int i, float v) {
        mapStr.clear();
        mapStr.put("upgradeProgressInt", i);
        mapStr.put("upgradeProgressFloat", v);
        activity.runOnUiThread(() -> eventSink.success(mapStr));
    }

    @Override
    public void onUpgradeCompleted() {
        mapStr.clear();
        mapStr.put("upgradeProgress", 100);
        activity.runOnUiThread(() -> eventSink.success(mapStr));
    }

    @Override
    public void onUpgradeAborted() {
        mapStr.clear();
        mapStr.put("isUpgradeAborted", true);
        activity.runOnUiThread(() -> eventSink.success(mapStr));
    }

    @Override
    public void onError(int i, String s) {
        mapStr.clear();
        mapStr.put("error", i);
        mapStr.put("errorContent", s);
        activity.runOnUiThread(() -> eventSink.success(mapStr));
    }
}
