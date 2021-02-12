OUTDIR ?= build

_ := $(shell [ -d $(OUTDIR) ] || mkdir -p $(OUTDIR))

CFLAGS := -std=gnu17 -Wall -Werror
LDFLAGS :=

CC := gcc
srcs := main.c foo.c bar.c
objfiles := $(patsubst %.c,$(OUTDIR)/%.o,$(srcs))

$(OUTDIR)/myprog: $(objfiles)
	$(CC) $(LDFLAGS) $^ -o $@

$(OUTDIR)/%.o: %.c
	$(CC) $(CFLAGS) -MMD -MP -MF $@.d -c $< -o $@
