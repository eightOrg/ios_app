//
//  M_MessageList+CoreDataProperties.h
//  note_ios_app
//
//  Created by 江弘 on 2017/2/16.
//  Copyright © 2017年 江弘. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "M_MessageList+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface M_MessageList (CoreDataProperties)

+ (NSFetchRequest<M_MessageList *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *message_path;
@property (nullable, nonatomic, copy) NSString *message_text;
@property (nonatomic) int64_t message_time;
@property (nonatomic) int64_t message_type;
@property (nonatomic) BOOL message_isSelf;
@property (nonatomic) BOOL message_isShowTime;
@property (nullable, nonatomic, retain) M_UserInfo *message_user;

@end

NS_ASSUME_NONNULL_END
