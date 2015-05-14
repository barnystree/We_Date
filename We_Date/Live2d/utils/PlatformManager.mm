/**
 *  You can modify and use this source freely
 *  only for the development of application related Live2D.
 *
 *  (c) Live2D Inc. All rights reserved.
 */
#include "PlatformManager.h"
#include "FileManager.h"

#include "Live2DModelIPhone.h"
#include "LAppTextureDesc.h"

using namespace live2d;
using namespace live2d::framework;

PlatformManager::PlatformManager(void)
{
}


PlatformManager::~PlatformManager(void)
{
}


unsigned char* PlatformManager::loadBytes(const char* path,size_t* size)
{
	NSString* _path=[NSString stringWithFormat:@"%s",path];
	NSData* data=[FileManager openBundle:_path];
	
	*size=[data length];
	unsigned char* buf = (unsigned char*)[data bytes];
	return buf;
}

ALive2DModel* PlatformManager::loadLive2DModel(const char* path)
{
	size_t size;
	unsigned char* buf = loadBytes(path,&size);
	
	//Create Live2D Model Instance
	ALive2DModel* live2DModel = Live2DModelIPhone::loadModel(buf,(int)size);
    return live2DModel;
}

L2DTextureDesc* PlatformManager::loadTexture(ALive2DModel* model, int no, const char* path)
{
	GLuint glTexNo = [FileManager loadGLTexture: [NSString stringWithCString:path encoding:NSUTF8StringEncoding] ];
	((Live2DModelIPhone*)model)->setTexture( no , glTexNo ) ;
	
	LAppTextureDesc* desc=new LAppTextureDesc(glTexNo);
	
	return desc;
}

void PlatformManager::log(const char* txt)
{
	NSLog([NSString stringWithCString:txt encoding:NSUTF8StringEncoding]);
}