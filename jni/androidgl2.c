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
    LOGE("GL %s = %s\n", name, v);
}

static void checkGlError(const char* op) {
	GLint error;
    for (error = glGetError(); error; error
            = glGetError()) {
        LOGE("after %s() glError (0x%x)\n", op, error);
    }
}



static const char gVertexShader[] = 
	"attribute vec4 Position; \n"
	"attribute vec4 SourceColor; \n"
	
	"varying vec4 DestinationColor; \n" 
 
 	"uniform mat4 Projection; \n"
 	"uniform mat4 Modelview; \n"
 	
 	"attribute vec2 TexCoordIn; \n"
 	"varying vec2 TexCoordOut; \n"
	"void main(void) { \n"
    	"  DestinationColor = SourceColor; \n"
    	// gl_Position = Projection * Modelview * Position; 
    	"  gl_Position =    Position; \n"
    	"  TexCoordOut = TexCoordIn; \n"
	"} \n";






static const char gFragmentShader[] = 
	"varying lowp vec4 DestinationColor;\n" 
	"varying lowp vec2 TexCoordOut; \n"
	"uniform sampler2D Texture; \n"
	"void main(void) {\n" 
	//"  gl_FragColor = DestinationColor * texture2D(Texture, TexCoordOut);\n" 
	"  gl_FragColor =  texture2D(Texture, TexCoordOut);\n" 
	"} \n";

  

static GLuint gProgram;
static GLuint gvPositionHandle;
static GLuint gameTexture;
static GLuint screencounter;

static GLuint _vertexBuffer;
static GLuint _indexBuffer;
static GLuint _depthRenderBuffer;

static GLuint _colorRenderBuffer;
static GLint _frameBuffer[2];
static GLint framebufferIndex;

static GLuint _texCoordSlot;
static GLuint _positionSlot;
static GLuint _colorSlot;
static GLuint _textureUniform;
static GLuint _projectionUniform;

typedef struct {
    float Position[3];
    float Color[4];
    float TexCoord[2];
} Vertex;

static Vertex Vertices[] = {
    {{1, -1, 0}, {1, 0, 0, 1}, {1, 0}},
    {{1, 1, 0}, {1, 0, 0, 1}, {1, -1}},
    {{-1, 1, 0}, {0, 1, 0, 1}, {0, -1}},
    {{-1, -1, 0}, {0, 1, 0, 1}, {0, 0}},
    //{{1, -1, -1}, {1, 0, 0, 1}, {1, 0}},
    //{{1, 1, -1}, {1, 0, 0, 1}, {1, 1}},
    //{{-1, 1, -1}, {0, 1, 0, 1}, {0, 1}},
    //{{-1, -1, -1}, {0, 1, 0, 1}, {0, 0}}
};
 
static const GLfloat identityMatrix[] = { 
	1.0f, 0.0f, 0.0f, 0.0f,
        0.0f, 1.0f, 0.0f, 0.0f,
        0.0f, 0.0f, 1.0f, 0.0f,
        0.0f, 0.0f, 0.0f, 1.0f };
        
static const GLfloat identityMatrix2[] = { 
	0.0f, 0.0f, 0.0f, 1.0f,
        0.0f, 0.0f, 1.0f, 0.0f,
        0.0f, 1.0f, 0.0f, 0.0f,
        1.0f, 0.0f, 0.0f, 0.0f };
        
 

const GLubyte Indices[] = {
     0, 1, 2,
     2, 3, 0
};

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

BOOL resize_gl2(int w, int h) {

	
	screen_width = w;
	screen_height = h;
	
	int tex_width = TEX_WIDTH;
	int tex_height = TEX_HEIGHT;
    
    	//float w_h_ratio = (float) screen_width / (float) screen_height ; // specifically for vertices
	float local_mult = 2.0f;
	float depth = 0.0f;
	
	
	Vertices[0].Position[0] = 0.5f * local_mult;
	Vertices[0].Position[1] = - 0.5f * local_mult;
	Vertices[0].Position[2] = depth; // Bottom Right **
	
	Vertices[0].TexCoord[0] = 1;
	Vertices[0].TexCoord[1] = - 0.25;
	
	Vertices[1].Position[0] = 0.5f * local_mult;
	Vertices[1].Position[1] = 0.5f * local_mult;
	Vertices[1].Position[2] = depth; // Top Right
	
	Vertices[1].TexCoord[0] = 1;
	Vertices[1].TexCoord[1] = -1;
	
	Vertices[2].Position[0] = -0.5f * local_mult;
	Vertices[2].Position[1] = 0.5f * local_mult;
	Vertices[2].Position[2] = depth; // Top Left
	
	Vertices[2].TexCoord[0] = 0;
	Vertices[2].TexCoord[1] = -1;
	
	Vertices[3].Position[0] = -0.5f * local_mult;
	Vertices[3].Position[1] =  -0.5f * local_mult;
	Vertices[3].Position[2] = depth; // Bottom Left
	
	Vertices[3].TexCoord[0] = 0;
	Vertices[3].TexCoord[1] = - 0.25;
	
	//GLuint gameTexture;
	glGenTextures(1, &gameTexture);
	glBindTexture(GL_TEXTURE_2D, gameTexture);
	
	//
	glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER,
		GL_NEAREST);
	glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER,
		GL_NEAREST);

	glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S,
		GL_CLAMP_TO_EDGE);
	glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T,
		GL_REPEAT);
		
	glTexImage2D(GL_TEXTURE_2D, 0, 
	        GL_RGBA,//
	        tex_width, tex_height, 
	        0, 
	        GL_RGBA,//
	        GL_UNSIGNED_SHORT_4_4_4_4,//
	        0);//screen);//
    
	//glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, gameTexture, 0);
	
	glGenBuffers(1, &_vertexBuffer);
    	glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    	glBufferData(GL_ARRAY_BUFFER, sizeof(Vertices) , Vertices, GL_STATIC_DRAW);
 
    	glGenBuffers(1, &_indexBuffer);
    	glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
    	glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(Indices), Indices, GL_STATIC_DRAW);
	
	glGenRenderbuffers(1, &_depthRenderBuffer);
	glBindRenderbuffer( GL_RENDERBUFFER, _depthRenderBuffer);
	glRenderbufferStorage( GL_RENDERBUFFER, 
		GL_RGBA4, //GL_RGBA4
		w, h);//GL_DEPTH_COMPONENT16
	checkGlError("glRenderbufferStorage");
	
	glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer[0]);
	
	glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, _depthRenderBuffer);
	
	glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, gameTexture, 0);
	//glFramebufferTexture(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, gameTexture, 0);
	//GLenum DrawBuffers[2] = {GL_COLOR_ATTACHMENT0};
	//glDrawBuffer( DrawBuffers[0]);
	
	GLenum status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
    	LOGE("status %d", status);
	
    	printGLString("Version", GL_VERSION);
    	printGLString("Vendor", GL_VENDOR);
    	printGLString("Renderer", GL_RENDERER);
    	printGLString("Extensions", GL_EXTENSIONS);

    
    	gProgram = createProgram(gVertexShader, gFragmentShader);
   
    
	_projectionUniform = glGetUniformLocation(gProgram, "Projection");

	_positionSlot = glGetAttribLocation(gProgram, "Position");
	_colorSlot = glGetAttribLocation(gProgram, "SourceColor");
	_texCoordSlot = glGetAttribLocation(gProgram, "TexCoordIn");
	_textureUniform = glGetUniformLocation(gProgram, "Texture");
	glEnableVertexAttribArray(_texCoordSlot);
	glEnableVertexAttribArray(_positionSlot);
	glEnableVertexAttribArray(_colorSlot);
	
	glUniformMatrix4fv(_projectionUniform, 1, 0, identityMatrix2);
	
    	gvPositionHandle = glGetAttribLocation(gProgram, "vPosition");

    	
    	
    return TRUE;
}



