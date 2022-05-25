package com.moyoung.moyoung_ble_plugin.conn.model;

public class MaxHeartRateBean {
    private int heartRate;
    private boolean enable;

    public MaxHeartRateBean(int heartRate, boolean enable) {
        this.heartRate = heartRate;
        this.enable = enable;
    }

    public MaxHeartRateBean() {
    }

    public int getHeartRate() {
        return heartRate;
    }

    public void setHeartRate(int heartRate) {
        this.heartRate = heartRate;
    }

    public boolean isEnable() {
        return enable;
    }

    public void setEnable(boolean enable) {
        this.enable = enable;
    }
}
