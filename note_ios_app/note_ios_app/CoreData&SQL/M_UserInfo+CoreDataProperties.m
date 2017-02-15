//
//  M_UserInfo+CoreDataProperties.m
//  note_ios_app
//
//  Created by 江弘 on 2017/2/15.
//  Copyright © 2017年 江弘. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "M_UserInfo+CoreDataProperties.h"

@implementation M_UserInfo (CoreDataProperties)

+ (NSFetchRequest<M_UserInfo *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"M_UserInfo"];
}

@dynamic user_id;
@dynamic user_name;
@dynamic user_portrail;
@dynamic user_recentMessage;
@dynamic user_message;

@end
