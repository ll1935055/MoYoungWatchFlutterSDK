package com.moyoung.moyoung_ble_plugin.conn.model;

import com.crrepa.ble.conn.bean.CRPBloodOxygenInfo;
import com.crrepa.ble.conn.bean.CRPWatchFaceInfo;

import java.util.ArrayList;

public class WatchFaceIDBean {
    // 表示回调的状态是否成功，成功为0，否则为失败

    private int code;
    private CRPWatchFaceInfo.WatchFaceBean watchFace;
    private String error;

    public WatchFaceIDBean(int code) {
        this.code = code;
    }

    public WatchFaceIDBean() {
    }

    public CRPWatchFaceInfo.WatchFaceBean getWatchFace() {
        return watchFace;
    }

    public void setWatchFace(CRPWatchFaceInfo.WatchFaceBean watchFace) {
        this.watchFace = watchFace;
    }

    public String getError() {
        return error;
    }

    public void setError(String error) {
        this.error = error;
    }
}
