
#import "MasterDetailsVC.h"
#import "UIViewController+Navigation.h"
#import "UIView+Shadows.h"
//#import <QuartzCore/QuartzCore.h>


static const CGFloat DetailsTailWidth = 52.;

@implementation MasterDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    slider = [[RightMasterDetailsSlider alloc] initWithRootView:self.view
                                                     sliderView:detailsContainerV
                                                    sliderWidth:DetailsTailWidth];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [slider slideToDetailsAnimated:YES];
    
    [navVC.view dropDetailsShadow];
}

//- (void)showMasterControllerAnimated:(BOOL)animated {
//    [slider slideToMasterAnimated:animated];
//}

- (void)toggleMasterDetailsAnimated:(BOOL)animated {
    if(slider.isDetailsShown) {
        [slider slideToMasterAnimated:animated];
    } else if (slider.isMasterShown) {
        [slider slideToDetailsAnimated:animated];
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"DetailsSegue"]) {
        navVC = (UINavigationController *)segue.destinationViewController;
        navVC.delegate = self;
        return;
    }
    
    if([segue.identifier isEqualToString:@"MasterSegue"]) {
        menuVC = (MenuTVC *)segue.destinationViewController;
        menuVC.delegate = self;
        return;
    }
}

#pragma mark - Details Control

- (void)setDetailsVC:(UIViewController *)avc animated:(BOOL)animated {
    [navVC setViewControllers:@[avc] animated:animated];
    [slider slideToDetailsAnimated:YES];
}


#pragma mark - @protocol MenuTVCDelegate
- (void)menuTVC:(MenuTVC *)tvc wantsToShowSignInWithAPIClient:(__weak APIClient *)anAPIClient {
    SignInTVC *vc = [SignInTVC withStoryboard:self.storyboard];
    vc.apiClient = anAPIClient;
    [self setDetailsVC:vc animated:NO];
}

- (void)menuTVC:(MenuTVC *)tvc wantsToShowSettingsWithAPIClient:(__weak APIClient *)anAPIClient {
    SettingsTVC *vc = [SettingsTVC withStoryboard:self.storyboard];
    vc.apiClient = anAPIClient;
    [self setDetailsVC:vc animated:NO];
}

- (void)menuTVC:(MenuTVC *)tvc didTapPointWithAPIClient:(__weak APIClient *)anAPIClient {

}


- (void)menuTVC:(MenuTVC *)tvc wantsToShowResultsByTag:(NSString *)aTag {

}

- (void)menuTVC:(MenuTVC *)tvc wantsToShowSearchResultWithText:(NSString *)aText {

}

#pragma mark - @protocol UINavigationControllerDelegate <NSObject>

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [viewController setLeftNavigation];
}


@end
