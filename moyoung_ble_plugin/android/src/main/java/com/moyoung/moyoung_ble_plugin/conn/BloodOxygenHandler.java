package com.moyoung.moyoung_ble_plugin.conn;

import com.crrepa.ble.conn.CRPBleConnection;
import com.crrepa.ble.conn.bean.CRPBloodOxygenInfo;
import com.crrepa.ble.conn.bean.CRPHistoryBloodOxygenInfo;
import com.crrepa.ble.conn.listener.CRPBloodOxygenChangeListener;
import com.moyoung.moyoung_ble_plugin.base.BaseConnEveChlHandler;
import com.moyoung.moyoung_ble_plugin.common.GsonUtils;
import com.moyoung.moyoung_ble_plugin.conn.model.BloodOxygenBean;

import java.util.List;

import io.flutter.plugin.common.MethodCall;

class BloodOxygenHandler extends BaseConnEveChlHandler {
    @Override
    public void setConnListener(CRPBleConnection connection, MethodCall call) {
        connection.setBloodOxygenChangeListener(new CRPBloodOxygenChangeListener() {
            @Override
            public void onContinueState(boolean continueState) {
                BloodOxygenBean bloodOxygenBean = new BloodOxygenBean(true);
                bloodOxygenBean.setContinueState(continueState);
                String boStr = GsonUtils.get().toJson(bloodOxygenBean, BloodOxygenBean.class);
                activity.runOnUiThread(() -> eventSink.success(boStr));
            }

            @Override
            public void onTimingMeasure(int timingMeasure) {
                BloodOxygenBean bloodOxygenBean = new BloodOxygenBean(true);
                bloodOxygenBean.setTimingMeasure(timingMeasure);
                String boStr = GsonUtils.get().toJson(bloodOxygenBean, BloodOxygenBean.class);
                activity.runOnUiThread(() -> eventSink.success(boStr));
            }

            @Override
            public void onBloodOxygen(int bloodOxygen) {
                BloodOxygenBean bloodOxygenBean = new BloodOxygenBean(true);
                bloodOxygenBean.setBloodOxygen(bloodOxygen);
                String boStr = GsonUtils.get().toJson(bloodOxygenBean, BloodOxygenBean.class);
                activity.runOnUiThread(() -> eventSink.success(boStr));
            }

            @Override
            public void onHistoryBloodOxygen(List<CRPHistoryBloodOxygenInfo> historyBOList) {
                BloodOxygenBean bloodOxygenBean = new BloodOxygenBean(true);
                bloodOxygenBean.setHistoryList(historyBOList);
                String boStr = GsonUtils.get().toJson(bloodOxygenBean, BloodOxygenBean.class);
                activity.runOnUiThread(() -> eventSink.success(boStr));
            }

            @Override
            public void onContinueBloodOxygen(CRPBloodOxygenInfo crpBloodOxygenInfo) {
                BloodOxygenBean bloodOxygenBean = new BloodOxygenBean(true);
                bloodOxygenBean.setContinueBO(crpBloodOxygenInfo);
                String boStr = GsonUtils.get().toJson(bloodOxygenBean, BloodOxygenBean.class);
                activity.runOnUiThread(() -> eventSink.success(boStr));
            }
        });


    }

}

