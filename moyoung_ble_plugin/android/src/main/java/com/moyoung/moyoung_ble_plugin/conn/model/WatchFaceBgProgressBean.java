package com.moyoung.moyoung_ble_plugin.conn.model;

public class WatchFaceBgProgressBean {
    private Boolean isError;
    private int progress;

    public Boolean getError() {
        return isError;
    }

    public void setError(Boolean error) {
        isError = error;
    }

    public int getProgress() {
        return progress;
    }

    public void setProgress(int progress) {
        this.progress = progress;
    }
}
