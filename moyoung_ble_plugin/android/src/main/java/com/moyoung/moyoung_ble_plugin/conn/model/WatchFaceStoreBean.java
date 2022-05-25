package com.moyoung.moyoung_ble_plugin.conn.model;

import java.util.List;

public class WatchFaceStoreBean {
    private List<Integer> watchFaceSupportList;
    private String firmwareVersion;
    private int pageCount;
    private int pageIndex;

    public List<Integer> getWatchFaceSupportList() {
        return watchFaceSupportList;
    }

    public void setWatchFaceSupportList(List<Integer> watchFaceSupportList) {
        this.watchFaceSupportList = watchFaceSupportList;
    }

    public String getFirmwareVersion() {
        return firmwareVersion;
    }

    public void setFirmwareVersion(String firmwareVersion) {
        this.firmwareVersion = firmwareVersion;
    }

    public int getPageCount() {
        return pageCount;
    }

    public void setPageCount(int pageCount) {
        this.pageCount = pageCount;
    }

    public int getPageIndex() {
        return pageIndex;
    }

    public void setPageIndex(int pageIndex) {
        this.pageIndex = pageIndex;
    }
}
