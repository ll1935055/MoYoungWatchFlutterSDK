package com.moyoung.moyoung_ble_plugin.blescan.model;

import com.crrepa.ble.scan.bean.CRPScanDevice;

public class BleScanBean {
    boolean isCompleted;
    String address;
    String name;
    byte[] mScanRecord;
    int mRssi;

    public BleScanBean(boolean isCompleted, String address, String name, byte[] mScanRecord, int mRssi) {
        this.isCompleted = isCompleted;
        this.address = address;
        this.name = name;
        this.mScanRecord = mScanRecord;
        this.mRssi = mRssi;
    }

    public static BleScanBean covert(boolean isCompleted, CRPScanDevice device) {
        if (isCompleted) {
            return new BleScanBean(
                    true,
                    "",
                    "",
                    new byte[0],
                    -1);
        } else {
            return new BleScanBean(
                    false,
                    device.getDevice().getAddress(),
                    device.getDevice().getName(),
                    device.getScanRecord(),
                    device.getRssi());
        }
    }
}
