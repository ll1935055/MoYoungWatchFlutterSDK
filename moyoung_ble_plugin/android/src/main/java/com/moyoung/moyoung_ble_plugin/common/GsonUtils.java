package com.moyoung.moyoung_ble_plugin.common;

import com.google.gson.Gson;

public class GsonUtils {
    private static Gson gson;

    public static Gson get() {
        if (gson == null) {
             gson = new Gson();
        }
        return gson;
    }
}
