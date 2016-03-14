//
//  LYFLoginRegisterViewController.m
//  Lyf_BaiSi
//
//  Created by 罗元丰 on 16/2/16.
//  Copyright © 2016年 罗元丰. All rights reserved.
//

#import "LYFLoginRegisterViewController.h"
#import "TTFriendsViewController.h"
#import "TTResetPwdViewController.h"

#import <AVOSCloud/AVOSCloud.h>
#import <RongIMKit/RongIMKit.h>

@interface LYFLoginRegisterViewController () <UITextFieldDelegate>

/** 登录注册状态切换按钮 */
@property (weak, nonatomic) IBOutlet UIButton *lrBtn;

/** 返回按钮 */
@property (weak, nonatomic) IBOutlet UIButton *backBtn;

/** 用户名输入框 */
@property (weak, nonatomic) IBOutlet UITextField *userNameField;

/** 密码输入框 */
@property (weak, nonatomic) IBOutlet UITextField *pwdField;

/** 设置用户名 */
@property (weak, nonatomic) IBOutlet UITextField *setUnField;

/** 设置密码 */
@property (weak, nonatomic) IBOutlet UITextField *setPwd;

/** 登录框距离控制器view左边的间距 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginViewLeftMargin;

/** 是否正在显示注册模块 */
@property (nonatomic, assign) BOOL isShowingRegisterView;

@end

NSInteger k = 0;

@implementation LYFLoginRegisterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupLoginReg];
    
    self.navigationController.navigationBarHidden = YES;
}

#pragma mark - 登录注册页面的基础设置
- (void)setupLoginReg
{
    self.isShowingRegisterView = NO;
    
    [self.backBtn addTarget: self action: @selector(backAction) forControlEvents: UIControlEventTouchUpInside];
    
    self.userNameField.delegate = self;
    self.pwdField.delegate = self;
    self.setUnField.delegate = self;
    self.setPwd.delegate = self;
}

#pragma mark - 更改状态栏前景颜色
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - 登录/注册状态的切换
- (IBAction)showLoginRegisterAction:(UIButton *)sender
{
    //退出键盘
    [self.view endEditing: YES];
    
    if(self.isShowingRegisterView == NO)
    {
        self.loginViewLeftMargin.constant = -self.view.width;
        [sender setTitle: @"已有账号？" forState: UIControlStateNormal];
    }
    else
    {
        self.loginViewLeftMargin.constant = 0;
        [sender setTitle: @"注册账号" forState: UIControlStateNormal];
    }
    [UIView animateWithDuration: 0.3 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.isShowingRegisterView = !self.isShowingRegisterView;
    }];
}

#pragma mark - 注册x
- (IBAction)registerAction:(UIButton *)sender
{
    BOOL result = [self checkUserInfo];
    if(!result)
    {
        return;
    }
    
    [SVProgressHUD showWithStatus:@"正在注册"];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    
    __block BOOL isReged = NO;
    AVQuery *query = [AVQuery queryWithClassName:@"TT_User"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        for(AVObject *obj in objects)
        {
            if([obj[@"userName"] isEqualToString:self.setUnField.text])
            {
                isReged = YES;
            }
        }
        if(!isReged && k == 0)
        {
            TTLog(@"-- <<<< 开始注册 >>>> --");
            k++;
            AVObject *testObject = [AVObject objectWithClassName:@"TT_User"];
            [testObject setObject:self.setUnField.text forKey:@"userName"];
            [testObject setObject:self.setUnField.text forKey:@"userId"];
            [testObject setObject:self.setPwd.text forKey:@"password"];
            UIImage *defaultPhoto = [UIImage imageNamed:@"user_image"];
            NSData *data = UIImagePNGRepresentation(defaultPhoto);
            AVFile *file = [AVFile fileWithData:data];
            [testObject setObject:file forKey:@"userPhoto"];
            [testObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if(succeeded)
                {
                    [self showRegSuccessAlert];
                    AVObject *userObj = [AVObject objectWithClassName:self.setUnField.text];
                    [userObj setObject:@"意见反馈" forKey:@"friend"];
                    [userObj setObject:@"意见反馈" forKey:@"userId"];
                    UIImage *defaultPhoto = [UIImage imageNamed:@"user_image"];
                    NSData *data = UIImagePNGRepresentation(defaultPhoto);
                    AVFile *file = [AVFile fileWithData:data];
                    [userObj setObject:file forKey:@"userPhoto"];
                    
                    [userObj saveInBackground];
                }
                else
                {
                    TTLog(@"%@", error);
                }
            }];
        }
        else if(isReged)
        {
            [self showRegFailedAlert];
        }
    }];
}

