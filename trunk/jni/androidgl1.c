/**
 * androidgl.c
 * 
 * native android library for open gl
 */

#include "androidgl.h"



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

static void printGLString(const char *name, GLenum s) {
    const char *v = (const char *) glGetString(s);
    LOGI("GL %s = %s\n", name, v);
}

static void checkGlError(const char* op) {
	GLint error;
    for (error = glGetError(); error; error
            = glGetError()) {
        LOGI("after %s() glError (0x%x)\n", op, error);
    }
}



BOOL resize_gl2(int w, int h) {


}


const GLfloat gTriangleVertices[] = { 
	0.0f, 0.5f, 
	-0.5f, -0.5f,
	0.5f, -0.5f };

GLfloat triangleCoords[] = {
            // X, Y, Z
            -0.5f, -0.25f, 0,
             0.5f, -0.25f, 0,
             0.0f,  0.559016994f, 0
        }; 


void draw_gl2() {


}


/**
 *	initialize opengles 1.0
 */

void init(void)
{
	int i;
	//int tex_width, tex_height;
	int tex_width = TEX_WIDTH;
	int tex_height = TEX_HEIGHT;

	
	
	glShadeModel(GL_SMOOTH);
	glClearDepthf(1.0f);
	glEnable(GL_DEPTH_TEST);
	glDepthFunc(GL_LEQUAL);
	glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST);
	

}

/**
 *	Set screen size for opengles
 */
void resize(int w, int h) {



	float w_h_ratio = (float) w/ (float) h; // specifically for vertices
	float h_w_ratio =  3.0f/  4.0f; // specifically for texture
	
	/* vertices array */
	vertices[0] =  - (w_h_ratio / 2.0f) ;
	vertices[1] = 0.5f; 
	vertices[2] = 0.0f;  // 0, Top Left
	
	vertices[3] =  - (w_h_ratio / 2.0f) ;
	vertices[4] = -0.5f; 
	vertices[5] = 0.0f;  // 1, Bottom Left
	
	vertices[6] = (w_h_ratio / 2.0f) ;
	vertices[7] = -0.5f; 
	vertices[8] = 0.0f;  // 2, Bottom Right
	
	vertices[9] = (w_h_ratio / 2.0f) ;
	vertices[10] = 0.5f; 
	vertices[11] = 0.0f;  // 3, Top Right
	
	/* texture coordinates array */
	tex_coords[0] = 0.0f;
	tex_coords[1] = 0.0f; //1
	
	tex_coords[2] = 0.0f; 
	tex_coords[3] = h_w_ratio;//1.0f; //2
	
	tex_coords[4] = 1.0f; 
	tex_coords[5] = h_w_ratio;//1.0f; //3
	
	tex_coords[6] = 1.0f; 
	tex_coords[7] = 0.0f; //4
	
	
	glViewport(0, 0, w, h);	
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
	gluPerspective( 45.0f, (float) w/ (float) h, 
		0.1f, 100.0f);
	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();

	glGenTextures(1, &texture_id);

	glBindTexture(GL_TEXTURE_2D, texture_id);
	glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER,
		GL_NEAREST);
	glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER,
		GL_NEAREST);

	glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S,
		GL_CLAMP_TO_EDGE);
	glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T,
		GL_REPEAT);

	

	screen_width = w;
	screen_height = h;
}

/**
 *	Opengles specific draw function.
 */
void draw() {

	int tex_width = TEX_WIDTH;
	int tex_height = TEX_HEIGHT;


	
	glTexImage2D(GL_TEXTURE_2D, 0, 
	        GL_RGBA,//
	        tex_width, tex_height, 
	        0, 
	        GL_RGBA,//
	        GL_UNSIGNED_SHORT_4_4_4_4,//
	        getScreenPointer(MY_SCREEN_FRONT));//screen


	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

	glEnableClientState(GL_VERTEX_ARRAY);

	glFrontFace(GL_CCW);
	glEnable(GL_CULL_FACE);
	glCullFace(GL_BACK);
	glEnable(GL_TEXTURE_2D);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);

	glTexCoordPointer(2, GL_FLOAT, 0, tex_coords);


	glVertexPointer(3, GL_FLOAT, 0, vertices);
	glDrawElements( GL_TRIANGLES, 6, GL_UNSIGNED_SHORT, indices);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);

	glDisable(GL_CULL_FACE);


	glLoadIdentity();
	glTranslatef(0,0, - 1.25f) ;

	glFinish();
	glFlush();
	


}

/**
 * 	Used by draw functions to rearrange pixels before opengl sends them to the 
 *	screen.
 */
uint16_t color_pixel(uint16_t temp) {

	uint16_t p = 0;
	
	uint16_t a = (temp & 0xf000) >> 12;
	uint16_t r = (temp & 0x0f00) >> 8;
	uint16_t g = (temp & 0x00f0) >> 4;
	uint16_t b = (temp & 0x000f) ;
	
	if (temp != 0x0 && (r & 0x80) >> 3 == 0 && (r + g + b) < 0x03 ) {
		p =  RGBA4444( 0xff , g, b, 0);
	}
	else {
		p = RGBA4444(r,g,b,0);
	}
	return p;
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
	if (! use_gl2) {
		init();
	}
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
	if (! use_gl2) {
		draw();
	}
	else {
		//LOGE("draw");
		draw_gl2();
	}
}

/**
 *	Used to resize the opengl texture whenever the device screen resizes.
 *
 *	@param	env				required by all java jni
 *	@param	obj				required by all java jni
 *	@param	w				screen width
 *	@param	h				screen height
 *	@return					void
 */

JNIEXPORT void JNICALL Java_org_davidliebman_android_awesomeguy_Panel_JNIresize(JNIEnv * env, jobject  obj, jint w, jint h)
{
	//screen_width = w;
	//screen_height = h;
	if (! use_gl2) {
		resize(w,h);
	}
	else {
		resize_gl2(w,h);
	}
}

/**
 *	Used to notify JNI of android sdk version.
 *
 *	@param	env				required by all java jni
 *	@param	obj				required by all java jni
 *	@param	v				sdk version
 *	@return					void
 */
JNIEXPORT void JNICALL Java_org_davidliebman_android_awesomeguy_Panel_JNIsetVersion(JNIEnv * env, jobject  obj, jint v)
{
	if (v >= 10) use_gl2 = TRUE;
	else use_gl2 = FALSE;

}

/**
 *	Used to build the screen pixbuf. Replaces 'drawLevel()'
 *
 *	@param	env				required by all java jni
 *	@param	obj				required by all java jni
 *	@return					void
 */
JNIEXPORT void JNICALL Java_org_davidliebman_android_awesomeguy_Panel_JNIbuildLevel(JNIEnv * env, jobject  obj)
{
	
	animate_vars();
	
	drawLevel(0);
	////////////////////////
	incrementScreenCounter();
}

