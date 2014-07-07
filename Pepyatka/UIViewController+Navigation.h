#import <UIKit/UIKit.h>

@interface UIViewController (Navigation)

- (void)setLeftNavigation;
- (UIButton *)setSaveButtonWithSelector:(SEL)selector;

#pragma mark - Can be overrided

- (void)showMenuAction:(UIButton *)b;
- (void)popToBackAction:(UIButton *)b;


@end
