package com.moyoung.moyoung_ble_plugin.conn.model;

import java.util.Date;

public class EGCBean {
    private int[] ints;
    private int measureComplete;
    private Date date;
    private boolean isCancel;
    private boolean isFail;

    public EGCBean(int[] ints, int measureComplete, Date date, boolean isCancel, boolean isFail) {
        this.ints = ints;
        this.measureComplete = measureComplete;
        this.date = date;
        this.isCancel = isCancel;
        this.isFail = isFail;
    }

    public EGCBean() {
    }

    public EGCBean(boolean flag) {
        if (flag) {
            this.measureComplete = -1;
            this.date = new Date();
            this.isCancel = false;
            this.isFail = false;
        } else {
            new EGCBean();
        }
    }

    public int[] getInts() {
        return ints;
    }

    public void setInts(int[] ints) {
        this.ints = ints;
    }

    public int getMeasureComplete() {
        return measureComplete;
    }

    public void setMeasureComplete(int measureComplete) {
        this.measureComplete = measureComplete;
    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    public boolean isCancel() {
        return isCancel;
    }

    public void setCancel(boolean cancel) {
        isCancel = cancel;
    }

    public boolean isFail() {
        return isFail;
    }

    public void setFail(boolean fail) {
        isFail = fail;
    }
}