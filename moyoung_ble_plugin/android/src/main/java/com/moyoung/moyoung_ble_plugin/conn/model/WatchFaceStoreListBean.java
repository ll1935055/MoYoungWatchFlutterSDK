package com.moyoung.moyoung_ble_plugin.conn.model;

import com.crrepa.ble.conn.bean.CRPBloodOxygenInfo;
import com.crrepa.ble.conn.bean.CRPWatchFaceInfo;

import java.util.ArrayList;

public class WatchFaceStoreListBean {
    private CRPWatchFaceInfo watchFaceStore;
    private String error;

    public WatchFaceStoreListBean() {
    }

    public WatchFaceStoreListBean(CRPWatchFaceInfo watchFaceStore, String error) {
        this.watchFaceStore = watchFaceStore;
        this.error = error;
    }

    public CRPWatchFaceInfo getWatchFaceStore() {
        return watchFaceStore;
    }

    public void setWatchFaceStore(CRPWatchFaceInfo watchFaceStore) {
        this.watchFaceStore = watchFaceStore;
    }

    public String getError() {
        return error;
    }

    public void setError(String error) {
        this.error = error;
    }
}
