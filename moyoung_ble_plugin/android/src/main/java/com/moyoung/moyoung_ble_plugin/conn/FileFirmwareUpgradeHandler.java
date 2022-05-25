package com.moyoung.moyoung_ble_plugin.conn;


import com.crrepa.ble.conn.CRPBleConnection;
import com.crrepa.ble.ota.hs.HsDfuController;
import com.crrepa.ble.ota.realtek.RtkDfuController;
import com.moyoung.moyoung_ble_plugin.base.BaseConnEveChlHandler;

import io.flutter.plugin.common.MethodCall;

class FileFirmwareUpgradeHandler extends BaseConnEveChlHandler {
    @Override
    public void setConnListener(CRPBleConnection connection, MethodCall call) {
        boolean firmwareUpgradeFlag = call.argument("firmwareUpgradeFlag");
        connection.startFirmwareUpgrade(firmwareUpgradeFlag, new firmwareUpgradeListener(eventSink,activity));
    }

    public void setHsLazyConnListener(MethodCall call) {
        String address = call.argument("address");
        if (address == null) {
            return;
        }

        HsDfuController hsDfuController = HsDfuController.getInstance();
        hsDfuController.setUpgradeListener(new firmwareUpgradeListener(eventSink,activity));
        hsDfuController.setAddress(address);
        hsDfuController.start(true);
    }

    public void setRtkUpgradeListener(MethodCall call) {
        String address = call.argument("address");
        if (address == null) {
            return;
        }
        RtkDfuController rtkDfuController = RtkDfuController.getInstance();
        rtkDfuController.setUpgradeListener(new firmwareUpgradeListener(eventSink,activity));
        rtkDfuController.start(address);
    }
}