void draw_gl2() {

	GLint local_index = (screencounter + 1) %2;


	glBindFramebuffer(GL_FRAMEBUFFER, 0);
	//glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer[local_index]);
	//glPushAttrib (GL_VIEWPORT);
	checkGlError("glBindFramebuffer");
	
    	static float grey;
    	grey += 0.01f;
    	if (grey > 1.0f) {
        	grey = 0.0f;
    	}
    
    	int w = screen_width;
    	int h = screen_height;

	glViewport(0, 0, w, h);	
	
	int tex_width = TEX_WIDTH;
	int tex_height = TEX_HEIGHT;
    
	
	
	glTexImage2D(GL_TEXTURE_2D, 0, 
	        GL_RGBA,//
	        tex_width, tex_height, 
	        0, 
	        GL_RGBA,//
	        GL_UNSIGNED_SHORT_4_4_4_4,//
	        screen);//screen
    
    	
    	
    	glClearColor(grey, grey, grey, 1.0f);
    	checkGlError("glClearColor");
    	glClear( GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    	glEnable( GL_DEPTH_TEST);
    	checkGlError("glClear");
    	glDepthFunc(GL_LEQUAL);
    	
	glUseProgram(gProgram);
    	checkGlError("glUseProgram");
    	
	glVertexAttribPointer(_positionSlot, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), 0);
	glVertexAttribPointer(_colorSlot, 4, GL_FLOAT, GL_FALSE, sizeof(Vertex), (GLvoid*) (sizeof(float) * 3));
	glVertexAttribPointer(_texCoordSlot, 2, GL_FLOAT, GL_FALSE, sizeof(Vertex), (GLvoid*) (sizeof(float) * 7 ));
	
	glActiveTexture(GL_TEXTURE0);
	glBindTexture( GL_TEXTURE_2D, gameTexture);
	glUniform1i(_textureUniform, 0);
	
	glDrawElements(GL_TRIANGLES, 
		sizeof(Indices)/ sizeof (Indices[0]), 
		GL_UNSIGNED_BYTE, 0);
	
	//glPopAttrib();
	//glBindFramebuffer(GL_FRAMEBUFFER, 0);
}

/**
 * Opengles 2.0 initialize function.
 */
void init_gl2(void) {
	glGenRenderbuffers(1, &_colorRenderBuffer);
	glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderBuffer);
	
	//GLuint framebuffer;
	//glGenFramebuffers(1, &framebuffer);
	glGenFramebuffers(2, _frameBuffer);
	glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer[0]);
	glFramebufferRenderbuffer(GL_FRAMEBUFFER, 
		GL_COLOR_ATTACHMENT0, 
		GL_RENDERBUFFER, 
		_colorRenderBuffer);
}


/**
 *	initialize opengles 1.0
 */

void init(void)
{

}

/**
 *	Set screen size for opengles 1.0
 */
void resize(int w, int h) {


}

/**
 *	Opengles 1.0 specific draw function.
 */
void draw() {


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
	else {
		init_gl2();
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
	LOGE("use_gl2 %d", use_gl2);
	////////////////////////
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
	screencounter ++;
	
	//glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer[0]);
	framebufferIndex = screencounter % 2;
	glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer[framebufferIndex]);
	//glDrawBuffer(GL_BACK);
	if (framebufferIndex == 1) {
		//glDrawBuffer(GL_BACK);
		//glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer[1]);
	}
	else {
		//glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer[0]);
	}
	
}
