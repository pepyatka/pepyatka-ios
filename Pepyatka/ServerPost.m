#import "ServerPost.h"

@implementation ServerPost

- (void)fillFromDictionary:(NSDictionary *)d {
    if(!d) {
        return;
    }
    
    self.postID = [d[@"id"] noNullObject];
    self.body = [d[@"body"] noNullObject];
    self.createdAt = [(NSNumber *)[d[@"createdAt"] noNullObject] millisecondsSince1970Date];
    self.updatedAt = [(NSNumber *)[d[@"updatedAt"] noNullObject] millisecondsSince1970Date];
#warning todo: comments
#warning todo: attachments
#warning todo: likes
    
    
    ServerUser *su = [ServerUser new];
    NSDictionary *rawUser = [d[@"createdBy"] noNullObject];
    [su fillFromDictionary:rawUser];
    self.createdBy = su;
    
    NSArray *rawGroups = [d[@"groups"] noNullObject];
    if([rawGroups isKindOfClass:[NSArray class]]) {
        NSArray *groups = [rawGroups map:^ServerUser *(NSDictionary *rawUser) {
            ServerUser *group = [ServerUser new];
            if([rawGroups isKindOfClass:[NSDictionary class]]) {
                [group fillFromDictionary:rawUser];
            }
            return group;
        }];
        
        self.groups = groups;
    }
    
}

- (void)refreshWithPost:(ServerPost *)p {
    self.postID = p.postID;
    self.body = p.body;
    self.createdAt = p.createdAt;
    self.updatedAt = p.updatedAt;
    self.comments = p.comments;
    self.attachments = p.attachments;
    self.createdBy = p.createdBy;
    self.groups = p.groups;
}


- (NSString *)description {
    return [NSString stringWithFormat:@"%@ %@ %@", [super description], self.createdAt, self.postID];
}


@end




//{
//    "id": "88699b63-48b9-4ca5-b4f8-02909b3f4507",
//    "body": "Hello world",
//    "createdAt": 1380398266250,
//    "updatedAt": 1380398266250,
//    "comments": [],
//    "attachments": [],
//    "likes": [],
//    "createdBy": {
//        "id": "0b1bd0dc-9f10-4002-bcff-3cc7e6e8c02e",
//        "username": "anonymous",
//        "info": {
//            "screenName": "anonymous"
//        }
//    },
//    "groups": [
//               {
//                   "id": "0b1bd0dc-9f10-4002-bcff-3cc7e6e8c02e",
//                   "username": "anonymous",
//                   "info": {
//                       "screenName": "anonymous"
//                   }
//               }
//               ]
//}