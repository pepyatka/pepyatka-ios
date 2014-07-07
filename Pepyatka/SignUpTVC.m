
#import "SignUpTVC.h"
#import "APIClient+Methods.h"
#import "UIActivityIndicatorView+AFNetworking.h"

@implementation SignUpTVC
@synthesize apiClient = apiClient;


- (void)lockUIWithProgress:(BOOL)isProgress {
    userF.enabled = !isProgress;
    passwordF.enabled = !isProgress;
}

- (void)setApiClient:(APIClient *)client {
    apiClient = client;
    self.title = client.baseURL.host;
    self.navigationItem.title = client.baseURL.host;
}

- (void)makeSignUp {
    if(task) return;
    [self lockUIWithProgress:YES];
    task = [self.apiClient registerWithUser:userF.text
                                  passsword:passwordF.text
                                 completion:^(NSError *err, ServerUser *user) {
                                     task = nil;
                                     [self lockUIWithProgress:NO];
                                     [err showAlert];
                                     if(!err) {
                                         [apiClient dbLoginWithServerUser:user save:YES];
                                         [apiClient.baseURL notify];
                                         [self.delegate didRegisterInSignUpTVC:self];
                                     }
                                 }];
    [indicatorV setAnimatingWithStateOfTask:task];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if(textField == userF) {
        [passwordF becomeFirstResponder];
        return NO;
    }
    
    if(textField == passwordF) {
        [self makeSignUp];
        [textField resignFirstResponder];
        return NO;
    }
    
    return NO;
}

@end
