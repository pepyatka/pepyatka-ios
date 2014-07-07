//
//  User.h
//  Pepyatka
//
//  Created by Mibori Shante on 02.07.14.
//  Copyright (c) 2014 DataArt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Server;

@interface User : NSManagedObject

@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSNumber * receiveEmails;
@property (nonatomic, retain) NSArray *rss;
@property (nonatomic, retain) NSString * screenName;
@property (nonatomic, retain) NSString * userID;
@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSString * baseURL;
@property (nonatomic, retain) Server *signedServer;

@end
