
#import "LAppView.h"

//Live2D Application
#include "LAppLive2DManager.h"
#include "LAppRenderer.h"
#include "LAppDefine.h"

@implementation LAppView

@synthesize animating;
@dynamic animationFrameInterval;

#define INTERVAL_SEC (1.0 / 30 )

using namespace live2d::framework;

//==================================================
// You must implement this method
//==================================================
+ (Class) layerClass
{
    return [CAEAGLLayer class];
}


//- (id)initWithFrame:(CGRect)frame
- (id)initWithFrame:(CGRect)frame withModels:(NSArray*)arr
{
    if ((self = [super initWithFrame:frame]))
	{
        
        modelArray = [NSArray arrayWithArray:arr];

        // Get the layer
        CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
		
		if(LAppDefine::DEBUG_LOG)NSLog(@"OpenGL scale:%f",[UIScreen mainScreen].scale);
		self.contentScaleFactor = [UIScreen mainScreen].scale ;
		
		eaglLayer.opaque = TRUE;
        eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithBool:FALSE], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
		
        renderer = [[LAppRenderer alloc] init];
        if (!renderer)
        {
            return nil;
        }
        [renderer resizeFromLayer:(CAEAGLLayer*)self.layer];
        
		animating = FALSE;
		animationFrameInterval = 1;
		animationTimer = nil;
        
		self.multipleTouchEnabled = true ;
        
        
        touchMgr=new TouchManager();
        
        
        deviceToScreen=new L2DMatrix44();
        
        
        viewMatrix=new L2DViewMatrix();
        
        
        accelHelper = [[AccelHelper alloc]init] ;
		
		float width=frame.size.width;
		float height=frame.size.height;
		float ratio=(float)height/width;
		float left = VIEW_LOGICAL_LEFT;
		float right = VIEW_LOGICAL_RIGHT;
		float bottom = -ratio;
		float top = ratio;
		
		viewMatrix->setScreenRect(left,right,bottom,top);

		
		float screenW=abs(left-right);
		deviceToScreen->multTranslate(-width/2.0f,-height/2.0f );
		deviceToScreen->multScale( screenW/width , -screenW/width );
        
        
        viewMatrix->setMaxScale( VIEW_MAX_SCALE );
        viewMatrix->setMinScale( VIEW_MIN_SCALE );
        
        
        viewMatrix->setMaxScreenRect(
			VIEW_LOGICAL_MAX_LEFT,
             VIEW_LOGICAL_MAX_RIGHT,
             VIEW_LOGICAL_MAX_BOTTOM,
             VIEW_LOGICAL_MAX_TOP
		    );
        //背景透明！！！
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}


- (void)dealloc
{
	delegate=nil;
	accelHelper=nil;
	animationTimer=nil;
	renderer=nil;
    delete touchMgr;
	delete deviceToScreen;
	delete viewMatrix;
}


- (void) setDelegate:(LAppLive2DManager *)del
{
    delegate=del;
	[renderer setDelegate:delegate] ;
}


- (void) startAnimation
{
	if (!animating)
	{
        if (LAppDefine::DEBUG_LOG) NSLog(@"startAnimation");
        
        animationTimer = [NSTimer scheduledTimerWithTimeInterval:(NSTimeInterval)(INTERVAL_SEC * animationFrameInterval)
                                                          target:self
                                                        selector:@selector(drawView:)
                                                        userInfo:nil repeats:TRUE];
        
        [[NSRunLoop currentRunLoop] addTimer:animationTimer forMode:NSRunLoopCommonModes];
		
		animating = TRUE;
	}
}


- (void)stopAnimation
{
	if (animating)
	{
        if (LAppDefine::DEBUG_LOG) NSLog(@"stopAnimation");
        
        [animationTimer invalidate];
        animationTimer = nil;
		
		animating = FALSE;
	}
}


//==================================================
//	DRAW
//==================================================
- (void) drawView:(id)sender
{
	
	    [accelHelper update];
	
	if( [accelHelper getShake] > 0.8f )
	{
		if(LAppDefine::DEBUG_LOG)NSLog(@"shake event");
		
		delegate->shakeEvent() ;
		[accelHelper resetShake] ;
	}
	
    
    delegate->setAccel([accelHelper getAccelX], [accelHelper getAccelY], [accelHelper getAccelZ]);
	
	
	delegate->update(modelArray);
    [renderer render];
}



- (void) setContextCurrent
{
    [renderer setContextCurrent];
}


- (void) layoutSubviews
{
	[renderer resizeFromLayer:(CAEAGLLayer*)self.layer];
    [self drawView:nil];
}


- (NSInteger) animationFrameInterval
{
	return animationFrameInterval;
}


- (void) setAnimationFrameInterval:(NSInteger)frameInterval
{
	// Frame interval defines how many display frames must pass between each time the
	// display link fires. The display link will only fire 30 times a second when the
	// frame internal is two on a display that refreshes 60 times a second. The default
	// frame interval setting of one will fire 60 times a second when the display refreshes
	// at 60 times a second. A frame interval setting of less than one results in undefined
	// behavior.
	if (frameInterval >= 1)
	{
		animationFrameInterval = frameInterval;
		
		if (animating)
		{
			[self stopAnimation];
			[self startAnimation];
		}
	}
}

