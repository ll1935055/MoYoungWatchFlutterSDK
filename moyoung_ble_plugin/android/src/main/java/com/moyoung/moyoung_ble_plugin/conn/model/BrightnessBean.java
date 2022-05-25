package com.moyoung.moyoung_ble_plugin.conn.model;

public class BrightnessBean {
    private int current;
    private int max;

    public BrightnessBean() {
    }

    public BrightnessBean(int current, int max) {
        this.current = current;
        this.max = max;
    }

    public int getCurrent() {
        return current;
    }

    public void setCurrent(int current) {
        this.current = current;
    }

    public int getMax() {
        return max;
    }

    public void setMax(int max) {
        this.max = max;
    }
}
