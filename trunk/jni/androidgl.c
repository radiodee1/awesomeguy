/**
 * androidgl.c
 * 
 * native android library for open gl
 */

#include "androidgl.h"

static void check_gl_error(const char* op)
{
	GLint error;
	for (error = glGetError(); error; error = glGetError())
	LOGE("after %s() glError (0x%x)\n", op, error);
}

static void gluPerspective(GLfloat fovy, GLfloat aspect,
               GLfloat zNear, GLfloat zFar)//android ndk lacks glu tool kit (unbelievable)
{
    #define PI 3.1415926535897932f
    GLfloat xmin, xmax, ymin, ymax;

    ymax = zNear * (GLfloat)tan(fovy * PI / 360);
    ymin = -ymax;
    xmin = ymin * aspect;
    xmax = ymax * aspect;

    glFrustumx((GLfixed)(xmin * 65536), (GLfixed)(xmax * 65536),
               (GLfixed)(ymin * 65536), (GLfixed)(ymax * 65536),
               (GLfixed)(zNear * 65536), (GLfixed)(zFar * 65536));
    #undef PI
}


/**
 *	initialize opengles
 */

void init(void)
{
	int i;
	//int tex_width, tex_height;
	int tex_width = TEX_WIDTH;
	int tex_height = TEX_HEIGHT;

	if (!pixbuf) {
		pixbuf = malloc(tex_width * tex_height * 2);
	}

	//tex_width = TEX_WIDTH;
	//tex_height = TEX_HEIGHT;

	//GLint crop[4] = { 0, 0, tex_width, tex_height };
/*
	pixbuf = malloc(tex_width * tex_height * 2);
		for (i = 0; i < TEX_DIMENSION * TEX_DIMENSION ; i ++ ) {
		pixbuf[i] = 0xffff;//RGB565(0xf,0,0);
	}
*/	
	//glClearColor(1.0f, 0.0f, 0.0f, 0.0f);
	//glClear(GL_COLOR_BUFFER_BIT);

	glShadeModel(GL_SMOOTH);
	glClearDepthf(1.0f);
	glEnable(GL_DEPTH_TEST);
	glDepthFunc(GL_LEQUAL);
	glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST);


	

/*
	//onsurface changed
	//glViewport(0,0,tex_width, tex_height);
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
	//gluPerspective (45.0f, (float)tex_width/(float) tex_height, 0.1f, 100.0f);

	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();

	float vertices[] = {
	      -1.0f,  1.0f, 0.0f,  // 0, Top Left
	      -1.0f, -1.0f, 0.0f,  // 1, Bottom Left
	       1.0f, -1.0f, 0.0f,  // 2, Bottom Right
	       1.0f,  1.0f, 0.0f,  // 3, Top Right
	};
	short indices[] = { 0, 1, 2, 0, 2, 3 };

	glColor4f(0.5f, 0.5f, 1.0f, 1.0f);

	glEnableClientState(GL_VERTEX_ARRAY);
	//glVertexPointer(3, GL_FLOAT, 0, vertices);
	glFrontFace(GL_CCW);
	glEnable(GL_CULL_FACE);
	glCullFace(GL_BACK);
	glVertexPointer(3, GL_FLOAT, 0, vertices);
	glDrawElements( GL_TRIANGLES, 6, GL_UNSIGNED_SHORT, indices);

	glDisableClientState(GL_VERTEX_ARRAY);
	glDisable(GL_CULL_FACE);

	glColor4f(0.5f, 0.5f, 1.0f, 1.0f);

	if (glGetError() != GL_NO_ERROR) exit(3);
*/

}

void resize(int w, int h) {
	glViewport(0, 0, w, h);
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
	gluPerspective( 45.0f, (float) w/ (float) h, 
		0.1f, 100.0f);
	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();
}

