#import "APIClient.h"
#import "Server.h"
#import "User+Utils.h"
#import "ServerUser.h"

@interface APIClient (DB)

@property (readonly) Server *server;
@property (readonly) User *appUser;

- (User *)userWithID:(NSString *)userID;

- (void)dbMergeTags:(NSArray *)aTags save:(BOOL)save;
- (User *)dbLoginWithServerUser:(ServerUser *)aServerUser save:(BOOL)save;; // login, register, whoami
- (User *)dbRefreshUserWithServerUser:(ServerUser *)aServerUser save:(BOOL)save;; //get user, update settings
- (User *)dbLogoutWithSave:(BOOL)save; //logout

@end
