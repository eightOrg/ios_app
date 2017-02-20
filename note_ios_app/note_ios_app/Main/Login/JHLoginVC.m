//
//  JHLoginVC.m
//  note_ios_app
//
//  Created by 江弘 on 2016/10/29.
//  Copyright © 2016年 江弘. All rights reserved.
//

#import "JHLoginVC.h"
#import "JH_UserLoginApi.h"
#import "AppDelegate.h"
#import "JHBaseRootVC.h"
@interface JHLoginVC ()
{
    UITextField *_accountTextField;
    UITextField *_passwordTextField;
}
@end

@implementation JHLoginVC

/**
 账号、密码、手机验证码、注册
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
    self.view.backgroundColor = [UIColor colorWithWhite:0.92 alpha:1];
    [self _creatTextField];
    [self _creatLoginRegister];
}
/**
 账号和密码的输入框
 */
-(void)_creatTextField{
    
    //输入框白色背景图
    UIView *baseView = [[UIView alloc]init];
    baseView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:baseView];
    
    _accountTextField = [JHBaseTextField new];
    _passwordTextField = [JHBaseTextField new];
    _accountTextField.placeholder = @"请输入账号";
    _passwordTextField.placeholder = @"请输入密码";
    
    [baseView addSubview:_accountTextField];
    [baseView addSubview:_passwordTextField];
   
    
    //添加一条线和忘记密码
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = self.view.backgroundColor;
    [baseView addSubview:lineView];
    
    
    UIButton *forgetButton = [UIButton new];
    [baseView addSubview:forgetButton];
    [forgetButton setTitle:@"忘记密码?" forState:0];
    [forgetButton setTitleColor:[UIColor lightGrayColor] forState:0];
    forgetButton.titleLabel.font = [UIFont systemFontOfSize:10];
    [forgetButton addTarget:self action:@selector(_forgetPassword) forControlEvents:UIControlEventTouchUpInside];
    
    //背景
    [baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@100);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view).with.offset(20);
    }];
    //账号
    [_accountTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@50);
        make.left.equalTo(baseView).with.offset(10);
        make.right.equalTo(baseView).with.offset(-70);
        make.top.equalTo(baseView);
    }];
    //密码
    [_passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@50);
        make.left.equalTo(_accountTextField);
        make.right.equalTo(_accountTextField);
        make.top.equalTo(baseView).with.offset(50);
    }];
    //分割线
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@0.5);
        make.left.equalTo(baseView).with.offset(10);
        make.right.equalTo(baseView).with.offset(-10);
        make.center.equalTo(baseView);
    }];
    //忘记密码
    [forgetButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@50);
        make.height.equalTo(@20);
        make.centerY.equalTo(_passwordTextField);
        make.left.equalTo(_passwordTextField.mas_right).with.offset(0);
    }];
}
/**
 忘记密码
 */
-(void)_forgetPassword{
    
}
/**
 登录注册
 */
-(void)_creatLoginRegister{
    JHBaseSubmitButton *loginButton = [JHBaseSubmitButton new];
    [loginButton setTitle:@"登录" forState:0];
    [loginButton setTitleColor:BaseTextColor forState:0];
    [loginButton setBackgroundColor:BaseColor];
    [loginButton addTarget:self action:@selector(_loginAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
    
    JHBaseSubmitButton *registerButton = [JHBaseSubmitButton new];
    [registerButton setTitle:@"注册记e账号" forState:0];
    [registerButton setTitleColor:BaseColor forState:0];
    [registerButton setBackgroundColor:BaseTextColor];
    [registerButton addTarget:self action:@selector(_registerAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerButton];
    
    [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(100+20+20);
        make.left.equalTo(self.view).with.offset(20);
        make.right.equalTo(self.view).with.offset(-20);
        make.height.equalTo(@40);
    }];
    
    [registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(loginButton.mas_bottom).with.offset(20);
        make.left.equalTo(loginButton);
        make.right.equalTo(loginButton);
        make.height.equalTo(@40);
    }];
}
/**
 登录
 */
-(void)_loginAction{
//    JH_UserLoginApi *loginRequest = JH_UserLoginApi.new;
//    loginRequest.mobile = _accountTextField.text;
//    loginRequest.password = _passwordTextField.text;
//    [loginRequest startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
//        NSLog(@"%@",request.responseJSONObject);
//        NSLog(@"%@",request.responseJSONObject[@"msg"]);
//        
//    } failure:^(__kindof YTKBaseRequest *request) {
//        
//    }];
    [UIView animateWithDuration:JH_UIViewAnimation animations:^{
        self.view.alpha = 0;
    } completion:^(BOOL finished) {
        
        //设置程序主窗口
        JHBaseRootVC *root = [[JHBaseRootVC alloc] init];
        
        AppDelegate *appdelegate = APPDELEGATE;
        appdelegate.window.rootViewController = root;
    }];
    
}
/**
 注册
 */
-(void)_registerAction{
    
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
