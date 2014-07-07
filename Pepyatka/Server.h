//
//  Server.h
//  Pepyatka
//
//  Created by Mibori Shante on 02.07.14.
//  Copyright (c) 2014 DataArt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

@interface Server : NSManagedObject

@property (nonatomic, retain) NSString * baseURL;
@property (nonatomic, retain) NSArray *tags;
@property (nonatomic, retain) User *appUser;

@end
