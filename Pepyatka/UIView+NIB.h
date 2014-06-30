#import <Foundation/Foundation.h>

@interface UIView (NIB)

+ (id)loadFromNIB;
+ (NSString *)nibName;
+ (id)loadFromNIBWithName:(NSString *)aName;
+ (UIView *)loadFromNIBWithName:(NSString *)aName frame:(CGRect)aFrame;
+ (UIView *)loadFromNIBWithFrame:(CGRect)aFrame;

@end
