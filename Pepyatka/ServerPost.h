#import <Foundation/Foundation.h>
#import "ServerUser.h"

@interface ServerPost : NSObject

@property (nonatomic, strong) NSString *postID;
@property (nonatomic, strong) NSString *body;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) NSDate *updatedAt;

@property (nonatomic, strong) ServerUser *createdBy;


@property (nonatomic, strong) NSArray *comments;
@property (nonatomic, strong) NSArray *attachments;
@property (nonatomic, strong) NSArray *likes;
@property (nonatomic, strong) NSArray *groups;

- (void)fillFromDictionary:(NSDictionary *)d;
- (void)refreshWithPost:(ServerPost *)p;

@end
