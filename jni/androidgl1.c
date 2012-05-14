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

static const char gVertexShader[] = 
    "attribute vec4 vPosition;\n"
    "void main() {\n"
    "  gl_Position = vPosition;\n"
    "}\n";

static const char gFragmentShader[] = 
    "precision mediump float;\n"
    "void main() {\n"
    "  gl_FragColor = vec4(0.0, 1.0, 0.0, 1.0);\n"
    "}\n";

static const char vertexShaderCode[] = 
        // This matrix member variable provides a hook to manipulate
        // the coordinates of the objects that use this vertex shader
        "uniform mat4 uMVPMatrix;   \n" 
        "attribute vec4 vPosition;  \n" 
        "void main(){               \n" 
        // the matrix must be included as a modifier of gl_Position
        " gl_Position = uMVPMatrix * vPosition; \n" 
        
        "}  \n";

GLuint gProgram;
GLuint gvPositionHandle;
/*
GLuint loadShader(GLenum shaderType, const char* pSource) {
    GLuint shader = glCreateShader(shaderType);
    if (shader) {
        glShaderSource(shader, 1, &pSource, NULL);
        glCompileShader(shader);
        GLint compiled = 0;
        glGetShaderiv(shader, GL_COMPILE_STATUS, &compiled);
        if (!compiled) {
            GLint infoLen = 0;
            glGetShaderiv(shader, GL_INFO_LOG_LENGTH, &infoLen);
            if (infoLen) {
                char* buf = (char*) malloc(infoLen);
                if (buf) {
                    glGetShaderInfoLog(shader, infoLen, NULL, buf);
                    LOGE("Could not compile shader %d:\n%s\n",
                            shaderType, buf);
                    free(buf);
                }
                glDeleteShader(shader);
                shader = 0;
            }
        }
    }
    return shader;
}
*/

/*
GLuint createProgram(const char* pVertexSource, const char* pFragmentSource) {
    GLuint vertexShader = loadShader(GL_VERTEX_SHADER, pVertexSource);
    if (!vertexShader) {
        return 0;
    }

    GLuint pixelShader = loadShader(GL_FRAGMENT_SHADER, pFragmentSource);
    if (!pixelShader) {
        return 0;
    }

    GLuint program = glCreateProgram();
    if (program) {
        glAttachShader(program, vertexShader);
        checkGlError("glAttachShader");
        glAttachShader(program, pixelShader);
        checkGlError("glAttachShader");
        glLinkProgram(program);
        GLint linkStatus = GL_FALSE;
        glGetProgramiv(program, GL_LINK_STATUS, &linkStatus);
        if (linkStatus != GL_TRUE) {
            GLint bufLength = 0;
            glGetProgramiv(program, GL_INFO_LOG_LENGTH, &bufLength);
            if (bufLength) {
                char* buf = (char*) malloc(bufLength);
                if (buf) {
                    glGetProgramInfoLog(program, bufLength, NULL, buf);
                    LOGE("Could not link program:\n%s\n", buf);
                    free(buf);
                }
            }
            glDeleteProgram(program);
            program = 0;
        }
    }
    return program;
}
*/
BOOL resize_gl2(int w, int h) {

	//eglCreateContext(GL_CONTEXT_CLIENT_VERSION, 2);
	/*
    printGLString("Version", GL_VERSION);
    printGLString("Vendor", GL_VENDOR);
    printGLString("Renderer", GL_RENDERER);
    printGLString("Extensions", GL_EXTENSIONS);

    LOGI("setupGraphics(%d, %d)", w, h);
    gProgram = createProgram(gVertexShader, gFragmentShader);
    //gProgram = createProgram(vertexShaderCode, gFragmentShader);
    if (!gProgram) {
        LOGE("Could not create program.");
        return FALSE;
    }
    gvPositionHandle = glGetAttribLocation(gProgram, "vPosition");
    checkGlError("glGetAttribLocation");
    LOGI("glGetAttribLocation(\"vPosition\") = %d\n",
            gvPositionHandle);

    glViewport(0, 0, w, h);
    checkGlError("glViewport");
    return TRUE;
    
    */
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

/*
    static float grey;
    grey += 0.01f;
    if (grey > 1.0f) {
        grey = 0.0f;
    }
    glClearColor(grey, grey, grey, 1.0f);
    checkGlError("glClearColor");
    glClear( GL_DEPTH_BUFFER_BIT | GL_COLOR_BUFFER_BIT);
    checkGlError("glClear");

    glUseProgram(gProgram);
    checkGlError("glUseProgram");

    glVertexAttribPointer(gvPositionHandle, 2, GL_FLOAT, GL_FALSE, 0, gTriangleVertices);
    //glVertexAttribPointer(gvPositionHandle, 3, GL_FLOAT, GL_FALSE, 0, triangleCoords);
    checkGlError("glVertexAttribPointer");
    glEnableVertexAttribArray(gvPositionHandle);
    checkGlError("glEnableVertexAttribArray");
    glDrawArrays(GL_TRIANGLES, 0, 3);
    checkGlError("glDrawArrays");
*/
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

	//pthread_cond_init(&s_vsync_cond, NULL);
	//pthread_mutex_init(&s_vsync_mutex, NULL);
	
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

	//pthread_mutex_t lock;
	//pthread_mutex_init(&lock, NULL);
	//pthread_mutex_lock(&lock);
	
	//LOGE("here");
	
	glTexImage2D(GL_TEXTURE_2D, 0, 
	        GL_RGBA,//
	        tex_width, tex_height, 
	        0, 
	        GL_RGBA,//
	        GL_UNSIGNED_SHORT_4_4_4_4,//
	        screen);//


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
	
	//pthread_mutex_unlock(&lock);

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

