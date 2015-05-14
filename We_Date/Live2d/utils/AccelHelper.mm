

#import "AccelHelper.h"

#import <mach/mach_time.h>
#include "util/UtSystem.h"

@implementation AccelHelper

static int lastTimeMSec = -1 ;
static double lastMove ;

#define ACCEL_INTERVAL_
#define ACCEL_THREASHOLD (0.1)
#define ACCEL_MODE_IDLING (false)
#define ACCEL_MODE_ACTIVE (true)
#define ACCEL_AVERAGE_COUNT (10)
#define ACCEL_ACTIVE_PERIOD (10)

#define MAX_ACCEL_D (0.1)
#define MAX_SCALE_VALUE 0.4 

static double accelData[ACCEL_AVERAGE_COUNT] ;
static bool accelMode = ACCEL_MODE_IDLING ;
static int accelCounter = 0 ;
static int accelActiveModeEnd = ACCEL_AVERAGE_COUNT * 2 ;

static float accelInterval = 1.0 / 10.0 ;

static float acceleration_x = 0 ;
static float acceleration_y = 0 ;
static float acceleration_z = 0 ;
static float dst_acceleration_x = 0 ;
static float dst_acceleration_y = 0 ;
static float dst_acceleration_z = 0 ;

static float last_dst_acceleration_x = 0 ;
static float last_dst_acceleration_y = 0 ;
static float last_dst_acceleration_z = 0 ;

- (void) dealloc
{
    [[UIAccelerometer sharedAccelerometer] setDelegate:nil];
}

//==================================================

//==================================================
- (void) accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
	
	
	
	double curAccelValue = acceleration.x + acceleration.y + acceleration.z ;
	accelData[ (accelCounter++)%ACCEL_AVERAGE_COUNT ] = curAccelValue ;
	double curAccelAve = 0 ;
	for (int i = 0 ; i < ACCEL_AVERAGE_COUNT ; i++ ) curAccelAve += accelData[i] ;
	curAccelAve /= ACCEL_AVERAGE_COUNT ;
	if( fabs( curAccelAve - curAccelValue ) > ACCEL_THREASHOLD )
	{
		accelActiveModeEnd = accelCounter + ACCEL_ACTIVE_PERIOD ;
	}
	accelMode = ( accelCounter < accelActiveModeEnd ) ? ACCEL_MODE_ACTIVE : ACCEL_MODE_IDLING ;
	
	if( accelMode == ACCEL_MODE_IDLING ) return ;
	
	
	float scale1 = 0.5 ;
	dst_acceleration_x = dst_acceleration_x * scale1 + acceleration.x * (1-scale1) ;
	dst_acceleration_y = dst_acceleration_y * scale1 + acceleration.y * (1-scale1) ;
	dst_acceleration_z = dst_acceleration_z * scale1 + acceleration.z * (1-scale1) ;
	
	
	double move = 
    fabs(dst_acceleration_x-last_dst_acceleration_x) + 
    fabs(dst_acceleration_y-last_dst_acceleration_y) + 
    fabs(dst_acceleration_z-last_dst_acceleration_z) ;
	lastMove = lastMove * 0.7 + move * 0.3 ;
	
	last_dst_acceleration_x = dst_acceleration_x ;
	last_dst_acceleration_y = dst_acceleration_y ;
	last_dst_acceleration_z = dst_acceleration_z ;
}

//==================================================

//==================================================

- (void) update
{
	float dx = dst_acceleration_x - acceleration_x ;
	float dy = dst_acceleration_y - acceleration_y ;
	float dz = dst_acceleration_z - acceleration_z ;
	
	if( dx >  MAX_ACCEL_D ) dx =  MAX_ACCEL_D ;
	if( dx < -MAX_ACCEL_D ) dx = -MAX_ACCEL_D ;
	
	if( dy >  MAX_ACCEL_D ) dy =  MAX_ACCEL_D ;
	if( dy < -MAX_ACCEL_D ) dy = -MAX_ACCEL_D ;
	
	if( dz >  MAX_ACCEL_D ) dz =  MAX_ACCEL_D ;
	if( dz < -MAX_ACCEL_D ) dz = -MAX_ACCEL_D ;
	
	acceleration_x += dx ;
	acceleration_y += dy ;
	acceleration_z += dz ;
	
	long long time = live2d::UtSystem::getTimeMSec() ;
	long long diff = time - lastTimeMSec ;
	lastTimeMSec = time ;
	
	float scale = 0.2 * diff * 60 / (1000.0f) ;	

	if( scale > MAX_SCALE_VALUE ) scale = MAX_SCALE_VALUE ;
	
	accel[0] = (acceleration_x * scale) + (accel[0] * (1.0 - scale)) ;
	accel[1] = (acceleration_y * scale) + (accel[1] * (1.0 - scale)) ;
	accel[2] = (acceleration_z * scale) + (accel[2] * (1.0 - scale)) ;
}


//==================================================
// Init
//==================================================
- (id) init
{
	if (self = [super init])
	{
		
		UIAccelerometer * _accel = [UIAccelerometer sharedAccelerometer] ;
		[_accel setUpdateInterval:accelInterval] ;
		[_accel setDelegate:self] ;
	}
	return self;
}



-(float) getShake{
    return lastMove;
}



-(void) resetShake{
    lastMove=0;
}



-(float) getAccelX {
    return accel[0];
}



-(float) getAccelY{
    return accel[1];
}



-(float) getAccelZ{
    return accel[2];
}

@end