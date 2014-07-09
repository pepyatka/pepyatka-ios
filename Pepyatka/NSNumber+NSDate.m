#import "NSNumber+NSDate.h"

@implementation NSNumber (NSDate)

- (NSDate *)millisecondsSince1970Date {
    long long milliSeconds = self.longLongValue;
    long long seconds = milliSeconds / 1000;
    
    NSDate *result = [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)seconds];
    return result;
}


@end
