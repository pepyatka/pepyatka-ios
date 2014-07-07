#import "SignInTVC.h"
#import "APIClient+Methods.h"

#import "UIActivityIndicatorView+AFNetworking.h"

@implementation SignInTVC
@synthesize apiClient = apiClient;

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)lockUIWithProgress:(BOOL)isProgress {
    userF.enabled = !isProgress;
    passwordF.enabled = !isProgress;
    signUPB.enabled = !isProgress;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"SignUpTVC"]) {
        SignUpTVC *tvc = segue.destinationViewController;
        tvc.delegate = self;
    }
}

- (void)setApiClient:(APIClient *)client {
    apiClient = client;
    self.title = client.baseURL.host;
    self.navigationItem.title = client.baseURL.host;
}

- (void)makeSignIn {
    if(task) return;
    [self lockUIWithProgress:YES];
    task = [self.apiClient loginWithUser:userF.text
                               passsword:passwordF.text
                              completion:^(NSError *err, ServerUser *user) {
                                  task = nil;
                                  [self lockUIWithProgress:NO];
                                  [err showAlert];
                                  if(!err) {
                                      [apiClient dbLoginWithServerUser:user save:YES];
                                      [apiClient.baseURL notify];
                                      [self.delegate didLoginSuccessInSignInTVC:self];
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
        [self makeSignIn];
        [textField resignFirstResponder];
        return NO;
    }
    
    return NO;
}

#pragma mark - SignUpTVCDelegate
- (void)didRegisterInSignUpTVC:(SignUpTVC *)avc {
    [self.delegate didLoginSuccessInSignInTVC:self];
}

@end
