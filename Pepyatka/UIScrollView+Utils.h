#import <UIKit/UIKit.h>

@interface UIScrollView (Utils)

@property (nonatomic, readonly) BOOL isTop, isBottom;

- (BOOL)isBottomWithMargin:(CGFloat)margin;
- (BOOL)isTopWithMargin:(CGFloat)margin;
@end
