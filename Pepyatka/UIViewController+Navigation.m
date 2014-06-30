#import "UIViewController+Navigation.h"
#import "MasterDetailsVC.h"
#import "UIView+Frame.h"


@implementation UIViewController (Navigation)


- (UIButton *)menuButton {
    UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *i = [UIImage imageNamed:@"menu_black24"];
    b.size = i.size;
    [b setImage:i forState:UIControlStateNormal];
    [b addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
    return b;
}

- (UIBarButtonItem *)menuBarButton {
    UIBarButtonItem *b = [[UIBarButtonItem alloc] initWithCustomView:[self menuButton]];
    return b;
}


- (UIButton *)backButton {
    UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *i = [UIImage imageNamed:@"back_black24"];
    b.size = i.size;
    [b setImage:i forState:UIControlStateNormal];
    [b addTarget:self action:@selector(popToBack:) forControlEvents:UIControlEventTouchUpInside];
    return b;
}

- (UIBarButtonItem *)backBarButton {
    UIBarButtonItem *b = [[UIBarButtonItem alloc] initWithCustomView:[self backButton]];
    return b;
}

- (void)setLeftNavigation {
    if(self.navigationController.viewControllers.count == 1) {
        self.navigationItem.leftBarButtonItem = [self menuBarButton];
    } else if(self.navigationController.viewControllers.count > 1) {
        self.navigationItem.leftBarButtonItem = [self backBarButton];
    }
}


#pragma mark - Action

- (void)showMenu:(UIButton *)b {
    UINavigationController *nvc = self.navigationController;
    MasterDetailsVC *mdvc = (MasterDetailsVC *)nvc.parentViewController;
    if([mdvc isKindOfClass:[MasterDetailsVC class]]) {
        [mdvc showMasterControllerAnimated:YES];
    }
}

- (void)popToBack:(UIButton *)b {
    UINavigationController *nvc = self.navigationController;
    [nvc popViewControllerAnimated:YES];
}



@end
