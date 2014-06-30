#import "UIView+NIB.h"

@implementation UIView (NIB)

+ (id)loadFromNIBWithName:(NSString *)aName {
    Class klass = [self class];
    NSArray* objects = [[NSBundle mainBundle] loadNibNamed:aName owner:self options:nil];
    for (id object in objects) {
        if ([object isKindOfClass:klass]) {
            return object;
        }
    }
    [NSException raise:@"WrongNibFormat" format:@"Nib for '%@' must contain one UIView, and its class must be '%@'", aName, NSStringFromClass(klass)];
    return nil;
}

+ (UIView *)loadFromNIBWithName:(NSString *)aName frame:(CGRect)aFrame {
    UIView *v = (UIView *)[self loadFromNIBWithName:aName];
    v.frame = aFrame;
    return v;
}

+ (id)loadFromNIB {
    return [self loadFromNIBWithName:[self nibName]];
}

+ (UIView *)loadFromNIBWithFrame:(CGRect)aFrame {
    UIView *v = (UIView *)[self loadFromNIB];
    v.frame = aFrame;
    return v;
}

+ (NSString*)nibName {
    return NSStringFromClass([self class]);
}

@end
