
#pragma once

#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <AVFoundation/AVFoundation.h>
#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AudioToolbox/AudioFile.h>

#import "util/UtSystem.h"

@class SimpleImage;
class LAppLive2DManager;

@interface LAppRenderer : NSObject
{
@private
	int renderInitFlg ;
    
	LAppLive2DManager * delegate ;
	EAGLContext *context;
	
	// The pixel dimensions of the CAEAGLLayer
	GLint viewportWidth;
	GLint viewportHeight;
	
	// The OpenGL names for the framebuffer and renderbuffer used to render to this view
	GLuint defaultFramebuffer, colorRenderbuffer;
	
	
    SimpleImage* bg;
	
	
	float accelX;
	float accelY;
}
- (id) init;
- (void) renderInit;
- (void) render;
- (BOOL) resizeFromLayer:(CAEAGLLayer *)layer;


- (void) setDelegate:(LAppLive2DManager *) del ;


- (void) setContextCurrent ;

- (void) setupBackground;
- (void) setAccel:(float)x :(float)y;
@end




