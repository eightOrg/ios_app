//
//  M_UserInfo+CoreDataProperties.h
//  note_ios_app
//
//  Created by 江弘 on 2017/2/15.
//  Copyright © 2017年 江弘. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "M_UserInfo+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface M_UserInfo (CoreDataProperties)

+ (NSFetchRequest<M_UserInfo *> *)fetchRequest;

@property (nonatomic) int64_t user_id;
@property (nullable, nonatomic, copy) NSString *user_name;
@property (nullable, nonatomic, copy) NSString *user_portrail;
@property (nullable, nonatomic, retain) M_RecentMessage *user_recentMessage;
@property (nullable, nonatomic, retain) M_MessageList *user_message;

@end

NS_ASSUME_NONNULL_END
