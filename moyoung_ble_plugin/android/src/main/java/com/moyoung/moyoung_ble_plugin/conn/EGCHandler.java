package com.moyoung.moyoung_ble_plugin.conn;

import com.crrepa.ble.conn.CRPBleConnection;
import com.crrepa.ble.conn.listener.CRPBleECGChangeListener;
import com.crrepa.ble.conn.type.CRPEcgMeasureType;
import com.moyoung.moyoung_ble_plugin.base.BaseConnEveChlHandler;
import com.moyoung.moyoung_ble_plugin.common.GsonUtils;
import com.moyoung.moyoung_ble_plugin.conn.model.EGCBean;

import java.util.Date;

import io.flutter.plugin.common.MethodCall;

class EGCHandler extends BaseConnEveChlHandler {
    @Override
    public void setConnListener(CRPBleConnection connection, MethodCall call) {
        String ecgMeasureType = call.argument("ecgMeasureType");
        ecgMeasureType = ecgMeasureType == null ? CRPEcgMeasureType.TI.toString() : ecgMeasureType;
        
        connection.setECGChangeListener(new CRPBleECGChangeListener() {
            @Override
            public void onECGChange(int[] ECGChangeInts) {
                EGCBean EGCBean = new EGCBean(true);
                EGCBean.setInts(ECGChangeInts);
                String egcStr = GsonUtils.get().toJson(EGCBean, EGCBean.class);
                activity.runOnUiThread(() -> eventSink.success(egcStr));
            }

            @Override
            public void onMeasureComplete() {
                EGCBean EGCBean = new EGCBean(true);
                EGCBean.setMeasureComplete(100);
                String egcStr = GsonUtils.get().toJson(EGCBean, EGCBean.class);
                activity.runOnUiThread(() -> eventSink.success(egcStr));
            }

            @Override
            public void onTransCpmplete(Date date) {
                EGCBean EGCBean = new EGCBean(true);
                EGCBean.setDate(date);
                String egcStr = GsonUtils.get().toJson(EGCBean, EGCBean.class);
                activity.runOnUiThread(() -> eventSink.success(egcStr));
            }

            @Override
            public void onCancel() {
                EGCBean EGCBean = new EGCBean(true);
                EGCBean.setCancel(true);
                String egcStr = GsonUtils.get().toJson(EGCBean, EGCBean.class);
                activity.runOnUiThread(() -> eventSink.success(egcStr));
            }

            @Override
            public void onFail() {
                EGCBean EGCBean = new EGCBean(true);
                EGCBean.setFail(true);
                String egcStr = GsonUtils.get().toJson(EGCBean, EGCBean.class);
                activity.runOnUiThread(() -> eventSink.success(egcStr));
            }
        }, CRPEcgMeasureType.valueOf(ecgMeasureType));
    }
}

