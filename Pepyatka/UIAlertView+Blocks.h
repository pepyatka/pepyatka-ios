#import <UIKit/UIKit.h>

//2013-05-25

@interface UIAlertView (Blocks) <UIAlertViewDelegate>

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message buttonTitle:(NSString *)buttonText handler:(void(^)(void))block;
+ (id)alertWithTitle:(NSString *)title;
+ (id)alertWithTitle:(NSString *)title message:(NSString *)message;
- (id)initWithTitle:(NSString *)title message:(NSString *)message;

- (NSInteger)addButtonWithTitle:(NSString *)title handler:(void(^)(void))block;
- (NSInteger)setCancelButtonWithTitle:(NSString *)title handler:(void(^)(void))block;
- (void (^)(void))handlerForButtonAtIndex:(NSInteger)index;

@property (copy) void (^cancelBlock)(void);
@property (copy) void (^willShowBlock)(void);
@property (copy) void (^didShowBlock)(void);
@property (copy) void (^willDismissBlock)(NSUInteger);
@property (copy) void (^didDismissBlock)(NSUInteger);

@end
