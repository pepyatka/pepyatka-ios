#import "MenuProfileCell.h"
#import "APIClient+Methods.h"
#import "Server.h"
#import <QuartzCore/QuartzCore.h>

@implementation MenuProfileCell
@synthesize apiClient = apiClient;

- (void)awakeFromNib {
    [super awakeFromNib];
    profileB.layer.masksToBounds = YES;
    profileB.layer.cornerRadius = profileB.width / 2;
}


- (void)dealloc {
    [self removeObserverForURL:apiClient.baseURL];
}

+ (NSString *)reuseID {
    static NSString *reuseID = @"MenuProfileCell";
    return reuseID;
}

- (void)fetchUser {
    user = [apiClient appUser];
}

- (void)updateUIWithCurrentAPIClient {
    pointL.text = apiClient.baseURL.host;
    usernameL.text = [ServerUser anonymousUserName];
    
    if(user) {
        usernameL.text = user.userName;
        if(user.screenName.length) {
            usernameL.text = [NSString stringWithFormat:@"%@ — %@", usernameL.text, user.screenName];
        }
    }
}

- (void)setApiClient:(APIClient *)client {
    [self removeObserverForURL:apiClient.baseURL];
    apiClient = client;
    [self addObserverForURL:apiClient.baseURL selector:@selector(didUpdateAPIClientBaseURLWithNote:)];
    
    user = nil;
    [self fetchUser];
    [self updateUIWithCurrentAPIClient];
}

- (void)asyncWhoAmI {
    [self.apiClient whoamiWithCompletion:^(NSError *err, ServerUser *u) {
        if(!err) {
            if(u.isAnonymous) {
                [apiClient dbLogoutWithSave:YES];
            } else {
                [apiClient dbLoginWithServerUser:u save:YES];
            }
            [apiClient.baseURL notify];
        }
    }];
}

- (IBAction)tapProfileB:(UIButton *)b {
    if(!user) {
        [self.delegate wantsShowSignInInMenuProfileCell:self];
    } else {
        [self.delegate wantsShowSettingsInMenuProfileCell:self];
    }
}

#pragma mark - Notifications

- (void)didUpdateAPIClientBaseURLWithNote:(NSNotification *)n {
    [self fetchUser];
    [self updateUIWithCurrentAPIClient];
}

@end
