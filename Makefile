include theos/makefiles/common.mk

SUBPROJECTS += edgealerthook
SUBPROJECTS += edgealertsettings

include $(THEOS_MAKE_PATH)/aggregate.mk

all::
	
