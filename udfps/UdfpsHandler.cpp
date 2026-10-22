#include "UdfpsHandler.h"
#include <fcntl.h>
#include <sys/ioctl.h>
#include <android-base/logging.h>
#define _Bool bool
#include "mediatek_drm.h"
#include <unistd.h>
#include <android/binder_manager.h>
#include <android/binder_ibinder.h>
#include <android/binder_parcel.h>
#include <android/binder_status.h>

// Defines removed to prevent conflict with IMotoFodEventType

#include <aidl/com/motorola/hardware/biometric/fingerprint/IMotoFingerPrint.h>
#include <vector>

static void sendFodEventToMotoHAL(int eventType) {
    ::ndk::SpAIBinder binder(AServiceManager_checkService("com.motorola.hardware.biometric.fingerprint.IMotoFingerPrint/default"));
    if (binder.get() == nullptr) {
        LOG(ERROR) << "IMotoFingerPrint service not found!";
        return;
    }

    auto motoFp = ::aidl::com::motorola::hardware::biometric::fingerprint::IMotoFingerPrint::fromBinder(binder);
    if (!motoFp) {
        LOG(ERROR) << "Failed to cast to IMotoFingerPrint!";
        return;
    }

    // Pass a vector with a single dummy byte to ensure the optional is considered 
    // populated, preventing std::bad_optional_access from the HAL.
    std::vector<uint8_t> dummyData = { 0 };
    ::aidl::com::motorola::hardware::biometric::fingerprint::IMotoEventResult result;
    
    ::ndk::ScopedAStatus status = motoFp->sendFodEvent(
        static_cast<::aidl::com::motorola::hardware::biometric::fingerprint::IMotoFodEventType>(eventType),
        dummyData,
        &result
    );
    
    if (!status.isOk()) {
        LOG(ERROR) << "Failed to sendFodEvent: " << status.getDescription();
    } else {
        LOG(INFO) << "Successfully sent FOD event " << eventType;
    }
}

class UdfpsHandlerLyriq : public UdfpsHandler {
public:
    void init(fingerprint_device_t* device) override {}
    
    void onFingerDown(uint32_t x, uint32_t y, float minor, float major) override {
        setHbmState(2); // ON
        sendFodEventToMotoHAL(0); // 0 = FINGER_DOWN
    }
    
    void onFingerUp() override {
        setHbmState(0); // OFF
        sendFodEventToMotoHAL(1); // 1 = FINGER_UP
    }
    
    void onAcquired(int32_t result, int32_t vendorCode) override {}
    
    void onAuthenticationSucceeded() override {
        setHbmState(0); // OFF
        sendFodEventToMotoHAL(1); // 1 = FINGER_UP
    }
    
    void cancel() override {
        setHbmState(0); // OFF
        sendFodEventToMotoHAL(1); // 1 = FINGER_UP
    }

private:
    void setHbmState(int state) {
        struct panel_param_info param_info;
        int32_t node = open("/dev/dri/card0", O_RDWR);
        if (node < 0) {
            LOG(ERROR) << "Failed to get card0 node!";
            return;
        }
        
        param_info.param_idx = PARAM_HBM;
        param_info.value = state;
        
        int ret = ioctl(node, DRM_IOCTL_SET_PANEL_FEATURE, &param_info);
        if (ret < 0) {
            LOG(ERROR) << "Failed to set HBM state " << state << " via DRM IOCTL!";
        } else {
            LOG(INFO) << "Successfully set HBM state to " << state;
        }
        
        close(node);
    }
};

UdfpsHandler* createUdfpsHandler() {
    return new UdfpsHandlerLyriq();
}

void destroyUdfpsHandler(UdfpsHandler* handler) {
    delete handler;
}

extern "C" UdfpsHandlerFactory UDFPS_HANDLER_FACTORY = {
    .create = createUdfpsHandler,
    .destroy = destroyUdfpsHandler,
};
