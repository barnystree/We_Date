
#import <mach/mach_time.h>

#import "LAppRenderer.h"
#import "LAppDefine.h"
#import "LAppModel.h"
#import "LAppLive2DManager.h"

#import "L2DViewMatrix.h"
#import "L2DModelMatrix.h"

//utils
#import "SimpleImage.h"
#import "OffscreenImage.h"

@implementation LAppRenderer

using namespace live2d::framework;


//==================================================
// Init
//==================================================
// Create an ES 1.1 context
- (id) init
{
	if (self = [super init])
	{
		context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
        
        if (!context || ![EAGLContext setCurrentContext:context])
		{
            return nil;
        }
		
		// Create default framebuffer object. The backing will be allocated for the current layer in -resizeFromLayer
		glGenFramebuffersOES(1, &defaultFramebuffer);
		glGenRenderbuffersOES(1, &colorRenderbuffer);
		glBindFramebufferOES(GL_FRAMEBUFFER_OES, defaultFramebuffer);
		glBindRenderbufferOES(GL_RENDERBUFFER_OES, colorRenderbuffer);
		glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, colorRenderbuffer);
				
        //[self setupBackground];
		accelX=0;
		accelY=0;
	}
    
	return self;
}


- (void) dealloc
{
	[OffscreenImage releaseFrameBuffer];
	[bg deleteTexture];
	
	// Tear down GL
	if (defaultFramebuffer)
	{
		glDeleteFramebuffersOES(1, &defaultFramebuffer);
		defaultFramebuffer = 0;
	}
	
	if (colorRenderbuffer)
	{
		glDeleteRenderbuffersOES(1, &colorRenderbuffer);
		colorRenderbuffer = 0;
	}
	
	// Tear down context
	if ([EAGLContext currentContext] == context)
        [EAGLContext setCurrentContext:nil];
	
	
	context = nil;
	delegate=nil;
}


-(void)renderInit
{
	
	glBindFramebufferOES(GL_FRAMEBUFFER_OES, defaultFramebuffer);
	
	if(LAppDefine::DEBUG_LOG)NSLog(@"viewport w:%d h:%d",viewportWidth, viewportHeight);
	
	glViewport(0, 0, viewportWidth, viewportHeight);
	
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
	
	
	
	
	L2DViewMatrix* viewMatrix=delegate->getViewMatrix();
	glOrthof( viewMatrix->getScreenLeft()
			 , viewMatrix->getScreenRight(), viewMatrix->getScreenBottom(), viewMatrix->getScreenTop(), 0.5f, -0.5f);
	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();
	
	glClearColor(0.0f, 0.0f, 0.0f, 0.0f);
	
	[OffscreenImage createFrameBuffer:viewportWidth: viewportHeight :defaultFramebuffer];
}


//==================================================
// Render
//==================================================
- (void) render
{
	
    if( viewportWidth <= 0 || viewportHeight <= 0 )return;
	
	[EAGLContext setCurrentContext:context];
	
	if( renderInitFlg )
	{
		[self renderInit];
		renderInitFlg=false;
	}
	
	
	glClear(GL_COLOR_BUFFER_BIT);
  
    
    glDisable(GL_DEPTH_TEST) ;
    glDisable(GL_CULL_FACE) ;
    glEnable(GL_BLEND);
    glBlendFunc(GL_ONE , GL_ONE_MINUS_SRC_ALPHA );
    
    glEnable( GL_TEXTURE_2D ) ;
    glEnableClientState(GL_TEXTURE_COORD_ARRAY) ;
    glEnableClientState(GL_VERTEX_ARRAY) ;
    
    
    glTexParameteri(GL_TEXTURE_2D , GL_TEXTURE_WRAP_S , GL_CLAMP_TO_EDGE);
	glTexParameteri(GL_TEXTURE_2D , GL_TEXTURE_WRAP_T , GL_CLAMP_TO_EDGE);
		
    glColor4f( 1 , 1, 1, 1  ) ;
    
    
	glMatrixMode(GL_MODELVIEW) ;
    glLoadIdentity() ;
	
    glPushMatrix() ;
    {
        
		L2DViewMatrix* viewMatrix=delegate->getViewMatrix();
        glMultMatrixf(viewMatrix->getArray()) ;
		
        
        if(bg!=NULL){
            glPushMatrix() ;
            {
				float SCALE_X = 0.25f ;
				float SCALE_Y = 0.1f ;
                glTranslatef( -SCALE_X  * accelX , SCALE_Y * accelY , 0 ) ;
                
                [bg draw];
            }
            glPopMatrix() ;
        }
		
		
		for (int i=0; i<delegate->getModelNum(); i++) {
			LAppModel* model=delegate->getModel(i);
			if (model->isInitialized() && ! model->isUpdating() ) {
				model->update();
				model->draw();
			}
		}
	}
    glPopMatrix() ;
    
	
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, colorRenderbuffer);
    [context presentRenderbuffer:GL_RENDERBUFFER_OES];
}


//==================================================
//	resizeFromLayer
//==================================================
- (BOOL) resizeFromLayer:(CAEAGLLayer *)layer
{	
	// Allocate color buffer backing based on the current layer size
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, colorRenderbuffer);
    [context renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:layer];
	glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &viewportWidth);
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &viewportHeight);
	
    if (glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES) != GL_FRAMEBUFFER_COMPLETE_OES)
	{
		NSLog(@"Failed to make complete framebuffer object %x", glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES));
        return NO;
    }
    
	renderInitFlg = true ;
    return YES;
}


//==================================================

//==================================================
- (void) setDelegate:( LAppLive2DManager * ) del
{
	delegate = del ;
}



- (void) setContextCurrent
{
    [EAGLContext setCurrentContext:context];
}



- (void) setupBackground
{
    
    NSString* path=[NSString stringWithCString:BACK_IMAGE_NAME encoding:NSUTF8StringEncoding ] ;
    
    
    if(LAppDefine::DEBUG_LOG)NSLog( @"background : %@",path);
    
    bg= [[SimpleImage alloc]initWithPath:path];
    
    
    [bg setDrawRect:
		VIEW_LOGICAL_MAX_LEFT:VIEW_LOGICAL_MAX_RIGHT:VIEW_LOGICAL_MAX_BOTTOM:VIEW_LOGICAL_MAX_TOP];
}


-(void)setAccel:(float)x :(float)y
{
	accelX=x;
	accelY=y;
}

@end
