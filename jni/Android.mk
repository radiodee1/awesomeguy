
LOCAL_PATH:= $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE    := awesomeguy
LOCAL_CFLAGS    := -Werror
LOCAL_SRC_FILES := awesomeguy.c
LOCAL_LDLIBS    := -llog 

include $(BUILD_SHARED_LIBRARY)
