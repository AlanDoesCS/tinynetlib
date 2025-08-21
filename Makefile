# Compiler config
CC =			gcc
CSTD =			-std=c99
WARN = 			-Wall -Wextra
DBG = 		    -g -O2
INCLUDE =		-Iinclude

CFLAGS =		$(CSTD) $(WARN) $(DBG) $(INCLUDE) -MMD -MP
CFLAGS_PIC =	$(CFLAGS) -fPIC

AR =			ar
ARFLAGS =		rcs

# Project files
SRC_DIR =		src
INCLUDE_DIR =	include
DRIVER_DIR =	drivers
EXAMPLES_DIR =	examples
BUILD_DIR =		build

# Source files
SRC_FILES =		$(wildcard $(SRC_DIR)/*.c)
OBJ_FILES =		$(patsubst $(SRC_DIR)/%.c,$(BUILD_DIR)/%.o,$(SRC_FILES))
OBJ_PIC = 		$(patsubst $(SRC_DIR)/%.c,$(BUILD_DIR)/%_pic.o,$(SRC_FILES))

# Output types
STATIC = 		libtinynetlib.a
SHARED = 		libtinynetlib.so.0.1.0
SONAME = 		libtinynetlib.so.0

# Example programs
EXAMPLE_FILES =	$(wildcard $(EXAMPLES_DIR)/*.c)
EXAMPLE_BIN =	$(patsubst $(EXAMPLES_DIR)/%.c,$(BUILD_DIR)/%.o,$(EXAMPLE_FILES))

.PHONY: all clean examples

all: static shared

# Static library target
static: $(STATIC)
$(STATIC): $(OBJ_FILES)
	$(AR) $(ARFLAGS) $@ $^

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c | $(BUILD_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

# Shared library target
shared: $(SHARED) symlinks
$(SHARED): $(OBJ_PIC)
	$(CC) -shared -Wl,-soname,$(SONAME) -o $@ $^

$(BUILD_DIR)/%_pic.o: $(SRC_DIR)/%.c | $(BUILD_DIR)
	$(CC) $(CFLAGS_PIC) -c $< -o $@

symlinks:
	ln -sf $(SHARED) $(SONAME)
	ln -sf $(SHARED) libtinynetlib.so

# Examples
examples: $(EXAMPLE_BIN)

$(BUILD_DIR)/%: $(EXAMPLES_DIR)/%.c $(SHARED) | $(BUILD_DIR)
	$(CC) $(CFLAGS) $< -L. -ltinynetlib -Wl,-rpath,'$$ORIGIN/..' -o $@

# Miscellaneous
$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

-include $(OBJ_FILES:.o=.d) $(OBJ_PIC:.o=.d)

clean:
	rm -rf $(BUILD_DIR) $(STATIC) $(SHARED) libtinynetlib.so*
