export FW_DEVICE_IP=192.168.1.2
export FW_DEVICE_IP2=192.168.1.4

include theos/makefiles/common.mk

TWEAK_NAME = HomeSpringPage
HomeSpringPage_FILES = Tweak.xm
HomeSpringPage_FRAMEWORKS = UIKit Foundation CoreFoundation
HomeSpringPage_LDFLAGS = -Xlinker -unexported_symbol -Xlinker "*"

include $(THEOS_MAKE_PATH)/tweak.mk

ri:: remoteinstall
remoteinstall:: all internal-remoteinstall after-remoteinstall
internal-remoteinstall::
	scp -P 22 "$(FW_PROJECT_DIR)/obj/$(TWEAK_NAME).dylib" root@$(FW_DEVICE_IP):
	scp -P 22 "$(FW_PROJECT_DIR)/$(TWEAK_NAME).plist" root@$(FW_DEVICE_IP):
	ssh root@$(FW_DEVICE_IP) "mv $(TWEAK_NAME).* /Library/MobileSubstrate/DynamicLibraries/"
after-remoteinstall::
	ssh root@$(FW_DEVICE_IP) "killall -9 SpringBoard"

ri2:: remoteinstall2
remoteinstall2:: all internal-remoteinstall2 after-remoteinstall2
internal-remoteinstall2::
	scp -P 22 "$(FW_PROJECT_DIR)/obj/$(TWEAK_NAME).dylib" root@$(FW_DEVICE_IP2):
	scp -P 22 "$(FW_PROJECT_DIR)/$(TWEAK_NAME).plist" root@$(FW_DEVICE_IP2):
	ssh root@$(FW_DEVICE_IP2) "mv $(TWEAK_NAME).* /Library/MobileSubstrate/DynamicLibraries/"
after-remoteinstall2::
	ssh root@$(FW_DEVICE_IP2) "killall -9 SpringBoard"

