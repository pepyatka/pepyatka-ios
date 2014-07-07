#import "UIViewController+Navigation.h"
#import "MasterDetailsVC.h"
#import "UIButton+Utils.h"

#import "UIView+Frame.h"


@implementation UIViewController (Navigation)

- (UIBarButtonItem *)menuBarButton {
    UIBarButtonItem *b = [[UIBarButtonItem alloc]
                          initWithCustomView:[UIButton menuButtonWithTarget:self selector:@selector(showMenuAction:)]];
    return b;
}

- (UIBarButtonItem *)backBarButton {
    UIBarButtonItem *b = [[UIBarButtonItem alloc]
                          initWithCustomView:[UIButton backButtonWithTarget:self selector:@selector(popToBackAction:)]];
    return b;
}

- (void)setLeftNavigation {
    if(self.navigationController.viewControllers.count == 1) {
        self.navigationItem.leftBarButtonItem = [self menuBarButton];
    } else if(self.navigationController.viewControllers.count > 1) {
        self.navigationItem.leftBarButtonItem = [self backBarButton];
    }
}

- (UIButton *)setSaveButtonWithSelector:(SEL)selector {
    UIButton *b = [UIButton saveButtonWithTarget:self selector:selector];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:b];
    return b;
}

#pragma mark - Action

- (void)showMenuAction:(UIButton *)b {
    UINavigationController *nvc = self.navigationController;
    MasterDetailsVC *mdvc = (MasterDetailsVC *)nvc.parentViewController;
    if([mdvc isKindOfClass:[MasterDetailsVC class]]) {
        [mdvc toggleMasterDetailsAnimated:YES];
    }
#warning hide keyboard
}

- (void)popToBackAction:(UIButton *)b {
    UINavigationController *nvc = self.navigationController;
    [nvc popViewControllerAnimated:YES];
}



@end