- (BOOL)checkUserInfo
{
    if([self.setUnField.text isEqualToString:@""] || [self.setPwd.text isEqualToString:@""])
    {
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"注册失败" message:@"用户名和密码不能为空~" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleCancel handler:nil];
        [ac addAction:confirm];
        [self presentViewController:ac animated:YES completion:nil];
        return NO;
    }
    else
    {
        NSString *patternForName = @"^[A-Za-z]{4,8}$";
        NSPredicate *predForName = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", patternForName];
        
        NSString *patternForPwd = @"^[A-Za-z0-9]{4,12}$";
        NSPredicate *predForPwd = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", patternForPwd];
        
        BOOL checkName = [predForName evaluateWithObject:self.setUnField.text];
        if(!checkName)
        {
            UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"注册失败" message:@"请设置用户名为4~8位的英文字母组合并区分大小写" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleCancel handler:nil];
            [ac addAction:confirm];
            [self presentViewController:ac animated:YES completion:nil];
        }
        
        BOOL checkPwd = [predForPwd evaluateWithObject:self.setPwd.text];
        if(!checkPwd)
        {
            UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"注册失败" message:@"密码为4~12位且只能包含大小写字母与数字中的一种或多种" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleCancel handler:nil];
            [ac addAction:confirm];
            [self presentViewController:ac animated:YES completion:nil];
        }
        
        if(checkName && checkPwd)
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
}

- (void)showRegSuccessAlert
{
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"注册成功！" message:@"我们建议您设置一个密保问题以方便找回密码~" preferredStyle:UIAlertControllerStyleAlert];
    [ac addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请设置密保问题";
    }];
    [ac addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请设置答案";
    }];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self showLoginRegisterAction:self.lrBtn];
        UITextField *qField = [ac.textFields firstObject];
        UITextField *aField = [ac.textFields lastObject];
        AVQuery *q = [[AVQuery alloc] initWithClassName:@"TT_User"];
        [q findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            for(AVObject *o in objects)
            {
                if([o[@"userId"] isEqualToString:self.setUnField.text])
                {
                    [o setObject:qField.text forKey:@"question"];
                    [o setObject:aField.text forKey:@"answer"];
                    [o saveInBackground];
                }
            }
        }];
        k = 0;
    }];
    [ac addAction:confirm];
    [SVProgressHUD dismiss];
    [self presentViewController:ac animated:YES completion:nil];
}

- (void)showRegFailedAlert
{
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"注册失败" message:@"该用户名已存在" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        k = 0;
    }];
    [ac addAction:confirm];
    [SVProgressHUD dismiss];
    [self presentViewController:ac animated:YES completion:nil];
}

#pragma mark - 登录
- (IBAction)loginAction:(UIButton *)sender
{
    AVQuery *query = [AVQuery queryWithClassName:@"TT_User"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        for(AVObject *obj in objects)
        {
            if([obj[@"userName"] isEqualToString:self.userNameField.text] && [obj[@"password"] isEqualToString:self.pwdField.text])
            {
                TTLog(@"lc登录成功！");
                self.flag(YES, self.userNameField.text, @"fuck");
                NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                [ud setObject:self.self.userNameField.text forKey:@"userId"];
                [ud setObject:self.pwdField.text forKey:@"password"];
                [self dismissViewControllerAnimated: YES completion: nil];
                return;
            }
        }
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"登录失败" message:@"用户名或密码错误" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleCancel handler:nil];
        [ac addAction:confirm];
        [self presentViewController:ac animated:YES completion:nil];
        if(error)
        {
            TTLog(@"%@", error);
        }
    }];
}

#pragma mark - 返回按钮事件
- (void)backAction
{
    self.flag(NO, nil, @"no");
    [self dismissViewControllerAnimated: YES completion: nil];
}

#pragma mark - <UItextFieldDelegate>
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - 点击忘记密码的响应事件
- (IBAction)forgetPassword:(UIButton *)sender
{
    TTResetPwdViewController *rvc = [[TTResetPwdViewController alloc] init];
    [self presentViewController:rvc animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
