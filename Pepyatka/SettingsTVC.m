#import "SettingsTVC.h"
#import <QuartzCore/QuartzCore.h>
#import "User+Utils.h"
#import "APIClient+Methods.h"
#import "Server.h"
#import "PostsVC.h"


@implementation SettingsTVC
@synthesize apiClient = apiClient;

- (void)dealloc {
    [self removeObserverForURL:apiClient.baseURL];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    avatarB.layer.cornerRadius = avatarB.width / 2;
    avatarB.layer.borderColor = [UIColor whiteColor].CGColor;
    avatarB.layer.borderWidth = 3.0;
    
    avatarB.layer.masksToBounds = YES;

    saveB = [self setSaveButtonWithSelector:@selector(save)];
    [self updateUIWithAPIClient];
}

- (void)updateUIWithAPIClient {
    if(!emailF) {
        return;
    }
    
    self.navigationItem.title = apiClient.baseURL.host;
    
    userNameL.text = serverUser.userName;
    screenNameF.text = serverUser.screenName;
    emailF.text = serverUser.email;
    inRealTimeCell.accessoryType = serverUser.receiveEmails.boolValue? UITableViewCellAccessoryNone: UITableViewCellAccessoryCheckmark;
    doNotSendCell.accessoryType = serverUser.receiveEmails.boolValue? UITableViewCellAccessoryCheckmark: UITableViewCellAccessoryNone;
}

- (void)fetchUserFromStorage {
    if(!apiClient) {
        return;
    }
    
    Server *server = [Server MR_findFirstByAttribute:@"baseURL" withValue:apiClient.baseURL.absoluteString];
    user = server.appUser;
    
    serverUser = [ServerUser new];
    [serverUser fillWithUser:user];
}

- (void)setApiClient:(APIClient *)client {
    [self removeObserverForURL:apiClient.baseURL];
    apiClient = client;
    [self fetchUserFromStorage];
    [self updateUIWithAPIClient];
    [self addObserverForURL:apiClient.baseURL selector:@selector(didUpdateAccountWithNote:)];
}

#pragma mark - Actions


- (IBAction)posts:(UIButton *)b {
    PostsVC *vc = [[PostsVC alloc] initWithAPIClient:apiClient timelineName:serverUser.userName];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)save {
    serverUser.screenName = screenNameF.text;
    serverUser.email = emailF.text;
    
    [apiClient updateServerUser:serverUser completion:^(NSError *err, ServerUser *u) {
        [err showAlert];
        if(!err) {
            [apiClient dbRefreshUserWithServerUser:u save:YES];
            [apiClient.baseURL notify];
            [self.delegate didSaveInSettingsTVC:self];
        }
    }];
}

- (IBAction)tapSignOut:(UIButton *)b {
    [apiClient pseudoLogoutWithCompletion:^(NSError *err) {
        [err showAlert];
        if(!err) {
            [apiClient dbLogoutWithSave:YES];
            [apiClient.baseURL notify];
            [self.delegate didLogoutInSettingsTVC:self];
        }
    }];
}

- (IBAction)tapSendPostOptionWithButton:(UIButton *)b {
    serverUser.receiveEmails = @(b.tag);
    [self updateUIWithAPIClient];
    return;
}

- (IBAction)editingChanged:(UITextField *)textField {
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.destinationViewController isKindOfClass:[RSSTVC class]]) {
        RSSTVC *vc = segue.destinationViewController;
        vc.delegate = self;
        vc.resultRSS = serverUser.rss;
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if(textField == screenNameF) {
        [emailF becomeFirstResponder];
        return NO;
    }
    
    if(textField == emailF) {
        [screenNameF becomeFirstResponder];
        return NO;
    }
    
    return NO;
}


#pragma mark - @protocol RSSTVCDelegate
- (void)didCompleteModificationsInRSSTVC:(RSSTVC *)avc {
    serverUser.rss = avc.resultRSS.copy;
}


#pragma mark - Notifications

- (void)didUpdateAccountWithNote:(NSNotification *)n {
    [self fetchUserFromStorage];
    [self updateUIWithAPIClient];
}

@end
