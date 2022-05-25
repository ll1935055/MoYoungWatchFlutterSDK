package com.moyoung.moyoung_ble_plugin.conn;

import com.crrepa.ble.conn.CRPBleConnection;
import com.crrepa.ble.conn.bean.CRPSleepInfo;
import com.crrepa.ble.conn.listener.CRPSleepChangeListener;
import com.moyoung.moyoung_ble_plugin.base.BaseConnEveChlHandler;
import com.moyoung.moyoung_ble_plugin.common.GsonUtils;
import com.moyoung.moyoung_ble_plugin.conn.model.SleepBean;

import io.flutter.plugin.common.MethodCall;

class SleepChangeHandler extends BaseConnEveChlHandler {
    @Override
    public void setConnListener(CRPBleConnection connection, MethodCall call) {
        connection.setSleepChangeListener(new CRPSleepChangeListener() {
            @Override
            public void onSleepChange(CRPSleepInfo crpSleepInfo) {
                SleepBean sleepBean =new SleepBean(true);
                sleepBean.setSleepInfo(crpSleepInfo);
                String sleepStr = GsonUtils.get().toJson(sleepBean, SleepBean.class);
                activity.runOnUiThread(() -> eventSink.success(sleepStr));
            }

            @Override
            public void onPastSleepChange(int i, CRPSleepInfo crpSleepInfo) {
                SleepBean sleepBean =new SleepBean(true);
                sleepBean.setPast(i);
                sleepBean.setPastSleepInfo(crpSleepInfo);
                String sleepStr = GsonUtils.get().toJson(sleepBean, SleepBean.class);
                activity.runOnUiThread(() -> eventSink.success(sleepStr));
            }
        });
    }

}
