
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
    
    
    PostsVC *tlvc = [[PostsVC alloc] initWithAPIClient:[APIClient allClients][0] timelineName:@"everyone"];
    [self setDetailsVC:tlvc animated:NO];
}

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

- (void)showEveryoneForClient:(APIClient *)client {
    PostsVC *tlvc = [[PostsVC alloc] initWithAPIClient:client timelineName:@"everyone"];
    [self setDetailsVC:tlvc animated:NO];
}

- (void)showSettingsWithClient:(APIClient *)client {
    SettingsTVC *vc = [SettingsTVC withStoryboard:self.storyboard];
    vc.delegate = self;
    vc.apiClient = client;
    [self setDetailsVC:vc animated:NO];
}

- (void)setDetailsVC:(UIViewController *)avc animated:(BOOL)animated {
    [navVC setViewControllers:@[avc] animated:animated];
    [slider slideToDetailsAnimated:YES];
}


#pragma mark - @protocol MenuTVCDelegate
- (void)menuTVC:(MenuTVC *)tvc wantsToShowSignInWithAPIClient:(__weak APIClient *)anAPIClient {
    SignInTVC *vc = [SignInTVC withStoryboard:self.storyboard];
    vc.delegate = self;
    vc.apiClient = anAPIClient;
    [self setDetailsVC:vc animated:NO];
}

- (void)menuTVC:(MenuTVC *)tvc wantsToShowSettingsWithAPIClient:(__weak APIClient *)anAPIClient {
    [self showSettingsWithClient:anAPIClient];
}

- (void)menuTVC:(MenuTVC *)tvc didTapPointWithAPIClient:(__weak APIClient *)anAPIClient {
    [self showEveryoneForClient:anAPIClient];
}


- (void)menuTVC:(MenuTVC *)tvc wantsToShowResultsByTag:(NSString *)aTag APIClient:(__weak APIClient *)anAPIClient {
    PostsVC *tlvc = [[PostsVC alloc] initWithAPIClient:anAPIClient searchText:aTag];
    [self setDetailsVC:tlvc animated:NO];
}

- (void)menuTVC:(MenuTVC *)tvc wantsToShowSearchResultWithText:(NSString *)aText APIClient:(__weak APIClient *)anAPIClient {
    PostsVC *tlvc = [[PostsVC alloc] initWithAPIClient:anAPIClient searchText:aText];
    [self setDetailsVC:tlvc animated:NO];
}


#pragma mark - SettingsTVCDelegate
- (void)didLogoutInSettingsTVC:(SettingsTVC *)avc {
    [self showEveryoneForClient:avc.apiClient];
}

- (void)didSaveInSettingsTVC:(SettingsTVC *)avc {
    [self showEveryoneForClient:avc.apiClient];
}

#pragma mark - @protocol SignInTVCDelegate

- (void)didLoginSuccessInSignInTVC:(SignInTVC *)avc {
    [self showSettingsWithClient:avc.apiClient];
}


#pragma mark - @protocol UINavigationControllerDelegate <NSObject>

- (void)hideKeyboard {
    UIView *fr = [menuVC.view findFirstResponder];
    if(fr) {
        [fr resignFirstResponder];
        return;
    }
    
    fr = [navVC.view findFirstResponder];
    if(fr) {
        [fr resignFirstResponder];
        return;
    }
}


- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [viewController setLeftNavigation];
}


@end
