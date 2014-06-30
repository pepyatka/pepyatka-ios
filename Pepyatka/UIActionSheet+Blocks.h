#import <UIKit/UIKit.h>

@interface UIActionSheet (Blocks) <UIActionSheetDelegate>

+ (instancetype)actionSheetWithTitle:(NSString *)title;
- (instancetype)initWithTitle:(NSString *)title;
- (NSInteger)addButtonWithTitle:(NSString *)title handler:(void (^)(void))block;
- (NSInteger)addDestructiveButtonWithTitle:(NSString *)title handler:(void (^)(void))block;
- (NSInteger)addCancelButtonWithTitle:(NSString *)title handler:(void (^)(void))block;

- (void)setHandler:(void (^)(void))block forButtonAtIndex:(NSInteger)index;
- (void (^)(void))handlerForButtonAtIndex:(NSInteger)index;

@property (nonatomic, copy) void (^ cancelBlock)(void);

@property (nonatomic, copy) void (^ willPresentBlock) (UIActionSheet *actionSheet);
@property (nonatomic, copy) void (^ didPresentBlock) (UIActionSheet *actionSheet);
@property (nonatomic, copy) void (^ willDismissBlock) (UIActionSheet *actionSheet, NSInteger buttonIndex);
@property (nonatomic, copy) void (^ didDismissBlock) (UIActionSheet *actionSheet, NSInteger buttonIndex);

@end
