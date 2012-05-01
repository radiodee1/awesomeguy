
LOCAL_PATH:= $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE    := awesomeguy
LOCAL_CFLAGS    := -Werror -D GL_GLEXT_PROTOTYPES
LOCAL_SRC_FILES := awesomeguy.c androidgl.c
LOCAL_LDLIBS    := -llog -lGLESv1_CM -ldl -llog

include $(BUILD_SHARED_LIBRARY)
