# Android Device Tree for Motorola Edge 40 (`lyriq`)

Device configuration for **Motorola Edge 40 (`lyriq`)** targeting **LineageOS 22.1 (Android 15 / `ap4a`)**.

## Device Specifications

| Feature | Specification |
| :--- | :--- |
| **Device** | Motorola Edge 40 |
| **Codename** | `lyriq` (`XT2303-2`) |
| **SoC** | MediaTek Dimensity 8020 (`MT6891Z/CZA` · `mt6893` board platform) |
| **CPU** | Octa-core (4x Cortex-A78 @ 2.6 GHz + 4x Cortex-A55 @ 2.0 GHz) |
| **GPU** | Arm Mali-G77 MC9 |
| **Display** | 6.55" P-OLED, 2400 x 1080 (FHD+), 144 Hz, HDR10+ |
| **Memory / Storage** | 8 GB LPDDR4X / 256 GB UFS 3.1 |
| **Biometrics** | Under-Display Optical Fingerprint Sensor (Egis RBS / Goodix FOD via Trustonic TEE) |
| **Battery** | 4400 mAh (68W TurboPower wired / 15W wireless) |
| **Shipped Android** | Android 13 (Upgraded to Stock Android 15 `V1TLS35.73-60-3-10`) |

---

## Key Architecture & Bringup Highlights

- **OSS Vendor Build:** Full `vendor.img` built from source makefiles + stock Android 15 proprietary blobs ([`proprietary_vendor_motorola_lyriq`](https://github.com/ayushraj7520/proprietary_vendor_motorola_lyriq)).
- **UDFPS & Biometrics (Egis RBS AIDL + Trustonic TEE):**
  - Uses custom AIDL Fingerprint HAL (`android.hardware.biometrics.fingerprint-service.motorola`) from [`android_hardware_motorola`](https://github.com/ayushraj7520/android_hardware_motorola) paired with `libudfpshandler` (`udfps/UdfpsHandler.cpp`) for HBM/LHBM illumination control.
  - Includes `init.lyriq.trustlet_restore.rc` / `init.lyriq.trustlet_restore.sh` to sync factory-provisioned `.drbin`/`.tlbin` trustlets from `/data/vendor/mcRegistry` to `/mnt/vendor/tzapp`.
- **Sensors (MultiHAL 2.0 + SCP Nanohub):**
  - Uses AOSP `android.hardware.sensors-service.multihal` loading stock Android 15 `sensors.moto.so` and `android.hardware.sensors@2.X-subhal-mediatek.so`.
- **Connectivity, RIL & IMS:**
  - Dual-SIM 5G NR / LTE, VoLTE / VoNR (`mtkfusionrild`, Radio AIDL v3 & `mtkradioex` AIDL v2/v3), Wi-Fi 6 (`gen4m_6893`), Bluetooth Audio AIDL v4, and GNSS (`mnld` with `ro.vendor.rc=/vendor/etc/init/hw/`).

---

## Repository Dependencies (`.repo/local_manifests/lyriq.xml`)

```xml
<?xml version="1.0" encoding="UTF-8"?>
<manifest>
    <!-- Motorola Edge 40 (lyriq) Device, Kernel & Vendor Trees -->
    <project path="device/motorola/lyriq" name="ayushraj7520/android_device_motorola_lyriq" remote="github" revision="lineage-22.1" />
    <project path="device/motorola/lyriq-kernel" name="ayushraj7520/android_device_motorola_lyriq-kernel" remote="github" revision="lineage-22.1" />
    <project path="vendor/motorola/lyriq" name="ayushraj7520/proprietary_vendor_motorola_lyriq" remote="github" revision="lineage-22.1" />

    <!-- Motorola & MediaTek Hardware / SEPolicy Dependencies -->
    <project path="hardware/motorola" name="ayushraj7520/android_hardware_motorola" remote="github" revision="lineage-22.1" />
    <project path="hardware/mediatek" name="ayushraj7520/android_hardware_mediatek" remote="github" revision="lineage-22.1" />
    <project path="device/mediatek/sepolicy_vndr" name="ayushraj7520/android_device_mediatek_sepolicy_vndr" remote="github" revision="lineage-22.1" />
</manifest>
```

---

## Build Instructions

```bash
# 1. Apply required AOSP/LineageOS source tree patches (rild, sepolicy, codec2 headers, etc.)
./device/motorola/lyriq/apply-patches.sh

# 2. Set up environment and build flashable OTA zip
source build/envsetup.sh
lunch lineage_lyriq-ap4a-userdebug
mka bacon -j$(nproc)
```
