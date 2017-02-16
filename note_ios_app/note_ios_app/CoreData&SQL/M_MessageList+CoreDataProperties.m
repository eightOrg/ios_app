//
//  M_MessageList+CoreDataProperties.m
//  note_ios_app
//
//  Created by 江弘 on 2017/2/16.
//  Copyright © 2017年 江弘. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "M_MessageList+CoreDataProperties.h"

@implementation M_MessageList (CoreDataProperties)

+ (NSFetchRequest<M_MessageList *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"M_MessageList"];
}

@dynamic message_path;
@dynamic message_text;
@dynamic message_time;
@dynamic message_type;
@dynamic message_isSelf;
@dynamic message_user;

@end
