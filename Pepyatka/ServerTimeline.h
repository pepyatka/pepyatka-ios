#import <Foundation/Foundation.h>
#import "ServerUser.h"
#import "ServerTimelineStat.h"
#import "ServerPost.h"


@interface ServerTimeline : NSObject {
    NSMutableArray *orderedPosts;
    NSMutableDictionary *postsMap; // NSString -> ServerPost
}

@property (nonatomic, strong) NSString *timelineID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) ServerUser *user;
@property (nonatomic, strong) ServerTimelineStat *statistics;


@property (nonatomic, strong) NSArray *subscribers;
@property (nonatomic, strong) NSArray *subscriptions;
@property (readonly) NSArray *orderedPosts;


- (void)clearAllPosts;

- (void)fillWithDictionary:(NSDictionary *)d;
- (NSUInteger)refreshAndReturnNewPostsWithTimeline:(ServerTimeline *)t;

@end
