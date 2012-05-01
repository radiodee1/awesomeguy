/**
 * androidgl.c
 * 
 * native android library for open gl
 */

#include "androidgl.h"

/**
 *	initialize opengles
 */
void init(void)
{
    int tex_width, tex_height;
    GLint crop[4] = { 0, screen_height, screen_width, - screen_height };

    tex_width = TEX_DIMENSION;
    tex_height = TEX_DIMENSION;

	if (!pixbuf) {
		pixbuf = malloc(tex_width * tex_height * 2);
	
		assert(pixbuf);
        
	}

	glEnable(GL_TEXTURE_2D);
	
	//glDeleteTextures(1, &texture);
	glGenTextures(1, &texture);
	glBindTexture(GL_TEXTURE_2D, texture);

	glTexParameterf( GL_TEXTURE_2D,
			GL_TEXTURE_MIN_FILTER, GL_LINEAR);

	glTexParameterf( GL_TEXTURE_2D,
			GL_TEXTURE_MAG_FILTER, GL_LINEAR);

	glTexParameteriv(GL_TEXTURE_2D, GL_TEXTURE_CROP_RECT_OES, crop);

	glShadeModel(GL_FLAT);

	glTexImage2D(GL_TEXTURE_2D, 0, 
		GL_RGB, 
		tex_width, tex_height, 
		0, 
		GL_RGB,
		GL_UNSIGNED_SHORT_5_6_5, 
		NULL);


	//glTexEnvf(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_REPLACE);



	glDisable(GL_BLEND);
	glDisable(GL_DITHER);
	glDisable(GL_DEPTH_TEST);
	glDisable(GL_FOG);
	glDisable(GL_LIGHTING);
	glDisable(GL_ALPHA_TEST);
	glDisable(GL_COLOR_LOGIC_OP);
	glDisable(GL_COLOR_MATERIAL);
	glDisable(GL_STENCIL_TEST);

	glDepthMask(GL_FALSE);
	glDisable(GL_CULL_FACE);


	//glClearColor(1.0f, 0.0f, 0.0f, 0.0f);

	//glClear(GL_COLOR_BUFFER_BIT);

}

void copy_to_texture() {
	//int screen_width = 256;
	//int screen_height = 256;
	int tex_height = TEX_DIMENSION;
	int tex_width = TEX_DIMENSION;
	int i,j;
	//for (i = 0; i < SCREEN_HEIGHT; i ++ ) {
	//	for(j = 0; j < SCREEN_WIDTH; j ++ ) {
			//pixbuf[( i * tex_height * 2 ) + j] = screen[i][j];
	//		pixbuf[( i * tex_height * 2 ) + ( j * 2 )] = 0xff;
	//		pixbuf[( i * tex_height * 2 ) + ( j * 2 ) + 1] = 0xff;
	//	}
	//}

	pthread_mutex_t lock;
	pthread_mutex_init(&lock, NULL);

	pthread_mutex_lock(&lock);
	for (i = 0; i < TEX_DIMENSION * TEX_DIMENSION ; i ++ ) {
		pixbuf[i] = RGB565(31,31,0);

	}

	glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT,
		GL_RGB, 
		//GL_UNSIGNED_SHORT_5_5_5_1,//
		GL_UNSIGNED_SHORT_5_6_5, 
		pixbuf);


	glDrawTexiOES(0, 0, 0, screen_width, screen_height);
	if (glGetError() != GL_NO_ERROR) exit(3);
	//LOGE("2: code");
	pthread_mutex_unlock(&lock);	
	
	glClearColor(1.0f, 0.0f, 0.0f, 0.0f);
	glClear(GL_COLOR_BUFFER_BIT);	//test

	//glBindTexture(GL_TEXTURE_2D, 0);
	//glBindTexture(GL_TEXTURE_2D, texture);

	//glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, tex_width, tex_height, 0, GL_RGB,
	//	GL_UNSIGNED_SHORT_5_6_5, pixbuf);


	
	
	
	//glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, VIDEO_WIDTH, VIDEO_HEIGHT,
	//	GL_RGB, GL_UNSIGNED_SHORT_5_6_5, pixbuf);

			//vp_os_mutex_lock( &config->mutex );
			//glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, VIDEO_WIDTH, VIDEO_HEIGHT,
			//		GL_RGB, GL_UNSIGNED_SHORT_5_6_5, config->data );
			//num = config->num_picture_decoded;

			//vp_os_mutex_unlock( &config->mutex );

}

/////////////////////////////////////////////////////
// JNI methods for androidgl.c
/////////////////////////////////////////////////////

/**
 *	Used to set JNI opengl library
 *
 *	@param	env				required by all java jni
 *	@param	obj				required by all java jni
 *	@return					void
 */
JNIEXPORT void JNICALL Java_org_davidliebman_android_awesomeguy_Panel_JNIinit(JNIEnv * env, jobject  obj, jint w, jint h)
{
	screen_width = w;
	screen_height = h;
	init();

}

/**
 *	Used to set JNI opengl library
 *
 *	@param	env				required by all java jni
 *	@param	obj				required by all java jni
 *	@return					void
 */
JNIEXPORT void JNICALL Java_org_davidliebman_android_awesomeguy_Panel_JNIcopyToTexture(JNIEnv * env, jobject  obj)
{
	
	copy_to_texture();

	//glBindTexture(GL_TEXTURE_2D, 0);
	//glBindTexture(GL_TEXTURE_2D, texture);





}
