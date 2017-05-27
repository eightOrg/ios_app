//
//  JH_ViewModelFactory.h
//  haoqibaoyewu
//
//  Created by hyjt on 2017/3/1.
//  Copyright © 2017年 jianghong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JH_RuntimeTool.h"
typedef NS_ENUM(NSInteger,JHRefreshState){
    //头部刷新完毕
    //尾部刷新完毕还有更多
    //尾部刷新完毕没有更多了
    //全部停止
    JHRefreshStateHeader,
    JHRefreshStateFooter,
    JHRefreshStateHeaderNoMore,
    JHRefreshStateFooterNoMore,
    JHRefreshStateAll
};

/**
 这里作为viewModel的基类，定义抽象接口，目前改了部分的MVC转MVVM后续有心情再改吧。
 */
@interface JH_ViewModelFactory : NSObject
/**
 是否需要下拉加载刷新
 
 @return BOOL
 */
-(BOOL )JH_isNeedPullHeader;
/**
 是否需要尾部加载更多
 
 @return BOOL
 */
-(BOOL )JH_isNeedFooter;

/**
 加载页面数据
 */
-(void)JH_loadTableDataWithData:(NSDictionary *)data :(void(^)())resultBlock;
/**
 加载数据并返回
 
 @param data 请求的数据
 @param completionblock 成功
 @param errorblock 失败
 */
-(void)JH_loadTableDataWithData:(NSDictionary *)data completionHandle:(void (^)(id result))completionblock errorHandle:(void (^)(NSError * error))errorblock;

/**
 获取列表数据
 */
-(void)JH_loadDataWithPage:(NSInteger)page data:(NSMutableDictionary *)data completionHandle:(void (^)(id result))completionblock errorHandle:(void (^)(NSError * error))errorblock ressultHandle:(void (^)(JHRefreshState refreshSate))resultBlock;
/**
 将行数放回给VC
 
 @return 行数
 */
-(NSInteger)JH_numberOfSection;
/**
 将列数放回给VC
 
 @param section 行数
 @return 列数
 */
-(NSInteger)JH_numberOfRow:(NSInteger)section;
/**
 直接放回cell给VC
 
 @param indexPath indexPath
 @return cell
 */
-(UITableViewCell *)JH_setUpTableViewCell:(NSIndexPath *)indexPath;


/**
 传递table返回cell

 @param tableView tableview
 @param indexPath indexpatn
 @return cell
 */
-(UITableViewCell *)JH_setUpTableViewCell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

/**
 创建tableView头部视图
 @return view
 */
-(UIView *)JH_setUpTableHeader;
/**
 创建分组头视图
 
 @param section NSIndexPath
 @return view
 */
-(UIView *)JH_setUpTableSectionHeader:(NSInteger)section;
/**
 创建分组尾视图
 
 @param section NSIndexPath
 @return view
 */
-(UIView *)JH_setUpTableSectionFooter:(NSInteger)section;
/**
 返回单元格高度
 
 @param indexPath NSIndexPath
 @return 高度
 */
-(CGFloat)JH_heightForCell:(NSIndexPath *)indexPath;

/**
 返回头部高度
 
 @param section 分组数
 @return 高度
 */
-(CGFloat)JH_heightForSectionHeader:(NSInteger)section;

/**
 返回尾部高度
 
 @param section 分组数
 @return 高度
 */
-(CGFloat)JH_heightForSectionFooter:(NSInteger)section;

/**
 选中并push到下一个页面

 @param indexPath NSIndexPath
 @param vcName vcName
 @param dic 传递的数据
 @param nav navigation
 */
-(void)didSelectRowAndPush:(NSIndexPath *)indexPath vcName:(NSString *)vcName dic:(NSDictionary *)dic nav:(UINavigationController *)nav;
/**
 选中之后处理完事件返回
 
 @param completionBlock completionBlock
 */
-(void)disSelectRowWithIndexPath:(NSIndexPath *)indexPath WithHandle:(void(^)())completionBlock;
@end
