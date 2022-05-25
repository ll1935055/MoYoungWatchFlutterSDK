package com.moyoung.moyoung_ble_plugin.conn;

import com.crrepa.ble.conn.CRPBleConnection;
import com.crrepa.ble.conn.bean.CRPHeartRateInfo;
import com.crrepa.ble.conn.bean.CRPHistoryHeartRateInfo;
import com.crrepa.ble.conn.bean.CRPMovementHeartRateInfo;
import com.crrepa.ble.conn.listener.CRPHeartRateChangeListener;
import com.crrepa.ble.conn.type.CRPHistoryDynamicRateType;
import com.moyoung.moyoung_ble_plugin.base.BaseConnEveChlHandler;
import com.moyoung.moyoung_ble_plugin.common.GsonUtils;
import com.moyoung.moyoung_ble_plugin.conn.model.HeartRateBean;

import java.util.List;
import android.util.Log;

import io.flutter.plugin.common.MethodCall;

class HeartRateHandler extends BaseConnEveChlHandler {
    private final static String TAG = HeartRateHandler.class.getSimpleName();

    @Override
    public void setConnListener(CRPBleConnection connection, MethodCall call) {
        connection.setHeartRateChangeListener(new CRPHeartRateChangeListener() {
            @Override
            public void onMeasuring(int measuring) {
                HeartRateBean heartRateBean =new HeartRateBean(true);
                heartRateBean.setMeasuring(measuring);
                String heartRateStr=GsonUtils.get().toJson(heartRateBean, HeartRateBean.class);
                activity.runOnUiThread(() -> eventSink.success(heartRateStr));
            }

            @Override
            public void onOnceMeasureComplete(int onceMeasureComplete) {
                HeartRateBean heartRateBean =new HeartRateBean(true);
                heartRateBean.setOnceMeasureComplete(onceMeasureComplete);
                String heartRateStr=GsonUtils.get().toJson(heartRateBean, HeartRateBean.class);
                Log.d(TAG, "onOnceMeasureComplete: "+heartRateStr);
                activity.runOnUiThread(() -> eventSink.success(heartRateStr));
            }

            @Override
            public void onHistoryHeartRate(List<CRPHistoryHeartRateInfo> historyHRList) {
                HeartRateBean heartRateBean =new HeartRateBean(true);
                heartRateBean.setHistoryHRList(historyHRList);
                String heartRateStr=GsonUtils.get().toJson(heartRateBean, HeartRateBean.class);
                activity.runOnUiThread(() -> eventSink.success(heartRateStr));
            }

            @Override
            public void onMeasureComplete(CRPHistoryDynamicRateType crpHistoryDynamicRateType,
                                          CRPHeartRateInfo crpHeartRateInfo) {
                HeartRateBean heartRateBean =new HeartRateBean(true);
                heartRateBean.setHistoryDynamicRateType(crpHistoryDynamicRateType);
                heartRateBean.setMeasureComplete(crpHeartRateInfo);
                String heartRateStr=GsonUtils.get().toJson(heartRateBean, HeartRateBean.class);
                activity.runOnUiThread(() -> eventSink.success(heartRateStr));
            }

            @Override
            public void on24HourMeasureResult(CRPHeartRateInfo crpHeartRateInfo) {
                HeartRateBean heartRateBean =new HeartRateBean(true);
                heartRateBean.setHour24MeasureResult(crpHeartRateInfo);
                String heartRateStr=GsonUtils.get().toJson(heartRateBean, HeartRateBean.class);
                activity.runOnUiThread(() -> eventSink.success(heartRateStr));
            }

            @Override
            public void onMovementMeasureResult(List<CRPMovementHeartRateInfo> movementMeasureList) {
                HeartRateBean heartRateBean =new HeartRateBean(true);
                heartRateBean.setMovementList(movementMeasureList);
                String heartRateStr=GsonUtils.get().toJson(heartRateBean, HeartRateBean.class);
                activity.runOnUiThread(() -> eventSink.success(heartRateStr));
            }
        });
    }

}

