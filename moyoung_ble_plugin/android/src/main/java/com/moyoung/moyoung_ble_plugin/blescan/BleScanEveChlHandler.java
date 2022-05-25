package com.moyoung.moyoung_ble_plugin.blescan;

import android.text.TextUtils;

import com.crrepa.ble.scan.bean.CRPScanDevice;
import com.crrepa.ble.scan.callback.CRPScanCallback;
import com.moyoung.moyoung_ble_plugin.base.BaseEveChlHandler;
import com.moyoung.moyoung_ble_plugin.common.GsonUtils;
import com.moyoung.moyoung_ble_plugin.blescan.model.BleScanBean;

import java.util.List;

public class BleScanEveChlHandler extends BaseEveChlHandler {
    private static final int SCAN_PERIOD = 10 * 1000;

    public void startScan() {
        startScan(SCAN_PERIOD);
    }

    public void startScan(int scanPeriod) {
        bleClient.scanDevice(new CRPScanCallback() {
            @Override
            public void onScanning(CRPScanDevice device) {
                if (TextUtils.isEmpty(device.getDevice().getName())) {
                    return;
                }
                BleScanBean bleScanBean = BleScanBean.covert(false, device);
                String jsonStr = GsonUtils.get().toJson(bleScanBean, BleScanBean.class);
                eventSink.success(jsonStr);
            }

            @Override
            public void onScanComplete(List<CRPScanDevice> list) {
                BleScanBean bleScanBean = BleScanBean.covert(true, null);
                String jsonStr = GsonUtils.get().toJson(bleScanBean, BleScanBean.class);
                eventSink.success(jsonStr);
            }
        }, scanPeriod);

    }
}
