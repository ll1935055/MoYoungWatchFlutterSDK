package com.moyoung.moyoung_ble_plugin.conn;

import com.crrepa.ble.conn.CRPBleConnection;
import com.crrepa.ble.conn.bean.CRPBloodPressureInfo;
import com.crrepa.ble.conn.bean.CRPHistoryBloodPressureInfo;
import com.crrepa.ble.conn.listener.CRPBloodPressureChangeListener;
import com.moyoung.moyoung_ble_plugin.base.BaseConnEveChlHandler;
import com.moyoung.moyoung_ble_plugin.common.GsonUtils;
import com.moyoung.moyoung_ble_plugin.conn.model.BloodPressureBean;

import java.util.List;

import io.flutter.plugin.common.MethodCall;

public class BloodPressureHandler extends BaseConnEveChlHandler {
    @Override
    public void setConnListener(CRPBleConnection connection, MethodCall call) {
        connection.setBloodPressureChangeListener(
                new CRPBloodPressureChangeListener() {
                    @Override
                    public void onContinueState(boolean continueState) {
                        BloodPressureBean bloodPressureBean = new BloodPressureBean(true);
                        bloodPressureBean.setContinueState(continueState);
                        String bpStr = GsonUtils.get().toJson(bloodPressureBean, BloodPressureBean.class);
                        activity.runOnUiThread(() -> eventSink.success(bpStr));
                    }

                    @Override
                    public void onBloodPressureChange(int bloodPressure, int bloodPressure1) {
                        BloodPressureBean bloodPressureBean = new BloodPressureBean(true);
                        bloodPressureBean.setBloodPressureChange(bloodPressure);
                        bloodPressureBean.setBloodPressureChange1(bloodPressure1);
                        String bpStr = GsonUtils.get().toJson(bloodPressureBean, BloodPressureBean.class);
                        activity.runOnUiThread(() -> eventSink.success(bpStr));
                    }

                    @Override
                    public void onHistoryBloodPressure(List<CRPHistoryBloodPressureInfo> historyBPList) {
                        BloodPressureBean bloodPressureBean = new BloodPressureBean(true);
                        bloodPressureBean.setHistoryBPList(historyBPList);
                        String bpStr = GsonUtils.get().toJson(bloodPressureBean, BloodPressureBean.class);
                        activity.runOnUiThread(() -> eventSink.success(bpStr));
                    }

                    @Override
                    public void onContinueBloodPressure(CRPBloodPressureInfo crpBloodPressureInfo) {
                        BloodPressureBean bloodPressureBean = new BloodPressureBean(true);
                        bloodPressureBean.setContinueBP(crpBloodPressureInfo);
                        String bpStr = GsonUtils.get().toJson(bloodPressureBean, BloodPressureBean.class);
                        activity.runOnUiThread(() -> eventSink.success(bpStr));
                    }
                }
        );
    }


}
