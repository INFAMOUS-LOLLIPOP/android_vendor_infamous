PRODUCT_BRAND ?= Infamous

SUPERUSER_EMBEDDED := true
SUPERUSER_PACKAGE_PREFIX := com.android.settings.cyanogenmod.superuser

ifneq ($(TARGET_SCREEN_WIDTH) $(TARGET_SCREEN_HEIGHT),$(space))
# determine the smaller dimension
TARGET_BOOTANIMATION_SIZE := $(shell \
  if [ $(TARGET_SCREEN_WIDTH) -lt $(TARGET_SCREEN_HEIGHT) ]; then \
    echo $(TARGET_SCREEN_WIDTH); \
  else \
    echo $(TARGET_SCREEN_HEIGHT); \
  fi )

# get a sorted list of the sizes
bootanimation_sizes := $(subst .zip,, $(shell ls vendor/infamous/prebuilt/common/bootanimation))
bootanimation_sizes := $(shell echo -e $(subst $(space),'\n',$(bootanimation_sizes)) | sort -rn)

# find the appropriate size and set
define check_and_set_bootanimation
$(eval TARGET_BOOTANIMATION_NAME := $(shell \
  if [ -z "$(TARGET_BOOTANIMATION_NAME)" ]; then
    if [ $(1) -le $(TARGET_BOOTANIMATION_SIZE) ]; then \
      echo $(1); \
      exit 0; \
    fi;
  fi;
  echo $(TARGET_BOOTANIMATION_NAME); ))
endef
$(foreach size,$(bootanimation_sizes), $(call check_and_set_bootanimation,$(size)))

ifeq ($(TARGET_BOOTANIMATION_HALF_RES),true)
PRODUCT_BOOTANIMATION := vendor/infamous/prebuilt/common/bootanimation/halfres/$(TARGET_BOOTANIMATION_NAME).zip
else
PRODUCT_BOOTANIMATION := vendor/infamous/prebuilt/common/bootanimation/$(TARGET_BOOTANIMATION_NAME).zip
endif
endif

ifdef INFAMOUS_NIGHTLY
PRODUCT_PROPERTY_OVERRIDES += \
    ro.rommanager.developerid=cyanogenmodnightly
else
PRODUCT_PROPERTY_OVERRIDES += \
    ro.rommanager.developerid=cyanogenmod
endif

PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0

ifeq ($(PRODUCT_GMS_CLIENTID_BASE),)
PRODUCT_PROPERTY_OVERRIDES += \
    ro.com.google.clientidbase=android-google
else
PRODUCT_PROPERTY_OVERRIDES += \
    ro.com.google.clientidbase=$(PRODUCT_GMS_CLIENTID_BASE)
endif

PRODUCT_PROPERTY_OVERRIDES += \
    keyguard.no_require_sim=true \
    ro.url.legal=http://www.google.com/intl/%s/mobile/android/basic/phone-legal.html \
    ro.url.legal.android_privacy=http://www.google.com/intl/%s/mobile/android/basic/privacy.html \
    ro.com.android.wifi-watchlist=GoogleGuest \
    ro.setupwizard.enterprise_mode=1 \
    ro.com.android.dateformat=MM-dd-yyyy \
    ro.com.android.dataroaming=false

PRODUCT_PROPERTY_OVERRIDES += \
    ro.build.selinux=1

# Disable multithreaded dexopt by default
PRODUCT_PROPERTY_OVERRIDES += \
    persist.sys.dalvik.multithread=false

# Thank you, please drive thru!
PRODUCT_PROPERTY_OVERRIDES += persist.sys.dun.override=0

ifneq ($(TARGET_BUILD_VARIANT),eng)
# Enable ADB authentication
ADDITIONAL_DEFAULT_PROPERTIES += ro.adb.secure=1
endif

# Copy over the changelog to the device
PRODUCT_COPY_FILES += \
    vendor/infamous/CHANGELOG.mkdn:system/etc/CHANGELOG-INFAMOUS.txt

# Backup Tool
ifneq ($(WITH_GMS),true)
PRODUCT_COPY_FILES += \
    vendor/infamous/prebuilt/common/bin/backuptool.sh:system/bin/backuptool.sh \
    vendor/infamous/prebuilt/common/bin/backuptool.functions:system/bin/backuptool.functions \
    vendor/infamous/prebuilt/common/bin/50-cm.sh:system/addon.d/50-cm.sh \
    vendor/infamous/prebuilt/common/bin/blacklist:system/addon.d/blacklist
endif

# Signature compatibility validation
PRODUCT_COPY_FILES += \
    vendor/infamous/prebuilt/common/bin/otasigcheck.sh:system/bin/otasigcheck.sh

# init.d support
PRODUCT_COPY_FILES += \
    vendor/infamous/prebuilt/common/etc/init.d/00banner:system/etc/init.d/00banner \
    vendor/infamous/prebuilt/common/bin/sysinit:system/bin/sysinit

# userinit support
PRODUCT_COPY_FILES += \
    vendor/infamous/prebuilt/common/etc/init.d/90userinit:system/etc/init.d/90userinit

