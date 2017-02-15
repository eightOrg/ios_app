//
//  JH_ChatMessageManager.h
//  note_ios_app
//
//  Created by 江弘 on 2017/2/15.
//  Copyright © 2017年 江弘. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "M_UserInfo+CoreDataClass.h"
#import "M_MessageList+CoreDataClass.h"
#import "M_RecentMessage+CoreDataClass.h"
@interface JH_ChatMessageManager : NSObject
@property (nonatomic, strong, readonly)NSManagedObjectContext

*managedObjectContext;

@property (nonatomic, strong, readonly) NSManagedObjectModel *managedObjectModel;

@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (JH_ChatMessageManager *)sharedInstance;

- (void)saveContext;
@end
