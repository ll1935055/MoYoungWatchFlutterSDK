package com.moyoung.moyoung_ble_plugin.conn;

import com.crrepa.ble.conn.CRPBleConnection;
import com.crrepa.ble.conn.bean.CRPStepInfo;
import com.crrepa.ble.conn.listener.CRPStepChangeListener;
import com.moyoung.moyoung_ble_plugin.base.BaseConnEveChlHandler;
import com.moyoung.moyoung_ble_plugin.common.GsonUtils;
import com.moyoung.moyoung_ble_plugin.conn.model.StepChangeBean;

import io.flutter.plugin.common.MethodCall;

class StepChangeHandler extends BaseConnEveChlHandler {
    @Override
    public void setConnListener(CRPBleConnection connection, MethodCall call) {
        connection.setStepChangeListener(new CRPStepChangeListener() {
            @Override
            public void onStepChange(CRPStepInfo crpStepInfo) {
                StepChangeBean stepChangeBean = new StepChangeBean(true);
                stepChangeBean.setStepInfo(crpStepInfo);
                String stepStr = GsonUtils.get().toJson(stepChangeBean, StepChangeBean.class);
                activity.runOnUiThread(() -> eventSink.success(stepStr));
            }

            @Override
            public void onPastStepChange(int past, CRPStepInfo pastStepInfo) {
                StepChangeBean stepChangeBean = new StepChangeBean(true);
                stepChangeBean.setPast(past);
                stepChangeBean.setPastStepInfo(pastStepInfo);
                String stepStr = GsonUtils.get().toJson(stepChangeBean, StepChangeBean.class);
                activity.runOnUiThread(() -> eventSink.success(stepStr));
            }
        });
    }

}
