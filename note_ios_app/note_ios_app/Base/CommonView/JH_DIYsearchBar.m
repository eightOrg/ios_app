//
//  JH_DIYsearchBar.m
//  haoqibaoyewu
//
//  Created by hyjt on 16/7/21.
//  Copyright © 2016年 jianghong. All rights reserved.
//

#import "JH_DIYsearchBar.h"

@implementation JH_DIYsearchBar
/**
 自定义搜索框
 */
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _DIYAttribute];
    }
    return self;
}
/**
 获取UISearchBarBackground这个视图并将其从视图中移除（灰色的背景框）
 */
-(void)_DIYAttribute{
    /**
     *  iOS7之后在SearchBar之后添加一层UIview，UIview之后才有相对应的视图子类
     */
   
    for (UIView *subview in self.subviews) {
        if ([subview isKindOfClass:[UIView class]]) {
            for (UIView *nextView in subview.subviews) {
                
                if ([nextView isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
                    [nextView removeFromSuperview];

                }
                /**
                 *  //实验证明此位置在遍历时执行顺序在background后
                 *  @param @"UINavigationButton"
                 *  @return 修改系统控件
                 */
//                if ([nextView isKindOfClass:NSClassFromString(@"UINavigationButton")]) {
//                    UIButton *button = (UIButton *)nextView;
//                    [button setTitle:@"取消" forState:0];
//                    break;
//                }
            }
        }
    }
    
}
//
//- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar;{
//    self.showsCancelButton = YES;
//}// called when text starts editing
//
//- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar;   {
//    self.showsCancelButton = NO;
//}// called when text ends editing
//- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText;{
//    
//}// called when text changes (including clear)
//
//- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar;  {
//    
//}// called when keyboard search button pressed
//- (void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar __TVOS_PROHIBITED;{
//    
//}// called when bookmark button pressed
//- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar __TVOS_PROHIBITED; {
//    [self.viewController resignFirstResponder];
//    
//}// called when cancel
@end
