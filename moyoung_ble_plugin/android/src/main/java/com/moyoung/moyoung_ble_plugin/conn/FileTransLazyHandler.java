package com.moyoung.moyoung_ble_plugin.conn;

import android.graphics.Bitmap;
import android.media.MediaDrm;
import android.util.Log;

import com.crrepa.ble.conn.CRPBleConnection;
import com.crrepa.ble.conn.bean.CRPWatchFaceBackgroundInfo;
import com.crrepa.ble.conn.listener.CRPFileTransListener;
import com.moyoung.moyoung_ble_plugin.ErrorConstant;
import com.moyoung.moyoung_ble_plugin.base.BaseConnEveChlHandler;
import com.moyoung.moyoung_ble_plugin.common.BitmapUtils;
import com.moyoung.moyoung_ble_plugin.common.GsonUtils;
import com.moyoung.moyoung_ble_plugin.conn.model.BloodOxygenBean;
import com.moyoung.moyoung_ble_plugin.conn.model.WatchFaceBgBean;
import com.moyoung.moyoung_ble_plugin.conn.model.WatchFaceBgProgressBean;

import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.MethodCall;

class FileTransLazyHandler extends BaseConnEveChlHandler {
    private final static String TAG = FileTransLazyHandler.class.getSimpleName();

    @Override
    public void setConnListener(CRPBleConnection connection, MethodCall call) {
        Map<String, Object> mapStr = new HashMap<>();
        String jsonStr = call.argument("watchFaceBackgroundInfo");
        WatchFaceBgBean watchFaceBgBean=GsonUtils.get().fromJson(jsonStr, WatchFaceBgBean.class);

        boolean bitmapFlag=watchFaceBgBean.getBitmap().getWidth()==watchFaceBgBean.getWidth()&&
                watchFaceBgBean.getBitmap().getHeight()==watchFaceBgBean.getHeight();
        boolean thumbBitmapFlag=watchFaceBgBean.getThumbBitmap().getWidth()==watchFaceBgBean.getThumbWidth()&&
                watchFaceBgBean.getThumbBitmap().getHeight()==watchFaceBgBean.getThumbHeight();

        if(bitmapFlag&&thumbBitmapFlag){
            CRPWatchFaceBackgroundInfo backgroundInfo = new CRPWatchFaceBackgroundInfo(watchFaceBgBean.getBitmap(),watchFaceBgBean.getThumbBitmap(),watchFaceBgBean.getType());

            sendWatchFaceBackground(connection,backgroundInfo);
        }else{
            eventSink.error(ErrorConstant.IMAGE_ADAPTATION_ERROR,"Image width and width do not match","The picture does not fit");
        }


    }

    private void sendWatchFaceBackground(CRPBleConnection connection,CRPWatchFaceBackgroundInfo backgroundInfo){
        connection.sendWatchFaceBackground(backgroundInfo, new CRPFileTransListener() {

            @Override
            public void onTransProgressStarting() {
                WatchFaceBgProgressBean bgProgressBean = new WatchFaceBgProgressBean();
                bgProgressBean.setError(false);
                bgProgressBean.setProgress(1);
                String bgProgress = GsonUtils.get().toJson(bgProgressBean, WatchFaceBgProgressBean.class);
                activity.runOnUiThread(() -> eventSink.success(bgProgress));
            }

            @Override
            public void onTransProgressChanged(int progress) {
                WatchFaceBgProgressBean bgProgressBean = new WatchFaceBgProgressBean();
                bgProgressBean.setError(false);
                bgProgressBean.setProgress(progress);
                String bgProgress = GsonUtils.get().toJson(bgProgressBean, WatchFaceBgProgressBean.class);
                activity.runOnUiThread(() -> eventSink.success(bgProgress));
            }

            @Override
            public void onTransCompleted() {
                WatchFaceBgProgressBean bgProgressBean = new WatchFaceBgProgressBean();
                bgProgressBean.setError(false);
                bgProgressBean.setProgress(100);
                String bgProgress = GsonUtils.get().toJson(bgProgressBean, WatchFaceBgProgressBean.class);
                activity.runOnUiThread(() -> eventSink.success(bgProgress));
            }

            @Override
            public void onError(int i) {
                WatchFaceBgProgressBean bgProgressBean = new WatchFaceBgProgressBean();
                bgProgressBean.setError(true);
                bgProgressBean.setProgress(-1);
                String bgProgress = GsonUtils.get().toJson(bgProgressBean, WatchFaceBgProgressBean.class);
                activity.runOnUiThread(() -> eventSink.success(bgProgress));
            }
        });
    }
}

