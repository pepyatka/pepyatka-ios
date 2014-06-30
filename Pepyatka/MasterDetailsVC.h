#import <UIKit/UIKit.h>
#import "MenuTVC.h"
#import "SignInTVC.h"
#import "RightMasterDetailsSlider.h"


@interface MasterDetailsVC : UIViewController <MenuTVCDelegate, UINavigationControllerDelegate> {
    __weak IBOutlet UIView *detailsContainerV;
    
    __weak UINavigationController *navVC;
    __weak MenuTVC *menuVC;
    RightMasterDetailsSlider *slider;
}

- (void)showMasterControllerAnimated:(BOOL)animated;


@end
