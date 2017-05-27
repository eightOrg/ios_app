//
//  JH_ViewModelFactory.m
//  haoqibaoyewu
//
//  Created by hyjt on 2017/3/1.
//  Copyright © 2017年 jianghong. All rights reserved.
//

#import "JH_ViewModelFactory.h"

@implementation JH_ViewModelFactory
/**
 *  加载数据
 */
-(void)JH_loadTableDataWithData:(NSDictionary *)data :(void(^)())resultBlock;{
    
}

/**
 加载数据并返回

 @param data 请求的数据
 @param completionblock 成功
 @param errorblock 失败
 */
-(void)JH_loadTableDataWithData:(NSDictionary *)data completionHandle:(void (^)(id result))completionblock errorHandle:(void (^)(NSError * error))errorblock{
    
}

/**
 获取列表数据
 */
-(void)JH_loadDataWithPage:(NSInteger)page data:(NSMutableDictionary *)data completionHandle:(void (^)(id result))completionblock errorHandle:(void (^)(NSError * error))errorblock ressultHandle:(void (^)(JHRefreshState))resultBlock{
    
}
/**
 是否需要下拉加载刷新
 
 @return BOOL
 */
-(BOOL )JH_isNeedPullHeader{
    return NO;
}
/**
 是否需要尾部加载更多
 
 @return BOOL
 */
-(BOOL )JH_isNeedFooter{
    return NO;
}
/**
 获取列表数据和刷新状态
 */
-(void)JH_loadDataWithPage:(NSInteger)page  data:(NSMutableDictionary *)data ressultHandle:(void (^)(JHRefreshState))resultBlock{
    
}

/**
 将行数放回给VC
 
 @return 行数
 */
-(NSInteger)JH_numberOfSection{
    return 1;
}
/**
 将列数放回给VC
 
 @param section 行数
 @return 列数
 */
-(NSInteger)JH_numberOfRow:(NSInteger)section{
    return 0;
}
/**
 直接放回cell给VC
 
 @param indexPath indexPath
 @return cell
 */
-(UITableViewCell *)JH_setUpTableViewCell:(NSIndexPath *)indexPath{
    return nil;
}
/**
 创建tableView头部视图
 
 @return view
 */
-(UIView *)JH_setUpTableHeader{
    return nil;
}
/**
 创建分组头视图
 
 @param section NSIndexPath
 @return view
 */
-(UIView *)JH_setUpTableSectionHeader:(NSInteger)section{
    return nil;
}
/**
 创建分组尾视图
 
 @param section NSIndexPath
 @return view
 */
-(UIView *)JH_setUpTableSectionFooter:(NSInteger)section{
    return nil;
}
/**
 返回单元格高度
 
 @param indexPath NSIndexPath
 @return 高度
 */
-(CGFloat)JH_heightForCell:(NSIndexPath *)indexPath{
    return 0.1;
}

/**
 返回头部高度
 
 @param section 分组数
 @return 高度
 */
-(CGFloat)JH_heightForSectionHeader:(NSInteger)section{
    return 0.1;
}

/**
 返回尾部高度
 
 @param section 分组数
 @return 高度
 */
-(CGFloat)JH_heightForSectionFooter:(NSInteger)section{
    return 0.1;
}
/**
 创建分组头视图
 
 @param section NSIndexPath
 @return view
 */
-(UIView *)JH_setUpTableHeader:(NSInteger)section{
    return nil;
}
/**
 选中并push到下一个页面
 
 @param indexPath NSIndexPath
 @param vcName vcName
 @param dic 传递的数据
 @param nav navigation
 */
-(void)didSelectRowAndPush:(NSIndexPath *)indexPath vcName:(NSString *)vcName dic:(NSDictionary *)dic nav:(UINavigationController *)nav{
    [JH_RuntimeTool runtimePush:vcName dic:dic nav:nav];
    
}

/**
 选中之后处理完事件返回

 @param completionBlock completionBlock
 */
-(void)disSelectRowWithIndexPath:(NSIndexPath *)indexPath WithHandle:(void(^)())completionBlock{
    
}


@end
