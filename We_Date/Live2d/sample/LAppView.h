
#pragma once
//ObjectiveC
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

//Live2D lib
#import "util/UtDebug.h"

//utils
#import "IPhoneUtil.h"
#import "TouchManager.h"
#import "AccelHelper.h"

//Live2D framework
#import "L2DMatrix44.h"
#import "L2DTargetPoint.h"
#import "L2DViewMatrix.h"

@class LAppRenderer;
class LAppLive2DManager;


@interface LAppView : UIView
{    
@public
	LAppRenderer* renderer;
    NSArray* modelArray;
@private
	BOOL animating;
	NSInteger animationFrameInterval;
    NSTimer *animationTimer;
	LAppLive2DManager * delegate ;
    
    AccelHelper* accelHelper;
	TouchManager* touchMgr;
	live2d::framework::L2DMatrix44* deviceToScreen;
    live2d::framework::L2DViewMatrix* viewMatrix;
}

@property (readonly, nonatomic, getter=isAnimating) BOOL animating;
@property (nonatomic) NSInteger animationFrameInterval;

- (id)initWithFrame:(CGRect)frame withModels:(NSArray*)arr;


- (void) startAnimation;
- (void) stopAnimation;
- (void) drawView:(id)sender;
- (void) setDelegate:( LAppLive2DManager * ) del ;

- (void) setContextCurrent ;

-(void) updateViewMatrix:(float) dx :(float) dy :(float) cx :(float) cy :(float) scale ;
-(live2d::framework::L2DViewMatrix*)getViewMatrix;

- (float) transformViewX:(float) deviceX;
- (float) transformViewY:(float) deviceY;
- (float) transformScreenX:(float) deviceX;
- (float) transformScreenY:(float) deviceY;

@end


