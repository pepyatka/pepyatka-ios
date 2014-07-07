#import "User+Utils.h"

@implementation User (Utils)

- (void)fillWithServerUser:(ServerUser *)u {
    if(!u) {
        return;
    }
    
    self.userID = u.userID;
    self.userName = u.userName;
    self.screenName = u.screenName;
    self.email = u.email;
    self.receiveEmails = u.receiveEmails;
    self.rss = u.rss;
}

@end



@implementation ServerUser (User)

- (void)fillWithUser:(User *)u {
    if(!u) {
        return;
    }
    self.userID = u.userID;
    self.userName = u.userName;
    self.screenName = u.screenName;
    self.email = u.email;
    self.receiveEmails = u.receiveEmails;
    self.rss = u.rss;
}

@end

