# Inherit common infamous stuff
$(call inherit-product, vendor/infamous/config/common.mk)

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

# Extra tools in infamous
PRODUCT_PACKAGES += \
    vim \
    zip \
    unrar
