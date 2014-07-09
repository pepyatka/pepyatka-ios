#import "UIScrollView+Utils.h"

@implementation UIScrollView (Utils)

- (BOOL)isTop {
    return self.contentOffset.y <= 0;
}

- (BOOL)isTopWithMargin:(CGFloat)margin {
    return self.contentOffset.y <= margin;
}

- (BOOL)isBottom {
    return (self.contentOffset.y >= (self.contentSize.height - self.bounds.size.height));
}

- (BOOL)isBottomWithMargin:(CGFloat)margin {
    return ((self.contentOffset.y + margin) >= (self.contentSize.height - self.bounds.size.height));
}


@end
