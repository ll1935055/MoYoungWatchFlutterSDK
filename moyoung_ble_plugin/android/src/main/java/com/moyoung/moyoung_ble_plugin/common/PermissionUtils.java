package com.moyoung.moyoung_ble_plugin.common;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.Context;
import android.content.pm.PackageManager;
import android.os.Build;

import com.moyoung.moyoung_ble_plugin.ErrorConstant;

import java.util.HashMap;
import java.util.Map;

import androidx.collection.SimpleArrayMap;
import androidx.core.app.ActivityCompat;
import androidx.core.content.PermissionChecker;
import androidx.fragment.app.Fragment;

public class PermissionUtils {
    private static final SimpleArrayMap<String, Integer> MIN_SDK_PERMISSIONS;

    private static final int REQUEST_UPDATE_BAND_CONFIG = 4;
    public static final String[] PERMISSION_UPDATE_BAND_CONFIG = new String[] {
            "android.permission.WRITE_EXTERNAL_STORAGE",
            "android.permission.READ_EXTERNAL_STORAGE",
            "android.permission.ACCESS_FINE_LOCATION",
            "android.permission.ACCESS_COARSE_LOCATION"};

    public static final String[] NO_PERMISSION_MSG = new String[] {
            "The permission is not applied for: WRITE_EXTERNAL_STORAGE",
            "The permission is not applied for: READ_EXTERNAL_STORAGE",
            "The permission is not applied for: ACCESS_FINE_LOCATION",
            "The permission is not applied for: ACCESS_COARSE_LOCATION"};

    public static final String[] NO_PERMISSION_ERROR_CODE = new String[] {
            ErrorConstant.NO_PERMISSION_WRITE_EXTERNAL_STORAGE,
            ErrorConstant.NO_Permission_READ_EXTERNAL_STORAGE,
            ErrorConstant.NO_PERMISSION_FINE_LOCATION,
            ErrorConstant.NO_PERMISSION_COARSE_LOCATION};

    static {
        MIN_SDK_PERMISSIONS = new SimpleArrayMap<>(8);
        MIN_SDK_PERMISSIONS.put("com.android.voicemail.permission.ADD_VOICEMAIL", 14);
        MIN_SDK_PERMISSIONS.put("android.permission.BODY_SENSORS", 20);
        MIN_SDK_PERMISSIONS.put("android.permission.READ_CALL_LOG", 16);
        MIN_SDK_PERMISSIONS.put("android.permission.READ_EXTERNAL_STORAGE", 16);
        MIN_SDK_PERMISSIONS.put("android.permission.USE_SIP", 9);
        MIN_SDK_PERMISSIONS.put("android.permission.WRITE_CALL_LOG", 16);
        MIN_SDK_PERMISSIONS.put("android.permission.SYSTEM_ALERT_WINDOW", 23);
        MIN_SDK_PERMISSIONS.put("android.permission.WRITE_SETTINGS", 23);
    }

    private PermissionUtils() {
    }

    public static void requestPermissions(Activity activity) {
        if (!PermissionUtils.hasSelfPermissions(activity.getApplicationContext(), PERMISSION_UPDATE_BAND_CONFIG)) {
            ActivityCompat.requestPermissions(
                    activity, PERMISSION_UPDATE_BAND_CONFIG, REQUEST_UPDATE_BAND_CONFIG);
        }
    }

    public static Map<String, String> getNoPermissionsMsg(Context context, String... permissions) {
        for (int i = 0; i < permissions.length; i++) {
            String permission = permissions[i];
            if (permissionExists(permission) && !hasSelfPermission(context, permission)) {
                Map<String, String> noPermissionMsgMap = new HashMap<>();
                String errorCode = NO_PERMISSION_ERROR_CODE[i];
                String errorMessage = NO_PERMISSION_MSG[i];
                noPermissionMsgMap.put("errorCode", errorCode);
                noPermissionMsgMap.put("errorMessage", errorMessage);
                return noPermissionMsgMap;
            }
        }
        return null;
    }

    /**
     * Checks all given permissions have been granted.
     *
     * @param grantResults results
     * @return returns true if all permissions have been granted.
     */
    public static boolean verifyPermissions(int... grantResults) {
        if (grantResults.length == 0) {
            return false;
        }
        for (int result : grantResults) {
            if (result != PackageManager.PERMISSION_GRANTED) {
                return false;
            }
        }
        return true;
    }

    /**
     * Returns true if the permission exists in this SDK version
     *
     * @param permission permission
     * @return returns true if the permission exists in this SDK version
     */
    private static boolean permissionExists(String permission) {
        // Check if the permission could potentially be missing on this device
        Integer minVersion = MIN_SDK_PERMISSIONS.get(permission);
        // If null was returned from the above call, there is no need for a device API level check for the permission;
        // otherwise, we check if its minimum API level requirement is met
        return minVersion == null || Build.VERSION.SDK_INT >= minVersion;
    }

    /**
     * Returns true if the Activity or Fragment has access to all given permissions.
     *
     * @param context     context
     * @param permissions permission list
     * @return returns true if the Activity or Fragment has access to all given permissions.
     */
    public static boolean hasSelfPermissions(Context context, String... permissions) {
        for (String permission : permissions) {
            if (permissionExists(permission) && !hasSelfPermission(context, permission)) {
                return false;
            }
        }
        return true;
    }

    /**
     * Determine context has access to the given permission.
     * <p>
     * This is a workaround for RuntimeException of Parcel#readException.
     * For more detail, check this issue https://github.com/hotchemi/PermissionsDispatcher/issues/107
     *
     * @param context    context
     * @param permission permission
     * @return true if context has access to the given permission, false otherwise.
     * @see #hasSelfPermissions(Context, String...)
     */
    @SuppressLint("WrongConstant")
    private static boolean hasSelfPermission(Context context, String permission) {
        try {
            return PermissionChecker.checkSelfPermission(context, permission) == PackageManager.PERMISSION_GRANTED;
        } catch (RuntimeException t) {
            return false;
        }
    }

    /**
     * Checks given permissions are needed to show rationale.
     *
     * @param activity    activity
     * @param permissions permission list
     * @return returns true if one of the permission is needed to show rationale.
     */
    public static boolean shouldShowRequestPermissionRationale(Activity activity, String... permissions) {
        for (String permission : permissions) {
            if (ActivityCompat.shouldShowRequestPermissionRationale(activity, permission)) {
                return true;
            }
        }
        return false;
    }

    /**
     * Checks given permissions are needed to show rationale.
     *
     * @param fragment    fragment
     * @param permissions permission list
     * @return returns true if one of the permission is needed to show rationale.
     */
    public static boolean shouldShowRequestPermissionRationale(Fragment fragment, String... permissions) {
        for (String permission : permissions) {
            if (fragment.shouldShowRequestPermissionRationale(permission)) {
                return true;
            }
        }
        return false;
    }


}
