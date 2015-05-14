
#import "IPhoneUtil.h"

@implementation IPhoneUtil

+ (NSString*) toNSString:(std::string&) s
{
    return [[NSString alloc] initWithCString:s.c_str() encoding:NSUTF8StringEncoding];
}



+ (NSString*) getAppVersion
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}



+ (NSString*) getBuildVersion
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}


+ (int) getTouchNum:(NSSet*)touches
{
    int touchNum = 0 ;
	UITouch * touch_ary[8] ;
	
	for( UITouch * p in touches ){
		touch_ary[touchNum] = p ;
		++touchNum ;		
	}
    return touchNum;
}



+ (CGRect) getScreenRect
{
	return [[UIScreen mainScreen] bounds];
}

@end
