#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

PRODUCT_ENFORCE_VINTF_MANIFEST := false

# Enforce generic ramdisk allow list
$(call inherit-product, $(SRC_TARGET_DIR)/product/generic_ramdisk.mk)

# Inherit launch_with_vendor_ramdisk product
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota/launch_with_vendor_ramdisk.mk)

# Project ID Quota
$(call inherit-product, $(SRC_TARGET_DIR)/product/emulated_storage.mk)

DEVICE_PATH := device/motorola/lyriq

# Virtual A/B

AB_OTA_POSTINSTALL_CONFIG += \
    RUN_POSTINSTALL_system=true \
    POSTINSTALL_PATH_system=system/bin/otapreopt_script \
    FILESYSTEM_TYPE_system=erofs \
    POSTINSTALL_OPTIONAL_system=true

PRODUCT_PACKAGES += \
    otapreopt_script

PRODUCT_PACKAGES += \
    e2fsck.vendor_ramdisk \
    fsck.f2fs.vendor_ramdisk \
    linker.vendor_ramdisk \
    resize2fs.vendor_ramdisk \
    tune2fs.vendor_ramdisk

PRODUCT_PACKAGES += \
    update_engine \
    update_engine_sideload \
    update_verifier \
    android.hardware.boot-service.default_recovery

# Boot animation
TARGET_SCREEN_HEIGHT := 2400
TARGET_SCREEN_WIDTH := 1080

# Characteristics
PRODUCT_CHARACTERISTICS := nosdcard

# Device uses high-density artwork where available
PRODUCT_AAPT_CONFIG := normal
PRODUCT_AAPT_PREF_CONFIG := xxhdpi

# Audio
$(call soong_config_set,android_hardware_audio,run_64bit,true)

PRODUCT_PACKAGES += \
    android.hardware.audio.common-util \
    libalsautils \
    libopus.vendor \
    audioclient-types-aidl-cpp.vendor \
    MtkInCallService

PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,$(LOCAL_PATH)/audio/,$(TARGET_COPY_OUT_VENDOR)/etc)

PRODUCT_COPY_FILES += \
    frameworks/av/services/audiopolicy/config/default_volume_tables.xml:$(TARGET_COPY_OUT_VENDOR)/etc/default_volume_tables.xml

# Dalvik
PRODUCT_PROPERTY_OVERRIDES += \
    dalvik.vm.heapstartsize=24m \
    dalvik.vm.heapgrowthlimit=256m \
    dalvik.vm.heapsize=512m \
    dalvik.vm.heaptargetutilization=0.46 \
    dalvik.vm.heapminfree=8m \
    dalvik.vm.heapmaxfree=48m

# Dynamic Partitions
PRODUCT_USE_DYNAMIC_PARTITIONS := true

# API
PRODUCT_SHIPPING_API_LEVEL := 33
BOARD_SHIPPING_API_LEVEL := 30

# Fastboot
PRODUCT_PACKAGES += \
    android.hardware.fastboot-service.example_recovery \
    fastbootd

# Bluetooth
PRODUCT_PACKAGES += \
    android.hardware.bluetooth.audio-impl

# Graphics
PRODUCT_VENDOR_PROPERTIES += \
    ro.hardware.egl=mali

-include device/motorola/lyriq/gpu_props.mk

# Lights
PRODUCT_PACKAGES += \
    android.hardware.power-service.example

# RIL / Modem props (MTK uses mtkfusionrild) - wired via PRODUCT_VENDOR_PROPERTIES
PRODUCT_VENDOR_PROPERTIES += \
    vendor.ril.mtk=1 \
    ro.vendor.mtk_ril_mode=c6m_1rild \
    persist.radio.multisim.config=dsds \
    ro.vendor.radio.max.multisim=dsds \
    ro.vendor.mtk_rild_read_imsi=1 \
    ro.vendor.mtk_eccci_c2k=1 \
    ro.vendor.mtk_protocol1_rat_config=N/Lf/Lt/W/G \
    ro.vendor.mtk_md1_support=22 \
    ro.vendor.mtk_md_world_mode_support=1 \
    ro.telephony.sim.count=2 \
    ro.telephony.iwlan_operation_mode=AP-assisted

