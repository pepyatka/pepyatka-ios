#import "NSObject+NIB.h"

@implementation NSObject (NIB)

+ (UINib *)nib {
    return [UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil];
}

@end
