package com.moyoung.moyoung_ble_plugin.conn.model;

import com.crrepa.ble.conn.bean.CRPHeartRateInfo;
import com.crrepa.ble.conn.bean.CRPHistoryHeartRateInfo;
import com.crrepa.ble.conn.bean.CRPMovementHeartRateInfo;
import com.crrepa.ble.conn.type.CRPHistoryDynamicRateType;

import java.util.ArrayList;
import java.util.List;

public class HeartRateBean {
    private int measuring;
    private int onceMeasureComplete;
    private List<CRPHistoryHeartRateInfo> historyHRList;
    private CRPHistoryDynamicRateType historyDynamicRateType;
    private CRPHeartRateInfo measureComplete;
    private CRPHeartRateInfo hour24MeasureResult;
    private List<CRPMovementHeartRateInfo> movementList;

    public HeartRateBean() {
    }
    public HeartRateBean(boolean flag) {
        if(flag){
            this.measuring = -1;
            this.onceMeasureComplete = -1;
            this.historyHRList=new ArrayList<>();
            this.historyDynamicRateType = CRPHistoryDynamicRateType.FIRST_HEART_RATE;
            this.measureComplete = new CRPHeartRateInfo(-1,new ArrayList<>(),-1, CRPHeartRateInfo.HeartRateType.TODAY_HEART_RATE);
            this.hour24MeasureResult = new CRPHeartRateInfo(-1,new ArrayList<>(),-1, CRPHeartRateInfo.HeartRateType.PART_HEART_RATE);
            this.movementList = new ArrayList<>();
        }else {
            new HeartRateBean();
        }
    }

    public HeartRateBean(int measuring, int onceMeasureComplete, List<CRPHistoryHeartRateInfo> historyHRList, CRPHistoryDynamicRateType historyDynamicRateType, CRPHeartRateInfo measureComplete, CRPHeartRateInfo hour24MeasureResult, List<CRPMovementHeartRateInfo> movementList) {
        this.measuring = measuring;
        this.onceMeasureComplete = onceMeasureComplete;
        this.historyHRList = historyHRList;
        this.historyDynamicRateType = historyDynamicRateType;
        this.measureComplete = measureComplete;
        this.hour24MeasureResult = hour24MeasureResult;
        this.movementList = movementList;
    }



    public int getMeasuring() {
        return measuring;
    }

    public void setMeasuring(int measuring) {
        this.measuring = measuring;
    }

    public int getOnceMeasureComplete() {
        return onceMeasureComplete;
    }

    public void setOnceMeasureComplete(int onceMeasureComplete) {
        this.onceMeasureComplete = onceMeasureComplete;
    }

    public List<CRPHistoryHeartRateInfo> getHistoryHRList() {
        return historyHRList;
    }

    public void setHistoryHRList(List<CRPHistoryHeartRateInfo> historyHRList) {
        this.historyHRList = historyHRList;
    }

    public CRPHistoryDynamicRateType getHistoryDynamicRateType() {
        return historyDynamicRateType;
    }

    public void setHistoryDynamicRateType(CRPHistoryDynamicRateType historyDynamicRateType) {
        this.historyDynamicRateType = historyDynamicRateType;
    }

    public CRPHeartRateInfo getMeasureComplete() {
        return measureComplete;
    }

    public void setMeasureComplete(CRPHeartRateInfo measureComplete) {
        this.measureComplete = measureComplete;
    }

    public CRPHeartRateInfo getHour24MeasureResult() {
        return hour24MeasureResult;
    }

    public void setHour24MeasureResult(CRPHeartRateInfo hour24MeasureResult) {
        this.hour24MeasureResult = hour24MeasureResult;
    }

    public List<CRPMovementHeartRateInfo> getMovementList() {
        return movementList;
    }

    public void setMovementList(List<CRPMovementHeartRateInfo> movementList) {
        this.movementList = movementList;
    }
}
