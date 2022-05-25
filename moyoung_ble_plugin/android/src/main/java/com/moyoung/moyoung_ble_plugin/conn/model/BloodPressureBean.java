package com.moyoung.moyoung_ble_plugin.conn.model;

import com.crrepa.ble.conn.bean.CRPBloodPressureInfo;
import com.crrepa.ble.conn.bean.CRPHistoryBloodPressureInfo;

import java.util.ArrayList;
import java.util.List;

public class BloodPressureBean {
    private boolean continueState;
    private int bloodPressureChange;
    private int bloodPressureChange1;
    private List<CRPHistoryBloodPressureInfo> historyBPList;
    private CRPBloodPressureInfo continueBP;

    public BloodPressureBean(boolean continueState, int bloodPressureChange,
                             int bloodPressureChange1, List<CRPHistoryBloodPressureInfo> historyBPList,
                             CRPBloodPressureInfo continueBP) {
        this.continueState = continueState;
        this.bloodPressureChange = bloodPressureChange;
        this.bloodPressureChange1 = bloodPressureChange1;
        this.historyBPList = historyBPList;
        this.continueBP = continueBP;
    }

    public BloodPressureBean() {
    }

    public BloodPressureBean(boolean flag) {
        if (flag) {
            this.continueState = true;
            this.bloodPressureChange = -1;
            this.bloodPressureChange1 = -1;
            this.historyBPList = new ArrayList<>();
            this.continueBP = new CRPBloodPressureInfo();
        } else {
            new BloodPressureBean();
        }
    }

    public boolean isContinueState() {
        return continueState;
    }

    public void setContinueState(boolean continueState) {
        this.continueState = continueState;
    }

    public int getBloodPressureChange() {
        return bloodPressureChange;
    }

    public void setBloodPressureChange(int bloodPressureChange) {
        this.bloodPressureChange = bloodPressureChange;
    }

    public int getBloodPressureChange1() {
        return bloodPressureChange1;
    }

    public void setBloodPressureChange1(int bloodPressureChange1) {
        this.bloodPressureChange1 = bloodPressureChange1;
    }

    public List<CRPHistoryBloodPressureInfo> getHistoryBPList() {
        return historyBPList;
    }

    public void setHistoryBPList(List<CRPHistoryBloodPressureInfo> historyBPList) {
        this.historyBPList = historyBPList;
    }

    public CRPBloodPressureInfo getContinueBP() {
        return continueBP;
    }

    public void setContinueBP(CRPBloodPressureInfo continueBP) {
        this.continueBP = continueBP;
    }
}
