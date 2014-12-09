# Inherit common infamous stuff
$(call inherit-product, vendor/infamous/config/common.mk)

# Bring in all video files
$(call inherit-product, frameworks/base/data/videos/VideoPackage2.mk)

# Include infamous audio files
include vendor/infamous/config/infamous_audio.mk

# Include infamous LatinIME dictionaries
PRODUCT_PACKAGE_OVERLAYS += vendor/infamous/overlay/dictionaries

# Optional infamous packages
PRODUCT_PACKAGES += \
    Galaxy4 \
    HoloSpiralWallpaper \
    LiveWallpapers \
    LiveWallpapersPicker \
    MagicSmokeWallpapers \
    NoiseField \
    PhaseBeam \
    VisualizationWallpapers \
    PhotoTable \
    SoundRecorder \
    PhotoPhase

PRODUCT_PACKAGES += \
    VideoEditor \
    libvideoeditor_jni \
    libvideoeditor_core \
    libvideoeditor_osal \
    libvideoeditor_videofilters \
    libvideoeditorplayer

# Extra tools in infamous
PRODUCT_PACKAGES += \
    vim \
    zip \
    unrar
