#import <Foundation/Foundation.h>

@interface ServerTimelineStat : NSObject
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSNumber *posts;
@property (nonatomic, strong) NSNumber *likes;
@property (nonatomic, strong) NSNumber *discussions;
@property (nonatomic, strong) NSNumber *subscribers;
@property (nonatomic, strong) NSNumber *subscriptions;

- (void)fillWithDictionary:(NSDictionary *)d;

@end
