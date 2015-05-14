
#include "LAppLive2DManager.h"

#include "L2DViewMatrix.h"

//Live2DApplication
#include "LAppModel.h"
#include "LAppDefine.h"
#include "LAppModel.h"
#include "L2DMotionManager.h"

#include "PlatformManager.h"
#include "Live2DFramework.h"

//utils
#import "IPhoneUtil.h"

//Objective C
#import "WDAppDelegate.h"
#import "LAppView.h"

using namespace live2d;
using namespace live2d::framework;

LAppLive2DManager::LAppLive2DManager()
	:modelCount(-1),reloadFlg(false)
{
	
	
	
	
	
	
	Live2D::init();
	Live2DFramework::setPlatformManager(new PlatformManager());
}


LAppLive2DManager::~LAppLive2DManager() 
{
	releaseModel();
	view=NULL;
	Live2D::dispose();
}


void LAppLive2DManager::releaseModel()
{
	for (int i=0; i<models.size(); i++)
	{
		delete models[i];
	}
    models.clear();
}


void LAppLive2DManager::releaseView()
{
	view=NULL;
}


//LAppView* LAppLive2DManager::createView(CGRect &rect)
//{
//    if(LAppDefine::DEBUG_LOG)NSLog(@"create view x:%.0f y:%.0f width:%.2f height:%.2f",    
//                                   rect.origin.x,rect.origin.y,rect.size.width,rect.size.height );
//	
//	releaseView();
//    view = (LAppView*)[[LAppView alloc] initWithFrame:rect];
//    [view setDelegate:this] ;
//    
//	return view ;
//}

LAppView* LAppLive2DManager::createView(CGRect &rect,NSArray *arr)
{
    if(LAppDefine::DEBUG_LOG)NSLog(@"create view x:%.0f y:%.0f width:%.2f height:%.2f",
                                   rect.origin.x,rect.origin.y,rect.size.width,rect.size.height );
    
    releaseView();
    view = (LAppView*)[[LAppView alloc] initWithFrame:rect withModels:arr];
    [view setDelegate:this] ;
    return view ;
}

/*
void LAppLive2DManager::update()
{
    if(reloadFlg)
	{
		
		reloadFlg=false;
		int no = modelCount % 4;
				
		switch (no)
		{
			case 0:
				releaseModel();
				models.push_back(new LAppModel());
				models[0]->load( MODEL_HARU) ;
				models[0]->feedIn();
				break;
			case 1:
				releaseModel();
				models.push_back(new LAppModel());
				models[0]->load( MODEL_SHIZUKU) ;
				models[0]->feedIn();
				break;
			case 2:
				releaseModel();
				models.push_back(new LAppModel());
				models[0]->load( MODEL_WANKO) ;
				models[0]->feedIn();
				break;
			case 3:
				releaseModel();
				models.push_back(new LAppModel());
				models[0]->load( MODEL_HARU_A) ;
				models[0]->feedIn();
				
				models.push_back(new LAppModel());
				models[1]->load( MODEL_HARU_B) ;
				models[1]->feedIn();
				break;
				
				//break;
			default:
				
				break;
		}
	}
}
*/

void LAppLive2DManager::update(NSArray *arr)
{
    
    if(reloadFlg)
    {
        reloadFlg=false;
        int no = modelCount % [arr count];
        /////
        NSArray *array = [NSArray arrayWithArray:arr[no]];
        
        releaseModel();
        
        for (int i = 0; i < [array count]; i++) {
            
            const char *MODEL_FILE = [array[i] UTF8String];
            
            models.push_back(new LAppModel());
            models[i]->load( MODEL_FILE) ;
            models[i]->feedIn();
        }
    }
    
    
}

bool LAppLive2DManager::changeModel(int n)
{
	reloadFlg=true;
	modelCount++;
	return true;
}

//执行指定动作
bool LAppLive2DManager::motion(const char group[],int n, int m)
{
    models[m]->startMotion(group, n-1, PRIORITY_NORMAL);
    
    return true;
}
//执行指定表情
void LAppLive2DManager::startExpress(int n,int m){
    models[m] -> startExpression(n);
}

bool LAppLive2DManager::tapEvent(float x,float y)
{
    if(LAppDefine::DEBUG_LOG)NSLog( @"tapEvent");
	
	for (int i=0; i<models.size(); i++)
	{
		if(models[i]->hitTest(  HIT_AREA_HEAD,x, y ))
		{
			
			if(LAppDefine::DEBUG_LOG)NSLog( @"tap face");
			models[i]->setRandomExpression();
		}
		else if(models[i]->hitTest( HIT_AREA_BODY,x, y))
		{
			if(LAppDefine::DEBUG_LOG)NSLog( @"tap body");
			models[i]->startRandomMotion(MOTION_GROUP_TAP_BODY, PRIORITY_NORMAL );
		}
	}
    return true;
}



void LAppLive2DManager::flickEvent( float x, float y )
{
    if(LAppDefine::DEBUG_LOG)NSLog( @"flick x:%f y:%f",x,y);
    
    for (int i=0; i<models.size(); i++)
	{
		if(models[i]->hitTest( HIT_AREA_HEAD, x, y ))
		{
			if(LAppDefine::DEBUG_LOG)NSLog( @"flick head");
			models[i]->startRandomMotion(MOTION_GROUP_FLICK_HEAD, PRIORITY_NORMAL );
		}
	}
}


void LAppLive2DManager::maxScaleEvent()
{
    if(LAppDefine::DEBUG_LOG)NSLog( @"max scale event");
	for (int i=0; i<models.size(); i++)
	{
		models[i]->startRandomMotion(MOTION_GROUP_PINCH_IN,PRIORITY_NORMAL );
	}
}


void LAppLive2DManager::minScaleEvent()
{
    if(LAppDefine::DEBUG_LOG)NSLog( @"min scale event");
	for (int i=0; i<models.size(); i++)
	{
		models[i]->startRandomMotion(MOTION_GROUP_PINCH_OUT,PRIORITY_NORMAL );
	}
}



void LAppLive2DManager::shakeEvent()
{
    if(LAppDefine::DEBUG_LOG)NSLog( @"shake event");
	for (int i=0; i<models.size(); i++)
	{
		models[i]->startRandomMotion(MOTION_GROUP_SHAKE,PRIORITY_FORCE );
	}
}



void LAppLive2DManager::onResume()
{
    if(view!=NULL)[view startAnimation];
}



void LAppLive2DManager::onPause()
{
    if(view!=NULL)[view stopAnimation];
}



void LAppLive2DManager::setDrag(float x, float y)
{
	for (int i=0; i<models.size(); i++)
	{
		models[i]->setDrag(x, y);
	}
}


void LAppLive2DManager::setAccel(float x, float y, float z)
{
    for (int i=0; i<models.size(); i++)
	{
		models[i]->setAccel(x, y,z);
	}
}


L2DViewMatrix* LAppLive2DManager::getViewMatrix()
{
	return [view getViewMatrix];
}


