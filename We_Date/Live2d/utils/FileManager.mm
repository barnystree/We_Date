

#import "FileManager.h"
@implementation FileManager

const bool DEBUG_LOG=false;



+ (const char*) pathForResource:(const char*)fileName 
{
	NSString* path=[[NSBundle mainBundle] pathForAuxiliaryExecutable:[NSString stringWithCString:fileName encoding:NSUTF8StringEncoding]];
    return [path cStringUsingEncoding:NSUTF8StringEncoding];
}



+ (NSURL*) getFileURLWithCString:(const char*)fileName
{
	NSString* path=[[NSBundle mainBundle] pathForAuxiliaryExecutable:[NSString stringWithCString:fileName encoding:NSUTF8StringEncoding]];
    
    if(DEBUG_LOG)NSLog(@"open :%@",path);
    	NSURL* url = [NSURL fileURLWithPath:path];
	return url;
}



+ (NSData*)openDocuments:(NSString*)fileName {
    NSString* path=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    path=[path stringByAppendingPathComponent:fileName]; 
    
    if(DEBUG_LOG)NSLog(@"open :%@",path);
    NSData* data=[[NSData alloc] initWithContentsOfFile:path] ; 
    
    if (data==nil) {
        if(DEBUG_LOG)NSLog(@"error! :%@",path);
        return nil;
    }
    return data;
}



+ (NSData*) openDocumentsWithCString:(const char*)fileName
{
    NSString* path=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    path=[path stringByAppendingPathComponent:[NSString stringWithCString:fileName encoding:NSUTF8StringEncoding]]; 
    
    if(DEBUG_LOG)NSLog(@"open :%@",path);
    NSData* data=[[NSData alloc] initWithContentsOfFile:path] ; 
    
    if (data==nil) {
        if(DEBUG_LOG)NSLog(@"error! :%@",path);
        return nil;
    }
    return data;
}



+ (NSData*)openBundle:(NSString*)fileName {
    NSString* path=[[NSBundle mainBundle] pathForAuxiliaryExecutable:fileName];
    
    if(DEBUG_LOG)NSLog(@"open :%@",path);
    NSData* data=[[NSData alloc] initWithContentsOfFile:path] ; 
    
    if (data==nil) {
        if(DEBUG_LOG)NSLog(@"error! :%@",path);
        return nil;
    }
    return data;
}



+ (NSData*) openBundleWithCString:(const char*)fileName
{
    NSString* path=[[NSBundle mainBundle] pathForAuxiliaryExecutable:[NSString stringWithCString:fileName encoding:NSUTF8StringEncoding]]; 
    
    if(DEBUG_LOG)NSLog(@"open :%@",path);
    NSData* data=[[NSData alloc] initWithContentsOfFile:path] ; 
    
    if (data==nil) {
        if(DEBUG_LOG)NSLog(@"error! :%@",path);
        return nil;
    }
    return data;
}

+ (GLuint) loadGLTexture:(NSString*) fileName
{
	GLuint texture;
	
	UIImage *uiImage = [UIImage imageNamed:fileName];
	
	if(!uiImage)
	{
		NSLog(@"Error: %@ not found",fileName);
		return 0;
	}
	
	CGImageRef image = uiImage.CGImage ;
	
	
	size_t width = CGImageGetWidth(image);
	size_t height = CGImageGetHeight(image);
	
	
	GLubyte* imageData = (GLubyte *) calloc(width * height * 4 , 1);
	CGContextRef imageContext = CGBitmapContextCreate(imageData,width,height,8,width * 4,CGImageGetColorSpace(image),kCGImageAlphaPremultipliedLast);
	CGContextDrawImage(imageContext, CGRectMake(0, 0, (CGFloat)width, (CGFloat)height), image);
	CGContextRelease(imageContext);
    
	
	glGenTextures(1, &texture);
	glBindTexture(GL_TEXTURE_2D, texture);
    
    glTexParameteri(GL_TEXTURE_2D, GL_GENERATE_MIPMAP, GL_TRUE);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, imageData);
    
	free(imageData);
	
	GLenum error = glGetError() ;
	if( error )
	{
        NSLog(@"load texture error : %d",error);
	}
	
	
	return texture;
}

@end