# infamous-specific init file
PRODUCT_COPY_FILES += \
    vendor/infamous/prebuilt/common/etc/init.local.rc:root/init.cm.rc
	
# Viper4Android
PRODUCT_COPY_FILES += \
    vendor/infamous/prebuilt/common/etc/viper4android/viper4android.apk:system/app/Viper4Android/viper4android.apk	

# Bring in camera effects
PRODUCT_COPY_FILES +=  \
    vendor/infamous/prebuilt/common/media/LMprec_508.emd:system/media/LMprec_508.emd \
    vendor/infamous/prebuilt/common/media/PFFprec_600.emd:system/media/PFFprec_600.emd

# Enable SIP+VoIP on all targets
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml

# Enable wireless Xbox 360 controller support
PRODUCT_COPY_FILES += \
    frameworks/base/data/keyboards/Vendor_045e_Product_028e.kl:system/usr/keylayout/Vendor_045e_Product_0719.kl

# This is Infamous!
PRODUCT_COPY_FILES += \
    vendor/infamous/config/permissions/com.cyanogenmod.android.xml:system/etc/permissions/com.cyanogenmod.android.xml

# T-Mobile theme engine
include vendor/infamous/config/themes_common.mk

# Required infamous packages
PRODUCT_PACKAGES += \
    Development \
    LatinIME \
    BluetoothExt

# Optional infamous packages
PRODUCT_PACKAGES += \
    VoicePlus \
    Basic \
    libemoji

# Custom infamous packages
PRODUCT_PACKAGES += \
    Launcher3 \
    Trebuchet \
    DSPManager \
    libcyanogen-dsp \
    audio_effects.conf \
    CMWallpapers \
    Apollo \
    CMFileManager \
    LockClock \
    CMHome \
    PerformanceControl
	
# Adaway	
PRODUCT_COPY_FILES += \
    vendor/infamous/prebuilt/common/app/Adaway/org.adaway.apk:system/app/Adaway/org.adaway.apk	

# infamous Hardware Abstraction Framework
PRODUCT_PACKAGES += \
    org.cyanogenmod.hardware \
    org.cyanogenmod.hardware.xml

# Extra tools in infamous
PRODUCT_PACKAGES += \
    libsepol \
    openvpn \
    e2fsck \
    mke2fs \
    tune2fs \
    bash \
    nano \
    htop \
    powertop \
    lsof \
    mount.exfat \
    fsck.exfat \
    mkfs.exfat \
    mkfs.f2fs \
    fsck.f2fs \
    fibmap.f2fs \
    ntfsfix \
    ntfs-3g \
    gdbserver \
    micro_bench \
    oprofiled \
    sqlite3 \
    strace

# Openssh
PRODUCT_PACKAGES += \
    scp \
    sftp \
    ssh \
    sshd \
    sshd_config \
    ssh-keygen \
    start-ssh

# rsync
PRODUCT_PACKAGES += \
    rsync

# Stagefright FFMPEG plugin
PRODUCT_PACKAGES += \
    libstagefright_soft_ffmpegadec \
    libstagefright_soft_ffmpegvdec \
    libFFmpegExtractor \
    libnamparser

# These packages are excluded from user builds
ifneq ($(TARGET_BUILD_VARIANT),user)

PRODUCT_PACKAGES += \
    procmem \
    procrank \
    Superuser \
    su

# Terminal Emulator
PRODUCT_COPY_FILES +=  \
    vendor/infamous/proprietary/Term.apk:system/app/Term/Term.apk \
    vendor/infamous/proprietary/lib/armeabi/libjackpal-androidterm4.so:system/app/Term/lib/arm/libjackpal-androidterm4.so

PRODUCT_PROPERTY_OVERRIDES += \
    persist.sys.root_access=1
else

PRODUCT_PROPERTY_OVERRIDES += \
    persist.sys.root_access=0

endif

PRODUCT_PACKAGE_OVERLAYS += vendor/infamous/overlay/common

PRODUCT_VERSION_MAJOR = LP
PRODUCT_VERSION_MINOR = 0
PRODUCT_VERSION_MAINTENANCE = 0.1

# Set INFAMOUS_BUILDTYPE from the env RELEASE_TYPE, for jenkins compat

ifndef INFAMOUS_BUILDTYPE
    ifdef RELEASE_TYPE
        # Starting with "INFAMOUS_" is optional
        RELEASE_TYPE := $(shell echo $(RELEASE_TYPE) | sed -e 's|^INFAMOUS_||g')
        INFAMOUS_BUILDTYPE := $(RELEASE_TYPE)
    endif
endif

# Filter out random types, so it'll reset to UNOFFICIAL
ifeq ($(filter RELEASE NIGHTLY SNAPSHOT EXPERIMENTAL,$(INFAMOUS_BUILDTYPE)),)
    INFAMOUS_BUILDTYPE :=
endif

