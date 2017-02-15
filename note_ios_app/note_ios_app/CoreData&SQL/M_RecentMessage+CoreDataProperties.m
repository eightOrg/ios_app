//
//  M_RecentMessage+CoreDataProperties.m
//  note_ios_app
//
//  Created by 江弘 on 2017/2/15.
//  Copyright © 2017年 江弘. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "M_RecentMessage+CoreDataProperties.h"

@implementation M_RecentMessage (CoreDataProperties)

+ (NSFetchRequest<M_RecentMessage *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"M_RecentMessage"];
}

@dynamic recent_message_time;
@dynamic recent_message_num;
@dynamic recentMessage_user;

@end
