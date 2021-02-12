# ...
DOTCONFIG := $(OUTDIR)/.config
AUTOHEADER := $(OUTDIR)/kconfig.h
CONFIG_OUT := $(OUTDIR)/build.conf

# Always call genconfig.  It won't write if the
# configuration was not changed.
_ := $(shell KCONFIG_CONFIG=$(CONFIG_OUT) \
	     genconfig --header-path="$(AUTOHEADER)" \
	               --config-out="$(CONFIG_OUT)")

# We can use the configs in our Makefile.
include "$(CONFIG_OUT)"

CFLAGS := -std=gnu17 -Wall -Werror -include "$(AUTOHEADER)"
# ...
