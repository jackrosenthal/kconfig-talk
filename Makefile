OUTDIR ?= build
_create_outdir := $(shell [ -d $(OUTDIR) ] || mkdir -p $(OUTDIR))

DOTCONFIG := $(OUTDIR)/.config
AUTOHEADER := $(OUTDIR)/kconfig.h
CONFIG_OUT := $(OUTDIR)/build.conf

_ := $(shell KCONFIG_CONFIG=$(CONFIG_OUT) \
	     3rdparty/kconfiglib/genconfig.py \
		--header-path="$(AUTOHEADER)" \
		--config-out="$(CONFIG_OUT)")

include $(CONFIG_OUT)

CFLAGS:=-std=gnu17 -Wall -Wstrict-prototypes -Wmissing-prototypes \
	-Wundef -Wmissing-declarations -Iinclude -include "$(AUTOHEADER)" \
	$(CONFIG_COMPILER_DEBUG_SYMBOLS_FLAG) \
	$(CONFIG_COMPILER_OPT_FLAG) \
	$(CONFIG_COMPILER_ASAN_FLAG) \
	$(CONFIG_COMPILER_WARNINGS_ARE_ERRORS_FLAG) \
	$(CONFIG_LTO_FLAG)

LDFLAGS:=$(CONFIG_LINK_STATIC_FLAG) \
	$(CONFIG_LTO_FLAG) \
	$(CONFIG_COMPILER_DEBUG_SYMBOLS_FLAG) \
	$(CONFIG_COMPILER_ASAN_FLAG)

srcs-y := main.c
srcs-$(CONFIG_FOO) += foo.c
srcs-$(CONFIG_BAR) += bar.c

# Collect the source files
objfiles := $(patsubst %.c,$(OUTDIR)/%.o,$(srcs-y))
target := prog

ifeq ($(V),)
cmd = @printf '  %-6s %s\n' $(cmd_$(1)_name) "$(if $(2),$(2),"$@")" ; $(call cmd_$(1),$(2))
else
ifeq ($(V),1)
cmd = $(call cmd_$(1),$(2))
else
cmd = @$(call cmd_$(1),$(2))
endif
endif

DEPFLAGS = -MMD -MP -MF $@.d

cmd_c_to_o_name = CC
cmd_c_to_o = $(CONFIG_COMPILER_COMMAND) $(CFLAGS) $(DEPFLAGS) -c $< -o $@

cmd_o_to_elf_name = LD
cmd_o_to_elf = $(CONFIG_COMPILER_COMMAND) $(LDFLAGS) $^ -o $@

cmd_clean_name = CLEAN
cmd_clean = rm -rf $(1)

cmd_conf_name = CONF
cmd_conf = 3rdparty/kconfiglib/$(1).py

.SECONDARY:
.PHONY: all
all: $(OUTDIR)/$(target)

-include $(call rwildcard,$(OUTDIR),*.d)

CONFIG_UIS := menuconfig guiconfig
.PHONY: $(CONFIG_UIS)
$(CONFIG_UIS):
	$(call cmd,conf,$@)

$(OUTDIR)/$(target): $(objfiles)
	$(call cmd,o_to_elf)

# Depending on CONFIG_OUT will force a complete rebuild when config
# changes.
$(OUTDIR)/%.o: %.c $(CONFIG_OUT)
	$(call cmd,c_to_o)

.PHONY: clean
clean:
	$(call cmd,clean,$(OUTDIR))
