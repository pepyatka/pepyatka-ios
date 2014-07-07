#import "ServerUser.h"

@implementation ServerUser

- (void)fillFromDictionary:(NSDictionary *)d {
    self.userID = [d[@"id"] noNullObject];
    self.userName = [d[@"username"] noNullObject];
    
    NSDictionary *info = [d[@"info"] noNullObject];
    if(info) {
        self.screenName = [info[@"screenName"] noNullObject];
        self.email = [info[@"email"] noNullObject];
        self.receiveEmails = [info[@"receiveEmails"] noNullObject];
    }
    
    self.rss = [d[@"rss"] noNullObject];
}

@end



@implementation ServerUser (Virtual)

- (BOOL)isAnonymous {
    return [self.userName isEqualToString:[ServerUser anonymousUserName]];
}

+ (NSString *)anonymousUserName {
    return @"anonymous";
}

@end

