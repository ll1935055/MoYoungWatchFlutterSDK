package com.moyoung.moyoung_ble_plugin.conn.model;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;

import com.crrepa.ble.conn.bean.CRPWatchFaceLayoutInfo;

public class WatchFaceBgBean {
    private static final int DEFAULT_TIMEOUT = 30;
    private byte[] bitmap;
    private byte[] thumbBitmap;
    private CRPWatchFaceLayoutInfo.CompressionType type;
    private int timeout = 30;
    private int thumbWidth;
    private int thumbHeight;
    private int width;
    private int height;

    public static int getDefaultTimeout() {
        return DEFAULT_TIMEOUT;
    }

    public Bitmap getBitmap() {
        if (bitmap.length != 0) {
            return BitmapFactory.decodeByteArray(bitmap, 0, bitmap.length);
        } else {
            return null;
        }
    }

    public void setBitmap(byte[] bitmap) {
        this.bitmap = bitmap;
    }

    public Bitmap getThumbBitmap() {
        if (thumbBitmap.length != 0) {
            return BitmapFactory.decodeByteArray(thumbBitmap, 0, thumbBitmap.length);
        } else {
            return null;
        }
    }

    public void setThumbBitmap(byte[] thumbBitmap) {
        this.thumbBitmap = thumbBitmap;
    }

    public CRPWatchFaceLayoutInfo.CompressionType getType() {
        return type;
    }

    public void setType(CRPWatchFaceLayoutInfo.CompressionType type) {
        this.type = type;
    }

    public int getTimeout() {
        return timeout;
    }

    public void setTimeout(int timeout) {
        this.timeout = timeout;
    }

    public int getThumbWidth() {
        return thumbWidth;
    }

    public void setThumbWidth(int thumbWidth) {
        this.thumbWidth = thumbWidth;
    }

    public int getThumbHeight() {
        return thumbHeight;
    }

    public void setThumbHeight(int thumbHeight) {
        this.thumbHeight = thumbHeight;
    }

    public int getWidth() {
        return width;
    }

    public void setWidth(int width) {
        this.width = width;
    }

    public int getHeight() {
        return height;
    }

    public void setHeight(int height) {
        this.height = height;
    }
}
