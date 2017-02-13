//
//  JHChatFriendSectionModel.h
//  note_ios_app
//
//  Created by 江弘 on 2017/2/13.
//  Copyright © 2017年 江弘. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHChatFriendRowModel.h"
@interface JHChatFriendSectionModel : NSObject
@property(nonatomic,copy)NSString * groupName;
@property(nonatomic,strong)NSArray *groupDetail;
@property(nonatomic,strong)NSMutableArray<JHChatFriendRowModel *> *rowModel;
@property(nonatomic,assign)BOOL isFold;
@end
