#import <Foundation/Foundation.h>

@interface ServerUser : NSObject

@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *screenName;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSNumber *receiveEmails;
@property (nonatomic, strong) NSArray *rss;

- (void)fillFromDictionary:(NSDictionary *)d;

@end





@interface ServerUser (Virtual)

@property (readonly) BOOL isAnonymous;

+ (NSString *)anonymousUserName;

@end
