package com.moyoung.moyoung_ble_plugin.conn.model;

import com.crrepa.ble.conn.bean.CRPPhysiologcalPeriodInfo;

import java.util.Date;

public class MenstrualCycleBean {
    private int physiologcalPeriod;
    private int menstrualPeriod;
    private long startDate;
    private boolean menstrualReminder;
    private boolean ovulationReminder;
    private boolean ovulationDayReminder;
    private boolean ovulationEndReminder;
    private int reminderHour;
    private int reminderMinute;

    public MenstrualCycleBean(int var1, int var2, int var3, boolean var4, boolean var5, boolean var6, boolean var7, int var8, int var9) {
        this.physiologcalPeriod = var1;
        this.menstrualPeriod = var2;
        this.startDate = var3;
        this.menstrualReminder = var4;
        this.ovulationReminder = var5;
        this.ovulationDayReminder = var6;
        this.ovulationEndReminder = var7;
        this.reminderHour = var8;
        this.reminderMinute = var9;
    }

    public static CRPPhysiologcalPeriodInfo convert(MenstrualCycleBean menstrualCycleBean) {
        return new CRPPhysiologcalPeriodInfo(
                menstrualCycleBean.physiologcalPeriod,
                menstrualCycleBean.menstrualPeriod,
                new Date(menstrualCycleBean.startDate),
                menstrualCycleBean.menstrualReminder,
                menstrualCycleBean.ovulationReminder,
                menstrualCycleBean.ovulationDayReminder,
                menstrualCycleBean.ovulationEndReminder,
                menstrualCycleBean.reminderHour,
                menstrualCycleBean.reminderMinute);
    }


    public int getPhysiologcalPeriod() {
        return this.physiologcalPeriod;
    }

    public void setPhysiologcalPeriod(int var1) {
        this.physiologcalPeriod = var1;
    }

    public int getMenstrualPeriod() {
        return this.menstrualPeriod;
    }

    public void setMenstrualPeriod(int var1) {
        this.menstrualPeriod = var1;
    }

    public long getStartDate() {
        return this.startDate;
    }

    public void setStartDate(int var1) {
        this.startDate = var1;
    }

    public boolean isMenstrualReminder() {
        return this.menstrualReminder;
    }

    public void setMenstrualReminder(boolean var1) {
        this.menstrualReminder = var1;
    }

    public boolean isOvulationReminder() {
        return this.ovulationReminder;
    }

    public void setOvulationReminder(boolean var1) {
        this.ovulationReminder = var1;
    }

    public boolean isOvulationDayReminder() {
        return this.ovulationDayReminder;
    }

    public void setOvulationDayReminder(boolean var1) {
        this.ovulationDayReminder = var1;
    }

    public boolean isOvulationEndReminder() {
        return this.ovulationEndReminder;
    }

    public void setOvulationEndReminder(boolean var1) {
        this.ovulationEndReminder = var1;
    }

    public int getReminderHour() {
        return this.reminderHour;
    }

    public void setReminderHour(int var1) {
        this.reminderHour = var1;
    }

    public int getReminderMinute() {
        return this.reminderMinute;
    }

    public void setReminderMinute(int var1) {
        this.reminderMinute = var1;
    }
}
