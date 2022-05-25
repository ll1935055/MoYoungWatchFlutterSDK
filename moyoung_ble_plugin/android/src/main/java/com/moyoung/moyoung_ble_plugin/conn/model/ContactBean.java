package com.moyoung.moyoung_ble_plugin.conn.model;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;

public class ContactBean {
    private int id;
    private int width;
    private int height;
    private int address;
    private String name;
    private String number;
    private byte[] avatar;
    private int timeout;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
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

    public int getAddress() {
        return address;
    }

    public void setAddress(int address) {
        this.address = address;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getNumber() {
        return number;
    }

    public void setNumber(String number) {
        this.number = number;
    }

    public Bitmap getAvatar() {
        if(this.avatar.length != 0) {
            return BitmapFactory.decodeByteArray(this.avatar, 0, avatar.length);
        } else {
            return null;
        }
    }

    public void setAvatar(byte[] avatar) {
        this.avatar = avatar;
    }

    public int getTimeout() {
        return timeout;
    }

    public void setTimeout(int timeout) {
        this.timeout = timeout;
    }
}
