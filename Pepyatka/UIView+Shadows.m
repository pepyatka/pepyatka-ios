#import "UIView+Shadows.h"

@implementation UIView (Shadows)

- (void)dropDetailsShadow {
    self.backgroundColor = [UIColor whiteColor];
    self.clipsToBounds = NO;
    CALayer *layer = self.layer;
    layer.shadowColor = [UIColor lightGrayColor].CGColor;
    layer.shadowOffset = CGSizeMake(-2, 0);
    layer.shadowOpacity = 1;
    layer.shadowRadius = 4.0;
}

@end
