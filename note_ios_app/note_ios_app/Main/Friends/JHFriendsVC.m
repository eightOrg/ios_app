//
//  JHFriendsVC.m
//  note_ios_app
//
//  Created by 江弘 on 2016/11/1.
//  Copyright © 2016年 江弘. All rights reserved.
//

#import "JHFriendsVC.h"
#import "JHChildFriendsVC.h"
#import "JHChildMessageVC.h"
@interface JHFriendsVC ()

@end

@implementation JHFriendsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self _setChildVC];
    [self _creatSegmentView];
    [self _creatLeftMenuButton];
}
/**
 创建左侧打开菜单的按钮
 */
-(void)_creatLeftMenuButton{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"菜单"] style:0 target:self action:@selector(_postNotification)];
    
}
/**
 发送通知同于侧滑页面的打开
 */
-(void)_postNotification{
    [[NSNotificationCenter defaultCenter]postNotificationName:JH_SlideViewShowNotification object:nil];
}
/**
 创建子控制器
 */
-(void)_setChildVC{
    JHChildMessageVC *first = [[JHChildMessageVC alloc] init];
    JHChildFriendsVC *second = [[JHChildFriendsVC alloc] init];
    
    [self addChildViewController:first];
    [self addChildViewController:second];
}
/**
 创建分段选择按钮
 */
-(void)_creatSegmentView{
    
    UISegmentedControl *control = [[UISegmentedControl alloc] initWithItems:@[@"消息",@"好友"]];
    [control setTintColor:BaseTextColor];
    control.frame = CGRectMake(0, 0, 60, 30);
    self.navigationItem.titleView = control;
    control.selectedSegmentIndex = 0;
    [control addTarget:self action:@selector(segmentChangeAction:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview: self.childViewControllers[0].view];
    
}

/**
 切换试图
 */
-(void)segmentChangeAction:(UISegmentedControl *)control{
    NSInteger index = control.selectedSegmentIndex;
    
    [self.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == index) {
            
        }else{
            
            [obj removeFromSuperview];
        }
        
    }];
    [self.view addSubview: self.childViewControllers[index].view];
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
