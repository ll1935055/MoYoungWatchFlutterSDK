package com.moyoung.moyoung_ble_plugin.conn.model;

public class DeviceLanguageBean {
    private int type;
    private int[] languageType;

    public DeviceLanguageBean() {
    }

    public DeviceLanguageBean(int type, int[] languageType) {
        this.type = type;
        this.languageType = languageType;
    }

    public int getType() {
        return type;
    }

    public void setType(int type) {
        this.type = type;
    }

    public int[] getLanguageType() {
        return languageType;
    }

    public void setLanguageType(int[] languageType) {
        this.languageType = languageType;
    }
}
