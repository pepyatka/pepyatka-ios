#import "UIButton+Utils.h"

@implementation UIButton (Utils)

+ (UIButton *)menuButtonWithTarget:(id)target selector:(SEL)selector {
    UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *i = [UIImage imageNamed:@"menu_black24"];
    b.size = i.size;
    [b setImage:i forState:UIControlStateNormal];
    [b addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    return b;
}

+ (UIButton *)backButtonWithTarget:(id)target selector:(SEL)selector {
    UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *i = [UIImage imageNamed:@"back_black24"];
    b.size = i.size;
    [b setImage:i forState:UIControlStateNormal];
    [b addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    return b;
}

+ (UIButton *)saveButtonWithTarget:(id)target selector:(SEL)selector {
    UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
    b.size = CGSizeMake(44, 44);
    b.titleLabel.textAlignment = NSTextAlignmentRight;
    [b setTitle:NSLocalizedString(@"Save", nil) forState:UIControlStateNormal];
    [b setTitleColor:[UIColor blueButtonColor] forState:UIControlStateNormal];
    [b addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    return b;
}



@end
