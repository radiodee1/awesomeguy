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


	glShadeModel(GL_SMOOTH);
	glClearDepthf(1.0f);
	glEnable(GL_DEPTH_TEST);
	glDepthFunc(GL_LEQUAL);
	glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST);


}

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

void copy_to_texture() {

	int tex_width = TEX_WIDTH;
	int tex_height = TEX_HEIGHT;
	int i, j;
//	uint8_t r,g,b;
	
	//pthread_mutex_t lock;
	//pthread_mutex_init(&lock, NULL);
	//pthread_mutex_lock(&lock);
	
	memset(pixbuf, 0xffff, TEX_DIMENSION * TEX_DIMENSION * 2);

	for (i = 0; i < SCREEN_WIDTH; i ++) {
		for (j = 0; j < SCREEN_HEIGHT; j ++) {
		
			uint16_t temp = (uint16_t) screen[j][i];// << 1;
			
			//uint16_t r = (temp & 0xf800) >> 11;
			//uint16_t g = (temp & 0x07e0) >> 5;
			//uint16_t b = (temp & 0x001f) ;
			
			uint16_t a = (temp & 0xff000000) >> 24;
			uint16_t r = (temp & 0x00ff0000) >> 16;
			uint16_t g = (temp & 0x0000ff00) >> 8;
			uint16_t b = (temp & 0x000000ff) ;
			
			if ( FALSE && temp != 0x0 && (r & 0x80) >> 3 == 0 && r + g + b < 0x0f) {
				pixbuf[(j * TEX_WIDTH) + i ] =  RGB565 (0xff , g, b);
			}
			else {
				//pixbuf[(j * TEX_WIDTH) + i ] = temp ;
				pixbuf[(j * TEX_WIDTH) + i] = RGB565(r,g,b);
			}
		}
	}


	glTexImage2D(GL_TEXTURE_2D, 0, 
	        GL_RGB, 
	        tex_width, tex_height, 
	        0, 
	        GL_RGB,
	        GL_UNSIGNED_SHORT_5_6_5,
	        pixbuf);
	check_gl_error("glTexImage2D");

	//pthread_mutex_unlock(&lock);
}

void draw() {
	int screen_width = TEX_WIDTH;
	int screen_height = TEX_HEIGHT;
	//int tex_height = TEX_HEIGHT;
	//int tex_width = TEX_WIDTH;
	int i,j;

	//LOGE("here");

	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

	glEnableClientState(GL_VERTEX_ARRAY);

	glFrontFace(GL_CCW);
	glEnable(GL_CULL_FACE);
	glCullFace(GL_BACK);
	glEnable(GL_TEXTURE_2D);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	//glEnableClientState(GL_VERTEX_ARRAY);
	glTexCoordPointer(2, GL_FLOAT, 0, tex_coords);
	//glBindTexture(GL_TEXTURE_2D, texture_id);

	glVertexPointer(3, GL_FLOAT, 0, vertices);
	glDrawElements( GL_TRIANGLES, 6, GL_UNSIGNED_SHORT, indices);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	//glDisableClientState(GL_VERTEX_ARRAY);
	glDisable(GL_CULL_FACE);

	//glColor4f(0.5f, 0.5f, 1.0f, 1.0f);
	glLoadIdentity();
	glTranslatef(0,0, - 1.25f) ;


	if (glGetError() != GL_NO_ERROR) exit(3);
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
	
}

JNIEXPORT void JNICALL Java_org_davidliebman_android_awesomeguy_Panel_JNIresize(JNIEnv * env, jobject  obj, jint w, jint h)
{
	//screen_width = w;
	//screen_height = h;

	resize(w,h);
}
