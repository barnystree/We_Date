
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import "OffscreenImage.h"
#import "FileManager.h"

@implementation OffscreenImage

static GLuint offscreenTexture;
static GLuint offscreenFrameBuffer;
static float viewportWidth;
static float viewportHeight;
static GLuint defaultFrameBuffer;
static const float size=512;

+(void)createFrameBuffer:(float)w :(float)h :(GLuint)fbo
{
	viewportWidth=w;
	viewportHeight=h;
	defaultFrameBuffer=fbo;
	
	
	glGenTextures(1, &offscreenTexture);
	glBindTexture(GL_TEXTURE_2D, offscreenTexture);
    
	glTexParameteri(GL_TEXTURE_2D, GL_GENERATE_MIPMAP, GL_TRUE);
	glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
	glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, size, size, 0, GL_RGBA, GL_UNSIGNED_BYTE, 0);

	
	glGenFramebuffersOES(1, &offscreenFrameBuffer);
	glBindFramebufferOES(GL_FRAMEBUFFER_OES, offscreenFrameBuffer);
	glFramebufferTexture2DOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_TEXTURE_2D, offscreenTexture, 0);
	glBindTexture(GL_TEXTURE_2D, 0);

	
    if (glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES) != GL_FRAMEBUFFER_COMPLETE_OES) {
        NSLog(@"Failed to create FBO file : %x", glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES));
    }
	glBindFramebufferOES(GL_FRAMEBUFFER_OES, defaultFrameBuffer);
}


+(void)releaseFrameBuffer
{
	glDeleteTextures(1, &offscreenTexture);
}


+(void)setOffscreen
{
	glBindFramebufferOES(GL_FRAMEBUFFER_OES, offscreenFrameBuffer);
	glViewport(0, 0, size, size);
}


+(void)setOnscreen
{
	glBindFramebufferOES(GL_FRAMEBUFFER_OES, defaultFrameBuffer);
	glViewport(0, 0, viewportWidth, viewportHeight);
}



+(void) drawDisplay: (float) opacity
{
	float uv[] = { 0 ,1,1  ,1, 1, 0, 0,0} ;
	float ratio=viewportHeight/viewportWidth;
    float vertex[] = {
		-1 , ratio ,
		1  , ratio ,
		1  , -ratio,
		-1 , -ratio } ;

    short index[] = {0,1,2 , 0,2,3} ;
	
	glEnable( GL_TEXTURE_2D ) ;
	glEnable( GL_BLEND);
	
	glBlendFunc(GL_ONE , GL_ONE_MINUS_SRC_ALPHA );//
	
	glColor4f( opacity , opacity, opacity, opacity  ) ;
	

	glBindTexture(GL_TEXTURE_2D , offscreenTexture ) ;
	
	glEnableClientState(GL_TEXTURE_COORD_ARRAY) ;
	glEnableClientState(GL_VERTEX_ARRAY) ;
	
	
	glTexCoordPointer( 2, GL_FLOAT , 0 , uv ) ;
	
	
	glVertexPointer( 2 , GL_FLOAT , 0 , vertex ) ;
	
	glDrawElements( GL_TRIANGLES, 6 , GL_UNSIGNED_SHORT , index ) ;
	
}

@end
