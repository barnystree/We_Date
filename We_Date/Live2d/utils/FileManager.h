

#import <Foundation/Foundation.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>

@interface FileManager : NSObject

+ (NSData*) openBundle:(NSString*)fileName;
+ (NSData*) openBundleWithCString:(const char*)fileName;
+ (NSData*) openDocuments:(NSString*)fileName;
+ (NSData*) openDocumentsWithCString:(const char*)fileName;

+ (const char*) pathForResource:(const char*)fileName;
+ (NSURL*) getFileURLWithCString:(const char*)fileName;
+ (GLuint)loadGLTexture:(NSString*)fileName;
@end
