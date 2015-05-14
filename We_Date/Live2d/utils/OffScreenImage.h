

#import <Foundation/Foundation.h>

@interface OffscreenImage : NSObject

+(void)createFrameBuffer:(float)w :(float)h :(GLuint)fbo;
+(void)releaseFrameBuffer;
+(void)setOffscreen;
+(void)setOnscreen;
+(void) drawDisplay: (float) opacity;
@end
