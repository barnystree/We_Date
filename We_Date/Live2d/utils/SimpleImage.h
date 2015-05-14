

#import <Foundation/Foundation.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>

@interface SimpleImage : NSObject
{
@private
	float imageLeft;
	float imageRight;
	float imageTop;
	float imageBottom;
    
	float uvLeft;
	float uvRight;
	float uvTop;
	float uvBottom;
    
	GLuint texture;
}

- (id)initWithPath:(NSString*) path ;
- (void) draw ;
- (void) deleteTexture;
- (void) setDrawRect:(float)left :(float)right :(float)bottom :(float)top;
- (void) setUVRect:(float) left :(float) right :(float) bottom :(float) top;

@end
