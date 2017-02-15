//
//  M_RecentMessage+CoreDataProperties.h
//  note_ios_app
//
//  Created by 江弘 on 2017/2/15.
//  Copyright © 2017年 江弘. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "M_RecentMessage+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface M_RecentMessage (CoreDataProperties)

+ (NSFetchRequest<M_RecentMessage *> *)fetchRequest;

@property (nonatomic) int64_t recent_message_time;
@property (nonatomic) int64_t recent_message_num;
@property (nullable, nonatomic, retain) M_UserInfo *recentMessage_user;

@end

NS_ASSUME_NONNULL_END
