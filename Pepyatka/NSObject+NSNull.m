#import "NSObject+NSNull.h"

@implementation NSObject (NSNull)

- (instancetype)noNullObject {
    if([self isKindOfClass:[NSNull class]]) {
        return nil;
    } else {
        return self;
    }
}

@end
