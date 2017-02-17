//
//  JHBaseRootVC.m
//  note_ios_app
//
//  Created by 江弘 on 2016/11/1.
//  Copyright © 2016年 江弘. All rights reserved.
//

#import "JHBaseRootVC.h"
#import "JHSlideView.h"
#import "JHBaseTabBar.h"
@interface JHBaseRootVC ()<UIGestureRecognizerDelegate>
{
    JHSlideView *_slideView;
    UIView *_sheetWindows;
}
@end

@implementation JHBaseRootVC

#define Width self.view.bounds.size.width*3/4
#define Height self.view.bounds.size.height
- (void)viewDidLoad {
    [super viewDidLoad];
    [self _addChildVC];
    [self _creatSlideView];
    [self _addPanGesture];
    [self _addCoverWindowsForTabbar];
    [self _addNotification];
    // Do any additional setup after loading the view.
}

/**
 添加通知（来自侧滑视图出现的通知）
 */
-(void)_addNotification{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(_slideViewShowAction) name:JH_SlideViewShowNotification object:nil];
}

/**
 打开侧滑视图
 */
-(void)_slideViewShowAction{
    
    _sheetWindows.hidden = NO;
    [UIView animateWithDuration:0.5 animations:^{
        
        [self.view.subviews objectAtIndex:0].transform = CGAffineTransformMakeTranslation(Width, 0);
        //同步平移量
        [self.view.subviews objectAtIndex:1].transform = CGAffineTransformMakeTranslation(Width, 0);
        _sheetWindows.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}
/**
 添加子控制器
 */
-(void)_addChildVC{
    JHBaseTabBar *tabbar = [[JHBaseTabBar alloc] init];
    [self addChildViewController:tabbar];
    [self.view addSubview:tabbar.view];
}

/**
 创建左侧滑动视图
 */

-(void)_creatSlideView{
    _slideView = [[JHSlideView alloc] initWithFrame:CGRectMake(-Width,0, Width, Height)];
    [self.view addSubview:_slideView];
    _slideView.backgroundColor = BaseTextColor;
    
}

/**
 给tabbar子控制器添加遮盖视图
 */
-(void)_addCoverWindowsForTabbar{
    _sheetWindows = [[UIWindow alloc] initWithFrame:self.view.bounds];
    _sheetWindows.backgroundColor = [UIColor colorWithRed:40/255.f green:40/255.f blue:40/255.f alpha:0.4];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_tapAction)];
    [_sheetWindows addGestureRecognizer:tap];
    [[self.view.subviews objectAtIndex:0] addSubview:_sheetWindows];
    _sheetWindows.hidden = YES;
    
}

/**
 点击遮罩视图
 */
-(void)_tapAction{
    [UIView animateWithDuration:0.5 animations:^{
        
        [self.view.subviews objectAtIndex:0].transform = CGAffineTransformIdentity;
        //同步平移量
        [self.view.subviews objectAtIndex:1].transform = CGAffineTransformIdentity;
        _sheetWindows.alpha = 0;
    } completion:^(BOOL finished) {
        _sheetWindows.hidden = YES;
    }];
}
/**
 添加拖动手势
 */
-(void)_addPanGesture{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(_panAction:)];
    pan.delegate = self;
    [self.view addGestureRecognizer:pan];
}
#pragma mark - 解决和tableView单元格左滑删除的手势冲突
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer

{
    
//    NSLog(@"当前手势:%@; 另一个手势:%@", gestureRecognizer, otherGestureRecognizer);
    if ([otherGestureRecognizer.view isKindOfClass:[UITableView class]]) {
        
        return NO;
    }
    return YES;
    
}
/**
 移动动作的实现
 @param pan   获取移动的数量级
 */
-(void)_panAction :(UIPanGestureRecognizer *)pan{
    //计算子控制器的数量，结果永远为1
    //    NSInteger number = self.childViewControllers.count;
    //    if (number>1) {
    //        return;
    //    }
    //判断子控制器的底部是否在页面上
    UITabBarController *tabbar = [self.childViewControllers firstObject];
    bool tabbarHidden = [tabbar.tabBar isHidden];
    if (tabbarHidden) {
        return;
    }
    
    // 1. 获取手指拖拽的时候, 平移的值
    CGPoint translation = [pan translationInView:[self.view.subviews objectAtIndex:0]];
    
    // 2. 让当前控件做响应的平移
    [self.view.subviews objectAtIndex:0].transform = CGAffineTransformTranslate([self.view.subviews objectAtIndex:0].transform, translation.x, 0);
    
    [self.view.subviews objectAtIndex:1].transform = CGAffineTransformTranslate([self.view.subviews objectAtIndex:0].transform, translation.x, 0);
    
    // 3. 每次平移手势识别完毕后, 让平移的值不要累加
    [pan setTranslation:CGPointZero inView:[self.view.subviews objectAtIndex:0]];
    
    //获取最右边范围
    CGAffineTransform  rightScopeTransform=CGAffineTransformTranslate(self.view.transform,[UIScreen mainScreen].bounds.size.width*0.75, 0);
    
    //    当移动到右边极限时
    if ([self.view.subviews objectAtIndex:0].transform.tx>rightScopeTransform.tx) {
        
        //        限制最右边的范围
        [self.view.subviews objectAtIndex:0].transform=rightScopeTransform;
        //        限制左侧view最右边的范围
        [self.view.subviews objectAtIndex:1].transform = CGAffineTransformTranslate([self.view.subviews objectAtIndex:0].transform, translation.x, 0);
        
        //        当移动到左边极限时
    }else if ([self.view.subviews objectAtIndex:0].transform.tx<0.0){
        
        //        限制最左边的范围
        [self.view.subviews objectAtIndex:0].transform=CGAffineTransformTranslate(self.view.transform,0, 0);
        //    限制左侧view最左边的范围
        [self.view.subviews objectAtIndex:1].transform=CGAffineTransformTranslate([self.view.subviews objectAtIndex:0].transform, translation.x, 0);
        
    }
    //    当托拽手势结束时执行
    if (pan.state == UIGestureRecognizerStateEnded)
    {
        [UIView animateWithDuration:0.2 animations:^{
            //判断与屏幕一半的大小比较自动平移
            if ([self.view.subviews objectAtIndex:0].frame.origin.x >[UIScreen mainScreen].bounds.size.width*0.5) {
                
                [self.view.subviews objectAtIndex:0].transform=rightScopeTransform;
                //同步平移量
                [self.view.subviews objectAtIndex:1].transform=CGAffineTransformTranslate([self.view.subviews objectAtIndex:0].transform, translation.x, 0);
                
            }else{
                
                [self.view.subviews objectAtIndex:0].transform = CGAffineTransformIdentity;
                //同步平移量
                [self.view.subviews objectAtIndex:1].transform=CGAffineTransformTranslate([self.view.subviews objectAtIndex:0].transform, translation.x, 0);
            }
        }];
    }
    
    if ([self.view.subviews objectAtIndex:0].transform.tx>0) {
        _sheetWindows.alpha = [self.view.subviews objectAtIndex:0].transform.tx/self.view.bounds.size.width*0.75;
        _sheetWindows.hidden = NO;
    }else{
        _sheetWindows.hidden = YES;
    }
    
    
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
