#import <UIKit/UIKit.h>
#import "MenuTVC.h"
#import "SignInTVC.h"
#import "SettingsTVC.h"
#import "RightMasterDetailsSlider.h"
#import "PostsVC.h"


@interface MasterDetailsVC : UIViewController <
    MenuTVCDelegate, SettingsTVCDelegate, SignInTVCDelegate,
    UINavigationControllerDelegate
> {
    __weak IBOutlet UIView *detailsContainerV;
    
    __weak UINavigationController *navVC;
    __weak MenuTVC *menuVC;
    RightMasterDetailsSlider *slider;
}

- (void)toggleMasterDetailsAnimated:(BOOL)animated;


@end
