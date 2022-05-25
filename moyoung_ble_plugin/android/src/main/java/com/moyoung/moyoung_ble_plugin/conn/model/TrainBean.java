package com.moyoung.moyoung_ble_plugin.conn.model;

import com.crrepa.ble.conn.bean.CRPHistoryTrainingInfo;
import com.crrepa.ble.conn.bean.CRPTrainingInfo;

import java.util.List;

public class TrainBean {
    private List<CRPHistoryTrainingInfo> historyTrainList;
    private CRPTrainingInfo trainingInfo;

    public List<CRPHistoryTrainingInfo> getHistoryTrainList() {
        return historyTrainList;
    }

    public void setHistoryTrainList(List<CRPHistoryTrainingInfo> historyTrainList) {
        this.historyTrainList = historyTrainList;
    }

    public CRPTrainingInfo getTrainingInfo() {
        return trainingInfo;
    }

    public void setTrainingInfo(CRPTrainingInfo trainingInfo) {
        this.trainingInfo = trainingInfo;
    }
}
