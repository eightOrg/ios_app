//
//  JH_SearchView.h
//  haoqibaoyewu
//
//  Created by hyjt on 16/7/21.
//  Copyright © 2016年 jianghong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JH_SearchView;
@protocol JHDIYSearchBarFDelegate <NSObject>

/**
 当输入文字改变的代理

 @param searchbar JH_SearchView
 */
-(void)_searchTextDidChange:(JH_SearchView *)searchbar;

/**
 当点击搜索的代理

 @param searchbar JH_SearchView
 */
-(void)_searchBarSearch:(JH_SearchView *)searchbar;
@end

@interface JH_SearchView : UISearchBar
@property(nonatomic ,weak)id<JHDIYSearchBarFDelegate> JHdelegate;
/**
 自定义搜索框
 */
- (instancetype)initWithFrame:(CGRect)frame withPlaceHold:(NSString *)placehold;
@end
