include theos/makefiles/common.mk

TWEAK_NAME = EdgeAlert

EdgeAlert_FILES = /mnt/d/codes/edgealert/edgealerthook/EdgeAlert.xm
EdgeAlert_FRAMEWORKS = CydiaSubstrate Foundation CoreFoundation UIKit CoreGraphics QuartzCore
EdgeAlert_LDFLAGS = -Wl,-segalign,4000

export ARCHS = armv7 arm64
EdgeAlert_ARCHS = armv7 arm64

include $(THEOS_MAKE_PATH)/tweak.mk
	
all::
	