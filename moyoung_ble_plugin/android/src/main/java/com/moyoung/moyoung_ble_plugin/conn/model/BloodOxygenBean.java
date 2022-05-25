package com.moyoung.moyoung_ble_plugin.conn.model;

import com.crrepa.ble.conn.bean.CRPBloodOxygenInfo;
import com.crrepa.ble.conn.bean.CRPHistoryBloodOxygenInfo;

import java.util.ArrayList;
import java.util.List;

public class BloodOxygenBean {
    private boolean continueState;
    private int timingMeasure;
    private int bloodOxygen;
    private List<CRPHistoryBloodOxygenInfo> historyList;
    private CRPBloodOxygenInfo continueBO;

    public BloodOxygenBean(boolean continueState, int timingMeasure, int bloodOxygen,
                           List<CRPHistoryBloodOxygenInfo> historyList,
                           CRPBloodOxygenInfo continueBO) {
        this.continueState = continueState;
        this.timingMeasure = timingMeasure;
        this.bloodOxygen = bloodOxygen;
        this.historyList = historyList;
        this.continueBO = continueBO;
    }


    public BloodOxygenBean() {
    }

    public BloodOxygenBean(boolean flag) {
        if (flag) {
            this.continueState = true;
            this.timingMeasure = -1;
            this.bloodOxygen = -1;
            this.historyList = new ArrayList<>();
            this.continueBO = new CRPBloodOxygenInfo();
        } else {
            new BloodOxygenBean();
        }
    }

    public boolean isContinueState() {
        return continueState;
    }

    public void setContinueState(boolean continueState) {
        this.continueState = continueState;
    }

    public int getTimingMeasure() {
        return timingMeasure;
    }

    public void setTimingMeasure(int timingMeasure) {
        this.timingMeasure = timingMeasure;
    }

    public int getBloodOxygen() {
        return bloodOxygen;
    }

    public void setBloodOxygen(int bloodOxygen) {
        this.bloodOxygen = bloodOxygen;
    }

    public List<CRPHistoryBloodOxygenInfo> getHistoryList() {
        return historyList;
    }

    public void setHistoryList(List<CRPHistoryBloodOxygenInfo> historyList) {
        this.historyList = historyList;
    }

    public CRPBloodOxygenInfo getContinueBO() {
        return continueBO;
    }

    public void setContinueBO(CRPBloodOxygenInfo continueBO) {
        this.continueBO = continueBO;
    }
}