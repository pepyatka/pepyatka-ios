#import "UIViewController+Storyboard.h"

@implementation UIViewController (Storyboard)

+ (instancetype)withStoryboard:(UIStoryboard *)aSB {
    return [aSB instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
}


@end
