//
//  JHBaseTabBar.m
//  note_ios_app
//
//  Created by 江弘 on 2016/10/29.
//  Copyright © 2016年 江弘. All rights reserved.
//

#import "JHBaseTabBar.h"
#import "JHFriendsVC.h"
#import "JHNoteVC.h"
#import "JHSquareVC.h"
@interface JHBaseTabBar ()
{
    NSInteger _index;
}
@end

@implementation JHBaseTabBar

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self _setUpAllChildViewController];
    
}
/**
 *  添加所有子控制器方法
 */
- (void)_setUpAllChildViewController{
    /*
     设置标签栏选中默认颜色
     */
    self.tabBar.tintColor = BaseColor;
    self.tabBar.barTintColor = BaseTextColor;
    // 1.添加第一个控制器
    JHFriendsVC *home = [[JHFriendsVC alloc]init];
    // 2.添加第2个控制器
    JHNoteVC *education = [[JHNoteVC alloc]init];
    // 3.添加第3个控制器
    JHSquareVC *square = [[JHSquareVC alloc]init];
    
    NSArray *image_on_name = @[@"好友-on",@"笔记-on",@"广场-on"];
    NSArray *image_off_name = @[@"好友-off",@"笔记-off",@"广场-off"];
    NSArray *names = @[@"好友",@"笔记",@"广场"];
    
    NSArray *baseVC = @[home,education,square];
    
    
    //设置控制器
    for (int i = 0; i<names.count;i++ ) {
        
        [self _setUpOneChildViewController:baseVC[i] image:[UIImage imageNamed:image_off_name[i]] selectedImage:[UIImage imageNamed:image_on_name[i] ] title:names[i]];
    }
    
}
/**
 *  添加一个子控制器的方法（图片，选中图片，文字）
 */
- (void)_setUpOneChildViewController:(UIViewController *)viewController image:(UIImage *)image selectedImage:(UIImage *)selectedImage title:(NSString *)title{
    //导航--控制器
    UINavigationController *navC = [[UINavigationController alloc]initWithRootViewController:viewController];
    navC.tabBarItem.image = image;
#pragma - mark - 设置选中图片
    navC.tabBarItem.selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    viewController.title = title;
    viewController.navigationItem.title = title;
    
    [self addChildViewController:navC];
}
/**
 tabbar切换动画
 */
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    NSInteger selectIndex = [tabBar.items indexOfObject:item];
    if (selectIndex != _index) [self animationWithIndex:selectIndex];
}

- (void)animationWithIndex:(NSInteger) index {
    NSMutableArray *tabbarbuttonArray = [NSMutableArray array];
    for (UIView *tabBarButton in self.tabBar.subviews)
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")])
            [tabbarbuttonArray addObject:tabBarButton];
    CABasicAnimation *pulse = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    pulse.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pulse.duration = 0.08;
    pulse.repeatCount = 1;
    pulse.autoreverses = YES;
    pulse.fromValue = [NSNumber numberWithFloat:0.7];
    pulse.toValue = [NSNumber numberWithFloat:1.3];
    [[tabbarbuttonArray[index] layer] addAnimation:pulse forKey:nil];
    
    _index = index;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