# WiFi props
PRODUCT_VENDOR_PROPERTIES += \
    ro.vendor.wlan.gen=gen4m_6893 \
    ro.vendor.wlan.chrdev=wmt_chrdev_wifi_connac2 \
    ro.vendor.wlan.standalone.log=y

# Audio props
PRODUCT_VENDOR_PROPERTIES += \
    aaudio.mmap_exclusive_policy=2 \
    aaudio.mmap_policy=2 \
    ro.config.vc_call_vol_steps=8 \
    ro.vendor.audio.crystal_talk.supported=true \
    ro.vendor.audio.moto_sst_supported=true \
    ro.vendor.mtk_audio_tuning_tool_ver=V2.2 \
    ro.vendor.mtk_hifiaudio_support=1

# Health & Security
PRODUCT_PACKAGES += \
    com.android.hardware.thermal \
    android.hardware.security.keymint@3.0-service.trustonic_norkp \
    android.hardware.gatekeeper-service.trustonic \
    android.hardware.health-service.mediatek \
    android.hardware.health-service.mediatek-recovery

# Init
PRODUCT_PACKAGES += \
    fstab.mt6893 \
    fstab.mt6893.vendor_ramdisk \
    init.connectivity.rc \
    init.connectivity.common.rc \
    init_conninfra.rc \
    init.insmod.sh \
    init.lyriq.trustlet_restore.rc \
    init.lyriq.trustlet_restore.sh \
    init.mmi.overlay.rc \
    init.mmi.rc \
    init.modem.rc \
    init.mt6893.rc \
    init.mt6893.usb.rc \
    init.cgroup.rc \
    init.recovery.mt6893.rc \
    init.mtkgki.rc \
    init.oem.hw.sh \
    init.project.rc \
    init.sensor_2_0.rc \
    init.wifi_data.rc \
    ueventd.mt6893.rc

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(DEVICE_PATH) \
    hardware/mediatek

PRODUCT_PACKAGE_OVERLAYS += \
    $(DEVICE_PATH)/overlay


# Inherit the proprietary files
$(call inherit-product, vendor/motorola/lyriq/lyriq-vendor.mk)

PRODUCT_COPY_FILES += \
    device/motorola/lyriq/init/bpfloader_override.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/bpfloader_override.rc \
    frameworks/native/data/etc/android.hardware.fingerprint.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.fingerprint.xml \
    frameworks/native/data/etc/android.hardware.usb.host.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.host.xml \
    frameworks/native/data/etc/android.hardware.usb.accessory.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.accessory.xml

PRODUCT_VENDOR_PROPERTIES += \
    persist.vendor.fingerprint.type=udfps_optical \
    persist.vendor.fingerprint.sensor_location=540|2180|98 \
    persist.vendor.fingerprint.udfps.control_illumination=true

# Connectivity rc import path (init.mt6893.rc does: import ${ro.vendor.rc}init.connectivity.rc)
# Without this, init.connectivity*.rc never load -> mnld/gnss_daemon never start -> GPS dead
PRODUCT_VENDOR_PROPERTIES += \
    ro.vendor.rc=/vendor/etc/init/hw/

# Camera (stock values)
PRODUCT_VENDOR_PROPERTIES += \
    ro.vendor.camera.directfdyuv.support=1 \
    ro.vendor.camera.aishutter.support=1 \
    ro.vendor.camera.insensorzoom.support=0 \
    ro.vendor.camera.isp.support.colorspace=0 \
    ro.vendor.camera3.zsl.default=260 \
    ro.vendor.mtk_camera_app_version=3 \
    ro.vendor.mtk_fd_support=1 \
    persist.vendor.camera3.pipeline.bufnum.min.high_ram.fdyuv=6 \
    persist.vendor.camera3.pipeline.bufnum.min.low_ram.fdyuv=6 \
    persist.vendor.camera3.pipeline.bufnum.min.high_ram.imgo=6 \
    persist.vendor.camera3.pipeline.bufnum.min.low_ram.imgo=5 \
    persist.vendor.camera3.pipeline.bufnum.base.imgo=3 \
    persist.vendor.camera3.pipeline.bufnum.min.high_ram.rrzo=5 \
    persist.vendor.camera3.pipeline.bufnum.min.low_ram.rrzo=5 \
    persist.vendor.camera3.pipeline.bufnum.base.rrzo=3 \
    persist.vendor.camera3.pipeline.bufnum.min.high_ram.lcso=7 \
    persist.vendor.camera3.pipeline.bufnum.min.low_ram.lcso=6 \
    persist.vendor.camera3.pipeline.bufnum.base.lcso=4 \
    persist.vendor.camera3.pipeline.bufnum.min.high_ram.rsso=6 \
    persist.vendor.camera3.pipeline.bufnum.min.low_ram.rsso=5 \
    persist.vendor.camera3.pipeline.bufnum.base.rsso=4 \
    persist.vendor.camera.p1.streamBufCnt.imgo=10 \
    persist.vendor.camera.p1.streamBufCnt.rrzo=10 \
    persist.vendor.camera.p1.streamBufCnt.lcso=10 \
    persist.vendor.camera.expose.aux=1 \
    persist.vendor.camera.physical.num=3