ifdef INFAMOUS_BUILDTYPE
    ifneq ($(INFAMOUS_BUILDTYPE), SNAPSHOT)
        ifdef INFAMOUS_EXTRAVERSION
            # Force build type to EXPERIMENTAL
            INFAMOUS_BUILDTYPE := EXPERIMENTAL
            # Remove leading dash from INFAMOUS_EXTRAVERSION
            INFAMOUS_EXTRAVERSION := $(shell echo $(INFAMOUS_EXTRAVERSION) | sed 's/-//')
            # Add leading dash to INFAMOUS_EXTRAVERSION
            INFAMOUS_EXTRAVERSION := -$(INFAMOUS_EXTRAVERSION)
        endif
    else
        ifndef INFAMOUS_EXTRAVERSION
            # Force build type to EXPERIMENTAL, SNAPSHOT mandates a tag
            INFAMOUS_BUILDTYPE := EXPERIMENTAL
        else
            # Remove leading dash from INFAMOUS_EXTRAVERSION
            INFAMOUS_EXTRAVERSION := $(shell echo $(INFAMOUS_EXTRAVERSION) | sed 's/-//')
            # Add leading dash to INFAMOUS_EXTRAVERSION
            INFAMOUS_EXTRAVERSION := -$(INFAMOUS_EXTRAVERSION)
        endif
    endif
else
    # If INFAMOUS_BUILDTYPE is not defined, set to UNOFFICIAL
    INFAMOUS_BUILDTYPE := BETA
    INFAMOUS_EXTRAVERSION :=
endif

ifeq ($(INFAMOUS_BUILDTYPE), UNOFFICIAL)
    ifneq ($(TARGET_UNOFFICIAL_BUILD_ID),)
        INFAMOUS_EXTRAVERSION := -$(TARGET_UNOFFICIAL_BUILD_ID)
    endif
endif

ifeq ($(INFAMOUS_BUILDTYPE), RELEASE)
    ifndef TARGET_VENDOR_RELEASE_BUILD_ID
        INFAMOUS_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR).$(PRODUCT_VERSION_MAINTENANCE)$(PRODUCT_VERSION_DEVICE_SPECIFIC)-$(INFAMOUS_BUILD)
    else
        ifeq ($(TARGET_BUILD_VARIANT),user)
            INFAMOUS_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR)-$(TARGET_VENDOR_RELEASE_BUILD_ID)-$(INFAMOUS_BUILD)
        else
            INFAMOUS_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR).$(PRODUCT_VERSION_MAINTENANCE)$(PRODUCT_VERSION_DEVICE_SPECIFIC)-$(INFAMOUS_BUILD)
        endif
    endif
else
    ifeq ($(PRODUCT_VERSION_MINOR),0)
        INFAMOUS_VERSION := $(PRODUCT_VERSION_MAJOR)-$(shell date -u +%Y%m%d)-$(INFAMOUS_BUILDTYPE)$(INFAMOUS_EXTRAVERSION)-$(INFAMOUS_BUILD)
    else
        INFAMOUS_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR)-$(shell date -u +%Y%m%d)-$(INFAMOUS_BUILDTYPE)$(INFAMOUS_EXTRAVERSION)-$(INFAMOUS_BUILD)
    endif
endif

PRODUCT_PROPERTY_OVERRIDES += \
  ro.infamous.version=$(INFAMOUS_VERSION) \
  ro.infamous.releasetype=$(INFAMOUS_BUILDTYPE) \
  ro.modversion=$(INFAMOUS_VERSION) \


INFAMOUS_DISPLAY_VERSION := $(INFAMOUS_VERSION)

ifneq ($(PRODUCT_DEFAULT_DEV_CERTIFICATE),)
ifneq ($(PRODUCT_DEFAULT_DEV_CERTIFICATE),build/target/product/security/testkey)
  ifneq ($(INFAMOUS_BUILDTYPE), UNOFFICIAL)
    ifndef TARGET_VENDOR_RELEASE_BUILD_ID
      ifneq ($(INFAMOUS_EXTRAVERSION),)
        # Remove leading dash from INFAMOUS_EXTRAVERSION
        INFAMOUS_EXTRAVERSION := $(shell echo $(INFAMOUS_EXTRAVERSION) | sed 's/-//')
        TARGET_VENDOR_RELEASE_BUILD_ID := $(INFAMOUS_EXTRAVERSION)
      else
        TARGET_VENDOR_RELEASE_BUILD_ID := $(shell date -u +%Y%m%d)
      endif
    else
      TARGET_VENDOR_RELEASE_BUILD_ID := $(TARGET_VENDOR_RELEASE_BUILD_ID)
    endif
    INFAMOUS_DISPLAY_VERSION=$(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR)-$(TARGET_VENDOR_RELEASE_BUILD_ID)
  endif
endif
endif

# by default, do not update the recovery with system updates
PRODUCT_PROPERTY_OVERRIDES += persist.sys.recovery_update=false

PRODUCT_PROPERTY_OVERRIDES += \
  ro.infamous.display.version=$(INFAMOUS_DISPLAY_VERSION)

-include $(WORKSPACE)/build_env/image-auto-bits.mk

-include vendor/cyngn/product.mk

$(call inherit-product-if-exists, vendor/extra/product.mk)
