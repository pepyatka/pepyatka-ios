#import "RightMasterDetailsSlider.h"
#import "UIView+Frame.h"

static const NSTimeInterval DefaultVelocity = 0.15; // seconds

@implementation RightMasterDetailsSlider
@synthesize rootView = rootView, sliderView = sliderView;
@synthesize sliderWidth = sliderWidth;

- (instancetype)initWithRootView:(__weak UIView *)aRootVew
                      sliderView:(__weak UIView *)aSliderView
                     sliderWidth:(CGFloat)aSliderWidth
{
    self = [super init];
    if (self) {
        rootView = aRootVew;
        sliderView = aSliderView;
        sliderWidth = aSliderWidth;
        pgr = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureStateChanged:)];
        pgr.delegate = self;
        tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureStateChanged:)];
        [sliderView addGestureRecognizer:tgr];
        [sliderView addGestureRecognizer:pgr];
    }
    return self;
}


- (CGFloat)xForDetailsShown:(BOOL)isDetailsShown {
    return isDetailsShown
    ? 0
    : (rootView.width - sliderWidth);
}

- (void)slideToMasterAnimated:(BOOL)animated {
    void (^ab)() = ^{
        sliderView.x = [self xForDetailsShown:NO];
    };
    if(animated) {
        [UIView animateWithDuration:DefaultVelocity animations:ab];
    } else {
        ab();
    }
}

- (void)slideToDetailsAnimated:(BOOL)animated {
    void (^ab)() = ^{
        sliderView.x = [self xForDetailsShown:YES];
    };
    if(animated) {
        [UIView animateWithDuration:DefaultVelocity animations:ab];
    } else {
        ab();
    }
}

- (BOOL)isDetailsShown {
    BOOL isShown = (sliderView.x <= 0.);
    return isShown;
    
}

- (void)setIsDetailsShown:(BOOL)isShown {
    if(isShown) {
        [self slideToDetailsAnimated:NO];
    } else {
        [self slideToMasterAnimated:NO];
    }
}

- (BOOL)isMasterShown {
    BOOL isShown = (sliderView.x >= rootView.width - sliderWidth);
    return isShown;
}

- (void)setIsMasterShown:(BOOL)isShown {
    if(isShown) {
        [self slideToMasterAnimated:NO];
    } else {
        [self slideToDetailsAnimated:NO];
    }
}

- (BOOL)isMiddleState {
    return !self.isDetailsShown && !self.isMasterShown;
}




#pragma mark - UIPanGestureRecognizer
- (void)panGestureStateChanged:(UIPanGestureRecognizer *)aPGR {
    static CGFloat leftOffsetX = 0.0;
    static CGFloat rightOffsetX = 0.0;
    CGPoint touchPoint = [aPGR locationInView:rootView];
    switch (aPGR.state) {
        case UIGestureRecognizerStatePossible:
        case UIGestureRecognizerStateBegan: {
            leftOffsetX = [aPGR locationInView:sliderView].x;
            rightOffsetX = leftOffsetX;
        }
            break;
        case UIGestureRecognizerStateChanged: {
            CGFloat xPosition = MAX(touchPoint.x - leftOffsetX, 0);
            CGFloat leftConstraint =  MIN(xPosition, rootView.width - sliderWidth);
            sliderView.x = leftConstraint;
        }
            break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateEnded: {
            CGFloat velocity = [aPGR velocityInView:rootView].x;
            if(velocity >= 0) {
                [self slideToMasterAnimated:YES];
            } else {

                [self slideToDetailsAnimated:YES];
            }
        }
            break;
        default:
            break;
    }


}

- (BOOL)PGRShouldBegin:(UIPanGestureRecognizer *)aPGR {
    if(self.isMiddleState) {
        NSLog(@"Dragging");
        return NO;
    } else {
        CGPoint touchPoint = [aPGR locationInView:rootView];
        BOOL isDetailsPoint = CGRectContainsPoint(sliderView.frame, touchPoint);
        return isDetailsPoint;
    }
}


#pragma mark - UITapGestureRecognizer
- (void)tapGestureStateChanged:(UITapGestureRecognizer *)aTGR {
    if (aTGR.state == UIGestureRecognizerStateRecognized) {
        if(self.isMasterShown) {
            [self slideToDetailsAnimated:YES];
        }
    }
}

- (BOOL)TGRShouldBegin:(UITapGestureRecognizer *)aTGR {
    if (self.isMasterShown) {
        BOOL result = CGRectContainsPoint(sliderView.frame, [aTGR locationInView:rootView]);
        return result;
    }
    
    NSLog(@"Dragging");
    return NO;
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)aGR {
    if(aGR == pgr) {
        return [self PGRShouldBegin:pgr];
    } else if(aGR == tgr) {
        return [self TGRShouldBegin:tgr];
    } else {
        return NO;
    }
}






@end
