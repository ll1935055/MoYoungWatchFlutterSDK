package com.moyoung.moyoung_ble_plugin.conn.model;

import com.crrepa.ble.conn.bean.CRPSleepInfo;


public class SleepBean {
    CRPSleepInfo sleepInfo;
    int past;
    CRPSleepInfo pastSleepInfo;

    public SleepBean(CRPSleepInfo sleepInfo, int past, CRPSleepInfo pastSleepInfo) {
        this.sleepInfo = sleepInfo;
        this.past = past;
        this.pastSleepInfo = pastSleepInfo;
    }

    public SleepBean() {
    }
    public SleepBean(boolean flag) {
        if (flag) {
            this.sleepInfo = new CRPSleepInfo();
            this.past = -1;
            this.pastSleepInfo = new CRPSleepInfo();
        } else {
            new SleepBean();
        }
    }
    public CRPSleepInfo getSleepInfo() {
        return sleepInfo;
    }

    public void setSleepInfo(CRPSleepInfo sleepInfo) {
        this.sleepInfo = sleepInfo;
    }

    public int getPast() {
        return past;
    }

    public void setPast(int past) {
        this.past = past;
    }

    public CRPSleepInfo getPastSleepInfo() {
        return pastSleepInfo;
    }

    public void setPastSleepInfo(CRPSleepInfo pastSleepInfo) {
        this.pastSleepInfo = pastSleepInfo;
    }
}