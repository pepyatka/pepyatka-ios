#import "APIClient+DB.h"
#import "Server.h"

@implementation APIClient (DB)

- (Server *)server {
    Server *server = [Server MR_findFirstByAttribute:@"baseURL" withValue:self.baseURL.absoluteString];
    return server;
}


- (User *)appUser {
    User *user = self.server.appUser;
    return user;
}

- (User *)userWithID:(NSString *)userID {
    NSPredicate *userIDP = [NSPredicate predicateWithFormat:@"userID = %@", userID];
    NSPredicate *baseURLP = [NSPredicate predicateWithFormat:@"baseURL = %@", self.baseURL.absoluteString];
    NSPredicate *p = [NSCompoundPredicate andPredicateWithSubpredicates:@[userIDP, baseURLP]];
    User *user = [User MR_findFirstWithPredicate:p];
    return user;
}


- (void)dbMergeTags:(NSArray *)aTags save:(BOOL)save {
    self.server.tags = aTags;
    
    if(save) {
        [self.server.managedObjectContext MR_saveToPersistentStoreAndWait];
    }
    
}

- (User *)dbLoginWithServerUser:(ServerUser *)aServerUser save:(BOOL)save {
    User *user = [self dbRefreshUserWithServerUser:aServerUser save:NO];
    user.signedServer = self.server;
    
    if(save) {
        [user.managedObjectContext MR_saveToPersistentStoreAndWait];
    }

    return user;
}

- (User *)dbRefreshUserWithServerUser:(ServerUser *)aServerUser save:(BOOL)save {
    User *user = [self userWithID:aServerUser.userID];
    if(!user) {
        user = [User MR_createEntity];
        user.baseURL = self.baseURL.absoluteString;
    }
    [user fillWithServerUser:aServerUser];
    
    if(save) {
        [user.managedObjectContext MR_saveToPersistentStoreAndWait];
    }
    
    return user;
}

- (User *)dbLogoutWithSave:(BOOL)save {
    User *user = self.appUser;
    user.signedServer = nil;
    
    if(save) {
        [user.managedObjectContext MR_saveToPersistentStoreAndWait];
    }

    return user;
}


@end
