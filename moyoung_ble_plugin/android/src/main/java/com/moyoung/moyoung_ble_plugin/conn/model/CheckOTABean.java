package com.moyoung.moyoung_ble_plugin.conn.model;

import com.crrepa.ble.conn.bean.CRPFirmwareVersionInfo;


public class CheckOTABean {
    CRPFirmwareVersionInfo firmwareVersionInfo;
    String isLatestVersion;
    public CheckOTABean() {
    }

    public CheckOTABean(CRPFirmwareVersionInfo firmwareVersionInfo, String isLatestVersion) {
        this.firmwareVersionInfo = firmwareVersionInfo;
        this.isLatestVersion = isLatestVersion;
    }
    public CheckOTABean(boolean flag) {
        if (flag){
            this.firmwareVersionInfo = new CRPFirmwareVersionInfo("","","",-1,-1,false);
            this.isLatestVersion = "";
        }else {
            new CheckOTABean();
        }
    }

    public CRPFirmwareVersionInfo getFirmwareVersionInfo() {
        return firmwareVersionInfo;
    }

    public void setFirmwareVersionInfo(CRPFirmwareVersionInfo firmwareVersionInfo) {
        this.firmwareVersionInfo = firmwareVersionInfo;
    }

    public String getIsLatestVersion() {
        return isLatestVersion;
    }

    public void setIsLatestVersion(String isLatestVersion) {
        this.isLatestVersion = isLatestVersion;
    }
}