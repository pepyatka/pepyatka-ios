#import "ServerTimelineStat.h"

@implementation ServerTimelineStat

- (void)fillWithDictionary:(NSDictionary *)d {
    if(!d) {
        return;
    }
    self.userID = [d[@"userId"] noNullObject];
    self.posts = [d[@"posts"] noNullObject];
    self.likes = [d[@"likes"] noNullObject];
    self.discussions = [d[@"discussions"] noNullObject];
    self.subscribers = [d[@"subscribers"] noNullObject];
    self.subscriptions = [d[@"subscriptions"] noNullObject];
}

@end
