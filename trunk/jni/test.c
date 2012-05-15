#include "androidgl.h"

/**
 *	Used to test JNI
 *
 *	@param	env				required by all java jni
 *	@param	obj				required by all java jni
 *	@return					score
 */
JNIEXPORT jint JNICALL Java_org_davidliebman_android_awesomeguy_Panel_JNItestScore(JNIEnv * env, jobject  obj)
{
	return score;
	////////////////////////
}
