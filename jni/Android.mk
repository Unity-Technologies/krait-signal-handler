LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE    := krait-signal-handler
LOCAL_SRC_FILES := krait_signal_handler.c
LOCAL_CFLAGS    := -Wall -Werror

ifeq ($(TARGET_ARCH_ABI), armeabi-v7a)
    LOCAL_CFLAGS += -mthumb
endif

include $(BUILD_STATIC_LIBRARY)
