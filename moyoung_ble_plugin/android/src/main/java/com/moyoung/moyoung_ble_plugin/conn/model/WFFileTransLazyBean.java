package com.moyoung.moyoung_ble_plugin.conn.model;

public class WFFileTransLazyBean {
    private int progress;
    private int error;

    public WFFileTransLazyBean(int progress, int error) {
        this.progress = progress;
        this.error = error;
    }

    public WFFileTransLazyBean(boolean flag) {
        this.progress = 0;
        this.error = -1;
    }

    public WFFileTransLazyBean() {
    }

    public int getProgress() {
        return progress;
    }

    public void setProgress(int progress) {
        this.progress = progress;
    }

    public int getError() {
        return error;
    }

    public void setError(int error) {
        this.error = error;
    }
}
