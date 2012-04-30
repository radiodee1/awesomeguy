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
    GLint crop[4] = { 0, SCREEN_HEIGHT, SCREEN_WIDTH, - SCREEN_HEIGHT };

    // FIXME: this should be computed (smallest power of 2 > dimension)
    tex_width = TEX_DIMENSION;
    tex_height = TEX_DIMENSION;
    otick = 0;

    if (!pixbuf) {
	pixbuf = malloc(tex_width * tex_height * 2);
	//copy_to_texture();
	//uint8_t buffer[tex_height * tex_width * 2];
	//pixbuf = buffer;
	assert(pixbuf);
        //memcpy(pixbuf, default_image, VIDEO_WIDTH*VIDEO_HEIGHT*2);
	//copy_to_texture();
    }

	glEnable(GL_TEXTURE_2D);
	//glTexEnvx(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_REPLACE);
	
	//glDeleteTextures(1, &texture);
	glGenTextures(1, &texture);
	glBindTexture(GL_TEXTURE_2D, texture);

	glTexParameterf( GL_TEXTURE_2D,
			GL_TEXTURE_MIN_FILTER, GL_LINEAR);

	glTexParameterf( GL_TEXTURE_2D,
			GL_TEXTURE_MAG_FILTER, GL_LINEAR);

	glShadeModel( GL_FLAT );

    // Call glTexImage2D only once, and use glTexSubImage2D later
	glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, tex_width, tex_height, 0, 
		GL_RGB,
		//GL_UNSIGNED_SHORT_5_5_5_1,
		GL_UNSIGNED_SHORT_5_6_5, 
		NULL);


	glTexParameteriv(GL_TEXTURE_2D, GL_TEXTURE_CROP_RECT_OES, crop);

    //    glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, VIDEO_WIDTH, VIDEO_HEIGHT,
    //                                    GL_RGB, GL_UNSIGNED_SHORT_5_6_5, default_image);

	//glTexParameterx(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
	//glTexParameterx(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
	//glTexParameterx(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
	//glTexParameterx(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
	//glTexEnvx(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_REPLACE);



	glDisable(GL_BLEND);
	glDisable(GL_DITHER);
	glDisable(GL_DEPTH_TEST);


	glDepthMask(GL_FALSE);
	glDisable(GL_CULL_FACE);


	glClearColor(0.0f, 0.0f, 0.0f, 0.0f);


	glShadeModel(GL_FLAT);

	glClear(GL_COLOR_BUFFER_BIT);

	//glTexParameteri(GL_TEXTURE_2D, GL_GENERATE_MIPMAP, GL_TRUE );
}

void copy_to_texture() {
	int screen_width = 100;
	int screen_height = 100;
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
	//test
	pthread_mutex_t lock;
	pthread_mutex_init(&lock, NULL);

	pthread_mutex_lock(&lock);
	for (i = 0; i < TEX_DIMENSION * TEX_DIMENSION ; i ++ ) {
		pixbuf[i] = RGB565(0xf,0xf,0);

	}

	glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT,
		GL_RGB, 
		//GL_UNSIGNED_SHORT_5_5_5_1,//
		GL_UNSIGNED_SHORT_5_6_5, 
		pixbuf);


	glDrawTexiOES(0, 0, 0, tex_width, tex_height);
	if (glGetError() != GL_NO_ERROR) exit(3);
	LOGE("2: code");
	pthread_mutex_unlock(&lock);	


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
JNIEXPORT void JNICALL Java_org_davidliebman_android_awesomeguy_Panel_JNIinit(JNIEnv * env, jobject  obj)
{
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
	int tex_height = TEX_DIMENSION;
	int tex_width = TEX_DIMENSION;
	copy_to_texture();

	//glBindTexture(GL_TEXTURE_2D, 0);
	//glBindTexture(GL_TEXTURE_2D, texture);





}
