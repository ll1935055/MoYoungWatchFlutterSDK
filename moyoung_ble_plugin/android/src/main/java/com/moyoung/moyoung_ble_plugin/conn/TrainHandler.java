package com.moyoung.moyoung_ble_plugin.conn;

import com.crrepa.ble.conn.CRPBleConnection;
import com.crrepa.ble.conn.bean.CRPHistoryTrainingInfo;
import com.crrepa.ble.conn.bean.CRPTrainingInfo;
import com.crrepa.ble.conn.listener.CRPTrainingChangeListener;
import com.moyoung.moyoung_ble_plugin.base.BaseConnEveChlHandler;
import com.moyoung.moyoung_ble_plugin.common.GsonUtils;
import com.moyoung.moyoung_ble_plugin.conn.model.TrainBean;

import java.util.List;

import io.flutter.plugin.common.MethodCall;

public class TrainHandler extends BaseConnEveChlHandler {
    TrainBean trainBean = new TrainBean();
    @Override
    public void setConnListener(CRPBleConnection connection, MethodCall call) {
        connection.setTrainingListener(new CRPTrainingChangeListener() {
            @Override
            public void onHistoryTrainingChange(List<CRPHistoryTrainingInfo> historyTrainList) {
                trainBean.setHistoryTrainList(historyTrainList);
                String jsonStr = GsonUtils.get().toJson(trainBean, TrainBean.class);
                activity.runOnUiThread(() -> eventSink.success(jsonStr));
            }

            @Override
            public void onTrainingChange(CRPTrainingInfo info) {
                trainBean.setTrainingInfo(info);
                String jsonStr = GsonUtils.get().toJson(trainBean, TrainBean.class);
                activity.runOnUiThread(() -> eventSink.success(jsonStr));
            }
        });
    }
}
