package com.moyoung.moyoung_ble_plugin.base;

import android.util.Log;
import io.flutter.plugin.common.EventChannel;

public abstract class BaseEveChlHandler extends BaseChlHandler implements EventChannel.StreamHandler {
    private final static String TAG = BaseEveChlHandler.class.getSimpleName();

    protected EventChannel.EventSink eventSink;
    private String belongChl;//所属的渠道

    @Override
    public void onListen(Object arguments, EventChannel.EventSink events) {
        Log.d(TAG, "onListen");
        eventSink = events;
    }

    @Override
    public void onCancel(Object arguments) {
        Log.d(TAG, "onCancelEventSink");
        eventSink = null;
    }

    public String getBelongChl() {
        return belongChl;
    }

    public void setBelongChl(String belongChl) {
        this.belongChl = belongChl;
    }
}
