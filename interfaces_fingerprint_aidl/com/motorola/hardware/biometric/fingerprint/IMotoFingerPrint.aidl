/*
 * Copyright (C) 2026 The LineageOS Project
 *
 * SPDX-License-Identifier: Apache-2.0
 */

package com.motorola.hardware.biometric.fingerprint;

import com.motorola.hardware.biometric.fingerprint.FingerHardWareInfo;
import com.motorola.hardware.biometric.fingerprint.IMotoEventResult;
import com.motorola.hardware.biometric.fingerprint.IMotoFingerprintCallback;
import com.motorola.hardware.biometric.fingerprint.IMotoFodEventType;

interface IMotoFingerPrint {
    String getCheckinVersion();
    FingerHardWareInfo getHardwareInfo();
    String[] getUnlockPerformanceData();
    IMotoEventResult sendFodEvent(in IMotoFodEventType eventType, in @nullable byte[] eventData);
    int cancel();
    IMotoEventResult sendCommand(in int commandId, in byte[] param);
    void setNotify(in IMotoFingerprintCallback cb);
}
