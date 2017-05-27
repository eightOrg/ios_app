//
//  JHBaseViewController.m
//  note_ios_app
//
//  Created by 江弘 on 2016/10/29.
//  Copyright © 2016年 江弘. All rights reserved.
//

#import "JHBaseViewController.h"

@interface JHBaseViewController ()

@end

@implementation JHBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置CGRectZero从导航栏下开始计算
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}


/**
 断网的时候调用这个方法
 */
-(void)_creatNoNetWorkView{
    //1.移除视图
    for (UIView *view in self.view.subviews) {
        [view removeFromSuperview];
    }
    //2.添加按钮
    UIButton *button = [UIButton new];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.equalTo(@100);
        make.height.equalTo(@40);
    }];
    button.backgroundColor = BaseColor;
    [button setTitle:@"重新加载" forState:0];
    [button setTitleColor:[UIColor whiteColor] forState:0];
    [button addTarget:self action:@selector(_reloadAction) forControlEvents:UIControlEventTouchUpInside];
    button.layer.cornerRadius = 5;
    //添加提示label
    UILabel *label = [UILabel new];
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.equalTo(self.view);
        make.bottom.equalTo(button.mas_top).offset(-10);
    }];
    label.text          = @"您的网络好像不太给力，请稍后再试";
    label.textColor     = [UIColor lightGrayColor];
    label.font          = [UIFont systemFontOfSize:15];
    label.textAlignment = NSTextAlignmentCenter;
    
}

/**
 重新加载这个视图
 */
-(void)_reloadAction{
    //1.移除视图
    for (UIView *view in self.view.subviews) {
        [view removeFromSuperview];
    }
    [self viewDidLoad];
    
}
/**
 push视图操作
 */
-(void)_pushViewController:(UIViewController *)controller{
    controller.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:controller animated:YES];
    
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
