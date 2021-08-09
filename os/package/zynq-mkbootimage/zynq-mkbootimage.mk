################################################################################
#
# zynq-mkbootimage
#
################################################################################

HOST_ZYNQ_MKBOOTIMAGE_VERSION = 4ee42d782a9ba65725ed165a4916853224a8edf7
HOST_ZYNQ_MKBOOTIMAGE_SITE = https://github.com/antmicro/zynq-mkbootimage.git
HOST_ZYNQ_MKBOOTIMAGE_SITE_METHOD = git
HOST_ZYNQ_MKBOOTIMAGE_DEPENDENCIES += host-elfutils

define HOST_ZYNQ_MKBOOTIMAGE_BUILD_CMDS
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D) CFLAGS="$(HOST_CFLAGS)" LDFLAGS="$(HOST_LDFLAGS)"
endef

define HOST_ZYNQ_MKBOOTIMAGE_INSTALL_CMDS
	$(INSTALL) -D -m 755 $(@D)/mkbootimage $(HOST_DIR)/sbin/mkbootimage
endef


$(eval $(host-generic-package))
