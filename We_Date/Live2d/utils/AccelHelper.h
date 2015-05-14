
#import <Foundation/Foundation.h>
//-------------------------------------------
//-------------------------------------------
@interface AccelHelper : NSObject <UIAccelerometerDelegate>
{
@private
	UIAccelerationValue accel[3] ;
}

-(void)update;


-(float) getShake;


-(void) resetShake;


-(float) getAccelX;


-(float) getAccelY;


-(float) getAccelZ;

@end