void copy_to_texture() {

	int tex_width = TEX_WIDTH;
	int tex_height = TEX_HEIGHT;
	int i;

	
        for (i = 0; i < TEX_DIMENSION * TEX_DIMENSION ; i ++ ) {
		pixbuf[i] = RGB565(0xf,0,0);
	}

	
	int textures[] =  {0};
	glGenTextures(1, textures);
	texture_id = textures[0];

	glBindTexture(GL_TEXTURE_2D, texture_id);
	glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER,
		GL_NEAREST);
	glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER,
		GL_NEAREST);

	glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S,
		GL_CLAMP_TO_EDGE);
	glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T,
		GL_REPEAT);

	glTexImage2D(GL_TEXTURE_2D, 0, 
	        GL_RGB, 
	        tex_width, tex_height, 
	        0, 
	        GL_RGB,
	        GL_UNSIGNED_SHORT_5_6_5, 
	        pixbuf);

	

}

void draw() {
	int screen_width = TEX_WIDTH;
	int screen_height = TEX_HEIGHT;
	//int tex_height = TEX_HEIGHT;
	//int tex_width = TEX_WIDTH;
	int i,j;

	//LOGE("here");

	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

	float vertices[] = {
	      -1.0f,  1.0f, 0.0f,  // 0, Top Left
	      -1.0f, -1.0f, 0.0f,  // 1, Bottom Left
	       1.0f, -1.0f, 0.0f,  // 2, Bottom Right
	       1.0f,  1.0f, 0.0f,  // 3, Top Right
	};
	short indices[] = { 0, 1, 2, 0, 2, 3 };

	float tex_coords[] = {
		0.0f, 1.0f,
		1.0f, 1.0f,
		0.0f, 0.0f,
		1.0f, 0.0f };


	//glColor4f(0.5f, 0.5f, 1.0f, 1.0f);

	glEnableClientState(GL_VERTEX_ARRAY);

	glFrontFace(GL_CCW);
	glEnable(GL_CULL_FACE);
	glCullFace(GL_BACK);
	glEnable(GL_TEXTURE_2D);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);// GL_VERTEX_ARRAY);
	glEnableClientState(GL_VERTEX_ARRAY);
	glTexCoordPointer(2, GL_FLOAT, 0, tex_coords);
	glBindTexture(GL_TEXTURE_2D, texture_id);

	glVertexPointer(3, GL_FLOAT, 0, vertices);
	glDrawElements( GL_TRIANGLES, 6, GL_UNSIGNED_SHORT, indices);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);//GL_VERTEX_ARRAY);
	glDisableClientState(GL_VERTEX_ARRAY);
	glDisable(GL_CULL_FACE);

	//glColor4f(0.5f, 0.5f, 1.0f, 1.0f);
	glLoadIdentity();
	glTranslatef(0,0,-4);

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
 *	Used to copy info from the game screen to the opengl texture.
 *
 *	@param	env				required by all java jni
 *	@param	obj				required by all java jni
 *	@return					void
 */
JNIEXPORT void JNICALL Java_org_davidliebman_android_awesomeguy_Panel_JNIdraw(JNIEnv * env, jobject  obj)
{
	copy_to_texture();
	draw();
	//LOGE("draw");
	//glBindTexture(GL_TEXTURE_2D, 0);
	//glBindTexture(GL_TEXTURE_2D, texture);

}

/**
 *	Used to destroy the JNI resources.
 *
 *	@param	env				required by all java jni
 *	@param	obj				required by all java jni
 *	@return					void
 */
JNIEXPORT void JNICALL Java_org_davidliebman_android_awesomeguy_Panel_JNIdestroy(JNIEnv * env, jobject  obj)
{
	//screen_width = w;
	//screen_height = h;
	free(pixbuf);
	pixbuf = NULL;
}

JNIEXPORT void JNICALL Java_org_davidliebman_android_awesomeguy_Panel_JNIresize(JNIEnv * env, jobject  obj, jint w, jint h)
{
	screen_width = w;
	screen_height = h;
	//free(pixbuf);

	LOGE("resize");
	resize(w,h);
}
