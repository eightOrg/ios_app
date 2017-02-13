//
//  JHChatFriendGroupView.h
//  note_ios_app
//
//  Created by 江弘 on 2017/2/13.
//  Copyright © 2017年 江弘. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JHChatFriendGroupView;
@protocol JHCahtFriendGroupDelegate <NSObject>


/**
 设置JHChatFriendGroupView代理用于视图单元格的展开和收起

 @param view JHChatFriendGroupView
 @param isFold 是否折叠
 */
-(void)_setGroupFold:(JHChatFriendGroupView *)view byIdentity:(BOOL)isFold;

@end
@interface JHChatFriendGroupView : UIView

@property(nonatomic,weak)id<JHCahtFriendGroupDelegate> delegate;

@property(nonatomic,assign)NSInteger section;
/**
 创建头部视图

 @param frame frame
 @param title label的标题
 @return self
 */
- (instancetype)initWithFrame:(CGRect)frame withTitle:(NSString *)title withFold:(BOOL)isFold;
@end