// 临时去掉 和滑动冲突
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    int touchNum = 0 ;
	UITouch * touch_ary[8] ;
	
	for( UITouch * p in touches )
	{
		touch_ary[touchNum] = p ;
		++touchNum ;		
	}
	
	if( touchNum == 1 )
	{
		CGPoint pt = [ touch_ary[0] locationInView:self];
        if(LAppDefine::DEBUG_TOUCH_LOG)NSLog( @"touchesBegan x:%.0f y:%.0f",pt.x,pt.y);
        touchMgr->touchesBegan(pt.x,pt.y);
        [self.nextResponder touchesBegan:touches withEvent:event];
        
	}
	else if( touchNum >= 2 )
	{
		CGPoint pt1 = [ touch_ary[0] locationInView:self];
		CGPoint pt2 = [ touch_ary[1] locationInView:self];
		if(LAppDefine::DEBUG_TOUCH_LOG)NSLog( @"touchesBegan x1:%.0f y1:%.0f x2:%.0f y2:%.0f",pt1.x,pt1.y,pt2.x,pt2.y);
        touchMgr->touchesBegan(pt1.x,pt1.y,pt2.x,pt2.y);
        
	}
}


-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	int touchNum = 0 ;
	UITouch * touch_ary[8] ;
    
	for( UITouch * p in touches )
	{
		touch_ary[touchNum] = p ;
		
		++touchNum ;		
	}
	
	float screenX=[self transformScreenX:touchMgr->getX()];
	float screenY=[self transformScreenY:touchMgr->getY()];
	float viewX=[self transformViewX:touchMgr->getX()];
	float viewY=[self transformViewY:touchMgr->getY()];
	
	if( touchNum == 1 )
	{
		CGPoint pt = [ touch_ary[0] locationInView:self];
		
		if(LAppDefine::DEBUG_TOUCH_LOG)NSLog( @"touchesMoved device{x:%.0f y:%.0f} screen{x:%.2f y:%.2f} view{x:%.2f y:%.2f}",pt.x,pt.y,screenX,screenY,viewX,viewY);
        touchMgr->touchesMoved(pt.x,pt.y);
		
		const int FLICK_DISTANCE=100;
		
		
		if(touchMgr->isSingleTouch() && touchMgr->isFlickAvailable() )
		{
			
			float flickDist=touchMgr->getFlickDistance();
			if(flickDist>FLICK_DISTANCE)
			{
				float startX=[self transformViewX:touchMgr->getStartX()];
				float startY=[self transformViewY:touchMgr->getStartY()];
				delegate->flickEvent(startX,startY);
				touchMgr->disableFlick();
			}
		}
        
	}
	else if( touchNum >= 2 )
	{
		
        CGPoint touchPoints[touchNum];
        
        for (int i=0; i<touchNum; i++)
		{
            touchPoints[i]=[ touch_ary[i] locationInView:self];
        }
        
        touchMgr->touchesMoved(touchPoints , touchNum);
        
        
        float dx= touchMgr->getDeltaX() * deviceToScreen->getScaleX();
        float dy= touchMgr->getDeltaY() * deviceToScreen->getScaleY() ;
        float cx= deviceToScreen->transformX( touchMgr->getCenterX() ) * touchMgr->getScale();
        float cy= deviceToScreen->transformY( touchMgr->getCenterY() ) * touchMgr->getScale();
        float scale=touchMgr->getScale();
        
        if(LAppDefine::DEBUG_TOUCH_LOG)NSLog( @"touchesMoved  dx:%.2f dy:%.2f cx:%.2f cy:%.2f scale:%.2f",dx,dy,cx,cy,scale);
        
		//[self updateViewMatrix:dx :dy :cx :cy :scale];
        
	}
	delegate->setDrag(viewX,viewY);
}


-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(LAppDefine::DEBUG_TOUCH_LOG)NSLog( @"touchesEnded");
    delegate->setDrag(0,0);
    UITouch* touch = [touches anyObject];
    if( [touch tapCount] == 1 )
    {
        
        float x = deviceToScreen->transformX( touchMgr->getX() );
        float y = deviceToScreen->transformY( touchMgr->getY() );
        if (LAppDefine::DEBUG_LOG) NSLog( @"touchesBegan x:%.2f y:%.2f",x,y);
        delegate->tapEvent( x, y ) ;
    }
}

-(void) updateViewMatrix:(float) dx :(float) dy :(float) cx :(float) cy :(float) scale
{
	bool isMaxScale=viewMatrix->isMaxScale();
	bool isMinScale=viewMatrix->isMinScale();
	
	
	viewMatrix->adjustScale(cx, cy, scale);
	
	
	viewMatrix->adjustTranslate(dx, dy) ;
	
	
	if( ! isMaxScale)
	{
		if(viewMatrix->isMaxScale())
		{
			delegate->maxScaleEvent();
		}
	}
	
	if( ! isMinScale)
	{
		if(viewMatrix->isMinScale())
		{
			delegate->minScaleEvent();
		}
	}
	
}


-(L2DViewMatrix*)getViewMatrix
{
	return viewMatrix;
}


-(float) transformViewX:(float) deviceX
{
	float screenX = deviceToScreen->transformX( deviceX );
	return  viewMatrix->invertTransformX(screenX);
}


-(float) transformViewY:(float) deviceY
{
	float screenY = deviceToScreen->transformY( deviceY );
	return  viewMatrix->invertTransformY(screenY);
}


-(float) transformScreenX:(float) deviceX
{
	return  deviceToScreen->transformX( deviceX );
}


-(float) transformScreenY:(float) deviceY
{
	return  deviceToScreen->transformY( deviceY );
}


@end
