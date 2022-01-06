################################################################################
#
# drivers
#
################################################################################

CUSTOM_DRIVERS_VERSION = roger
CUSTOM_DRIVERS_SITE = git@github.com:leboulec/projet_implementation_drivers.git
CUSTOM_DRIVERS_SITE_METHOD = git
CUSTOM_DRIVERS_DEPENDENCIES = linux

$(eval $(kernel-module))
$(eval $(generic-package))
