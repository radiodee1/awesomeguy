
LOCAL_PATH:= $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE    := awesomeguy-gl2
LOCAL_CFLAGS    := -Werror 
LOCAL_SRC_FILES := awesomeguy.c androidgl2.c
LOCAL_LDLIBS    := -llog -lGLESv2 
LOCAL_CFLAGS	:= -DGL2

include $(BUILD_SHARED_LIBRARY)

include $(CLEAR_VARS)

LOCAL_MODULE    := awesomeguy
LOCAL_CFLAGS    := -Werror 
LOCAL_SRC_FILES := awesomeguy.c androidgl1.c
LOCAL_LDLIBS    := -llog -lGLESv1_CM
#LOCAL_CFLAGS	:= -DGL1

include $(BUILD_SHARED_LIBRARY)