# USB
PRODUCT_PACKAGES += \
    android.hardware.usb-V1-ndk

PRODUCT_VENDOR_PROPERTIES += \
    vendor.usb.use_ffs_mtp=1 \
    ro.vendor.usb.kpoc_adb=0 \
    ro.vendor.usb.support_analog_audio=true

# UDFPS Handler and OSS Fingerprint HAL
PRODUCT_PACKAGES += \
    libudfpshandler \
    android.hardware.sensors-service.multihal \
    android.hardware.sensors@1.0-convert-shared.vendor \
    android.hardware.biometrics.fingerprint-service.motorola
PRODUCT_PACKAGES += FrameworkResOverlayLyriq

# Enable ADB by default
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.adb.secure=0 \
    persist.sys.usb.config=adb



# ADB persist
PRODUCT_COPY_FILES += \
    device/motorola/lyriq/init/init.lyriq.adb.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/init.lyriq.adb.rc

# Sensor Properties
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.fusion.algorithm.in.sensorhub=yes \
    ro.vendor.mag.calibration.in.sensorhub=yes \
    ro.vendor.mtk.sensor.support=yes \
    ro.vendor.sensors.mot_ltv=true \
    ro.vendor.sensors.prox_for_call=true

# Sensor Permissions
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.sensor.accelerometer.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.accelerometer.xml \
    frameworks/native/data/etc/android.hardware.sensor.compass.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.compass.xml \
    frameworks/native/data/etc/android.hardware.sensor.gyroscope.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.gyroscope.xml \
    frameworks/native/data/etc/android.hardware.sensor.light.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.light.xml \
    frameworks/native/data/etc/android.hardware.sensor.proximity.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.proximity.xml \
    frameworks/native/data/etc/android.hardware.sensor.stepcounter.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.stepcounter.xml \
    frameworks/native/data/etc/android.hardware.sensor.stepdetector.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.stepdetector.xml

# 5G and Telephony
PRODUCT_PROPERTY_OVERRIDES += \
    ro.telephony.default_network=33,33 \
    ro.vendor.mtk_5g_support=1 \
    persist.vendor.radio.5g_mode_pref=1 \
    persist.vendor.radio.smart.data.switch=1
# Wi-Fi / Hotspot
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.wifi.sap.interface=ap0 \
    wifi.direct.interface=p2p0 \
    ro.vendor.mtk_wifi_5g_support=1 \
    ro.vendor.mtk_sap_5g_support=1 \
    persist.vendor.volte_support=1 \
    persist.vendor.mtk_volte_support=1 \
    ro.vendor.mtk_volte_support=1 \
    persist.vendor.mtk.volte.enable=1 \
    persist.vendor.mtk_vonr_support=1 \
    ro.vendor.wifi.5g=1

# Display (WCG, HDR, and Gesture Lag Fixes)
PRODUCT_PROPERTY_OVERRIDES += \
    ro.surface_flinger.has_wide_color_display=true \
    ro.surface_flinger.has_HDR_display=true \
    ro.surface_flinger.use_color_management=true \
    ro.surface_flinger.protected_contents=true \
    ro.surface_flinger.max_frame_buffer_acquired_buffers=4 \
    ro.surface_flinger.use_content_detection_for_refresh_rate=true \
    ro.surface_flinger.force_hwc_copy_for_virtual_displays=true
