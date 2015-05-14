
#import <Foundation/Foundation.h>
#include <string>

@interface IPhoneUtil : NSObject

+ (NSString*) toNSString:(std::string&) s;
+ (NSString*) getAppVersion;
+ (NSString*) getBuildVersion;
+ (int) getTouchNum:(NSSet*)touches;
+ (CGRect) getScreenRect;
@end

