#import "User.h"
#import "ServerUser.h"

@interface User (Utils)

- (void)fillWithServerUser:(ServerUser *)u;


@end

@interface ServerUser (User)

- (void)fillWithUser:(User *)u;

@end
