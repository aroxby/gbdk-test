EXT_DIR=external

GBDK_URL=https://github.com/Zal0/gbdk-2020/releases/latest/download/gbdk-win.zip
GBDK_DIR=$(EXT_DIR)/gbdk
GBDK_CC=$(GBDK_DIR)/bin/lcc.exe

DEPENDS=$(GBDK_CC)

SRC_DIR=src
SRCS=$(shell find $(SRC_DIR) -name *.c)
OBJS=$(subst .c,.o,$(SRCS))
TARGET=gbdk-test.gb

.PHONY: all clean depend dist-clean tidy

all: $(TARGET)

$(EXT_DIR):
	mkdir $@

$(GBDK_DIR): $(EXT_DIR)
	curl $(GBDK_URL) -Lo $(EXT_DIR)/gbdk.zip
	unzip $(EXT_DIR)/gbdk.zip -d $(EXT_DIR)
	touch $@  # Fix GBDK_DIR timestamp so make will be happy

$(GBDK_CC): $(GBDK_DIR)

$(TARGET): $(OBJS)
	$(GBDK_CC) $< -o $@

%.o: %.c $(DEPENDS)
	$(GBDK_CC) -c $< -o $@

clean: tidy
	rm -f $(TARGET)

depend: $(DEPENDS)

dist-clean: clean
	rm -rf $(EXT_DIR)

tidy:
	rm -f $(OBJS)
