
#import <UIKit/UIKit.h>
#import "APIClient.h"
#import "SignUpTVC.h"

@protocol SignInTVCDelegate;

@interface SignInTVC : UITableViewController <UITextFieldDelegate, SignUpTVCDelegate> {
    __weak IBOutlet UITextField *userF, *passwordF;
    __weak IBOutlet UIActivityIndicatorView *indicatorV;
    __weak IBOutlet UIButton *signUPB;
    __weak APIClient *apiClient;
    
    
    __weak NSURLSessionDataTask *task;
}

@property (nonatomic, weak) APIClient *apiClient;
@property (nonatomic, weak) id<SignInTVCDelegate> delegate;


@end

@protocol SignInTVCDelegate
- (void)didLoginSuccessInSignInTVC:(SignInTVC *)avc;
@end