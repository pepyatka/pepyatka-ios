
#import <UIKit/UIKit.h>

@interface UIButton (Utils)

+ (UIButton *)menuButtonWithTarget:(id)target selector:(SEL)selector;
+ (UIButton *)backButtonWithTarget:(id)target selector:(SEL)selector;
+ (UIButton *)saveButtonWithTarget:(id)target selector:(SEL)selector;


@end
