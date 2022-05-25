package com.moyoung.moyoung_ble_plugin.conn.model;

import com.crrepa.ble.conn.bean.CRPPeriodTimeInfo;

public class PeriodTimeBean {
    private  int periodTimeType;
    private CRPPeriodTimeInfo periodTimeInfo;

    public PeriodTimeBean() {
    }

    public PeriodTimeBean(int periodTimeType, CRPPeriodTimeInfo periodTimeInfo) {
        this.periodTimeType = periodTimeType;
        this.periodTimeInfo = periodTimeInfo;
    }

    public int getPeriodTimeType() {
        return periodTimeType;
    }

    public void setPeriodTimeType(int periodTimeType) {
        this.periodTimeType = periodTimeType;
    }

    public CRPPeriodTimeInfo getPeriodTimeInfo() {
        return periodTimeInfo;
    }

    public void setPeriodTimeInfo(CRPPeriodTimeInfo periodTimeInfo) {
        this.periodTimeInfo = periodTimeInfo;
    }
}
