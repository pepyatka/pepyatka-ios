#import <UIKit/UIKit.h>


//stdmib 2013-10-30

@interface UIView (Frame)
@property (assign) CGFloat height, width;
@property (assign) CGFloat x, y, centerX, centerY;
@property (assign) CGSize size;
@property (assign) CGPoint origin;

@property (readonly) CGFloat maxX, minX, maxY, minY;
@property (readonly) CGFloat midX, midY;
@end


