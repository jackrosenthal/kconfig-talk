# ...

# Support "make menuconfig" and "make guiconfig"
.PHONY: menuconfig genconfig
menuconfig guiconfig:
	KCONFIG_CONFIG="$(DOTCONFIG)" $@
