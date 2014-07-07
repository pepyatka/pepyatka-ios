#import <UIKit/UIKit.h>
#import "APIClient.h"
#import "ServerUser.h"
#import "User.h"
#import "RSSTVC.h"

@protocol SettingsTVCDelegate;

@interface SettingsTVC : UITableViewController <RSSTVCDelegate> {
    UIButton *saveB;
    
    __weak IBOutlet UIButton *avatarB;
    __weak IBOutlet UILabel *userNameL;
    __weak IBOutlet UIActivityIndicatorView *indicatorV;
    
    __weak IBOutlet UITextField *screenNameF;
    __weak IBOutlet UITextField *emailF;
    
    __weak IBOutlet UITableViewCell *inRealTimeCell;
    __weak IBOutlet UITableViewCell *doNotSendCell;
    
    
    User *user;
    ServerUser *serverUser;
    
    __weak APIClient *apiClient;
}

@property (nonatomic, weak) id<SettingsTVCDelegate> delegate;
@property (nonatomic, weak) APIClient *apiClient;

@end

@protocol SettingsTVCDelegate
- (void)didLogoutInSettingsTVC:(SettingsTVC *)avc;
- (void)didSaveInSettingsTVC:(SettingsTVC *)avc;
@end