PARENT_DIR=$(patsubst %/,%,$(dir $(realpath $(lastword $(MAKEFILE_LIST)))))
PATH_MK=$(PARENT_DIR)/path.mk

ifeq ($(shell test -e $(PATH_MK) && echo -n "yes" || echo "no"),no)

$(PATH_MK):
	@echo "Please run 'configure' to create 'path.mk'"; exit 1

else

include $(PATH_MK)
	
endif

INSTALL=install
CC_FLAGS=-Wall -Wextra -pedantic
CC=cc
ZIP=bzip2

SRC=$(shell find $(PARENT_DIR) -name '*.c')
OBJ=$(SRC:.c=.o)
TARGET_NAME=realpath
TARGET=$(PARENT_DIR)/$(TARGET_NAME)

MAN=$(PARENT_DIR)/$(TARGET_NAME).1
COMPRESSED_MAN=$(MAN:%=%.bz2)

.PHONY: all clean distclean install uninstall

all: $(TARGET) $(COMPRESSED_MAN)

$(TARGET): $(OBJ)
	$(CC) -o $@ $< $(CC_FLAGS)

%.o: %.c
	$(CC) -o $@ -c $< $(CC_FLAGS)

$(COMPRESSED_MAN): $(MAN)
	$(ZIP) -f -k $<

clean:
	rm -f $(TARGET) \
		$(OBJ) \
		$(COMPRESSED_MAN)

distclean: clean
	rm -r $(PATH_MK)
	
install: all
	$(INSTALL) -m 755 "$(TARGET)" "$(BIN_DEST)/$(TARGET_NAME)"
	$(INSTALL) -m 644 "$(COMPRESSED_MAN)" "$(MAN_DEST)/man1/$(TARGET_NAME).1.bz2"

uninstall:
	rm $(BIN_DEST)/$(TARGET_NAME) $(MAN_DEST)/man1/$(TARGET_NAME).1.bz2
