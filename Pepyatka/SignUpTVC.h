#import <UIKit/UIKit.h>
#import "APIClient.h"

@protocol SignUpTVCDelegate;

@interface SignUpTVC : UITableViewController <UITextFieldDelegate> {
    __weak IBOutlet UITextField *userF, *passwordF;
    
    __weak IBOutlet UIActivityIndicatorView *indicatorV;
    __weak APIClient *apiClient;

    __weak NSURLSessionDataTask *task;
}

@property (nonatomic, weak) APIClient *apiClient;
@property (nonatomic, weak) id<SignUpTVCDelegate> delegate;

@end


@protocol SignUpTVCDelegate
- (void)didRegisterInSignUpTVC:(SignUpTVC *)avc;
@end
