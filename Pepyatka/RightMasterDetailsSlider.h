#import <Foundation/Foundation.h>

@interface RightMasterDetailsSlider : NSObject <UIGestureRecognizerDelegate> {
    __weak UIView *rootView, *sliderView;
    CGFloat sliderWidth;
    UIPanGestureRecognizer *pgr;
    UITapGestureRecognizer *tgr;
}

@property (nonatomic, readonly) UIView *rootView, *sliderView;
@property (nonatomic, readonly) CGFloat sliderWidth;

@property (nonatomic, assign) BOOL isDetailsShown, isMasterShown;
@property (nonatomic, readonly) BOOL isMiddleState;

- (void)slideToMasterAnimated:(BOOL)animated;
- (void)slideToDetailsAnimated:(BOOL)animated;


- (instancetype)initWithRootView:(__weak UIView *)aRootVew
                      sliderView:(__weak UIView *)aSliderView
                     sliderWidth:(CGFloat)aSliderWidth;




@end
