#include "androidgl.h"

/**
 *	Used to notify JNI of android sdk version.
 *
 *	@param	env				required by all java jni
 *	@param	obj				required by all java jni
 *	@param	v				sdk version
 *	@return					void
 */
JNIEXPORT jint JNICALL Java_org_davidliebman_android_awesomeguy_Panel_JNItestScore(JNIEnv * env, jobject  obj)
{
	return score;
	////////////////////////
}
