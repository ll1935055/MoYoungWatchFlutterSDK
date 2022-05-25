package com.moyoung.moyoung_ble_plugin.conn.model;

import com.crrepa.ble.conn.bean.CRPStepInfo;

public class StepChangeBean {
    CRPStepInfo stepInfo;
    int past;
    CRPStepInfo pastStepInfo;

    public StepChangeBean(CRPStepInfo stepInfo, int past, CRPStepInfo pastStepInfo) {
        this.stepInfo = stepInfo;
        this.past = past;
        this.pastStepInfo = pastStepInfo;
    }

    public StepChangeBean() {
    }

    public StepChangeBean(boolean flag) {
        if(flag){
            this.stepInfo = new CRPStepInfo(-1,-1,-1,-1);
            this.past = -1;
            this.pastStepInfo = new CRPStepInfo(-1,-1,-1,-1);
        }else{
            new StepChangeBean();
        }
    }

    public CRPStepInfo getStepInfo() {
        return stepInfo;
    }

    public void setStepInfo(CRPStepInfo stepInfo) {
        this.stepInfo = stepInfo;
    }

    public int getPast() {
        return past;
    }

    public void setPast(int past) {
        this.past = past;
    }

    public CRPStepInfo getPastStepInfo() {
        return pastStepInfo;
    }

    public void setPastStepInfo(CRPStepInfo pastStepInfo) {
        this.pastStepInfo = pastStepInfo;
    }
}
