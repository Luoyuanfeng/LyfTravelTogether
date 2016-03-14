//
//  TTResetPwdViewController.m
//  TravelTogether
//
//  Created by 罗元丰 on 16/3/10.
//
//

#import "TTResetPwdViewController.h"
#import <AVOSCloud/AVOSCloud.h>

@interface TTResetPwdViewController ()

@property (weak, nonatomic) IBOutlet UITextField *userNameField;
@property (weak, nonatomic) IBOutlet UILabel *qLabel;
@property (weak, nonatomic) IBOutlet UITextField *answerField;
@property (weak, nonatomic) IBOutlet UIButton *finishBtn;

/**  */
@property (nonatomic, assign) BOOL checkSuccess;

@end

@implementation TTResetPwdViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.checkSuccess = NO;
}

- (IBAction)searchAction:(UIButton *)sender
{
    AVQuery *query = [[AVQuery alloc] initWithClassName:@"TT_User"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        for(AVObject *o in objects)
        {
            if([o[@"userId"] isEqualToString:self.userNameField.text])
            {
                self.qLabel.text = o[@"question"];
            }
        }
    }];
}

- (IBAction)finishAction:(UIButton *)sender
{
    if(self.checkSuccess == NO)
    {
        AVQuery *query = [[AVQuery alloc] initWithClassName:@"TT_User"];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            for(AVObject *o in objects)
            {
                if([o[@"userId"] isEqualToString:self.userNameField.text])
                {
                    if([o[@"answer"] isEqualToString:self.answerField.text])
                    {
                        self.qLabel.text = @"密保验证成功，请重新设定密码";
                        self.answerField.text = @"";
                        self.answerField.placeholder = @"请输入新密码";
                        self.answerField.secureTextEntry = YES;
                        [self.finishBtn setTitle:@"设定" forState:UIControlStateNormal];
                        [self.finishBtn setTitle:@"设定" forState:UIControlStateHighlighted];
                        self.checkSuccess = YES;
                    }
                    else
                    {
                        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"验证失败" message:@"请再试一次" preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:nil];
                        [ac addAction:confirm];
                        [self presentViewController:ac animated:YES completion:nil];
                    }
                }
            }
        }];
    }
    else
    {
        AVQuery *query = [[AVQuery alloc] initWithClassName:@"TT_User"];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            for(AVObject *o in objects)
            {
                if([o[@"userId"] isEqualToString:self.userNameField.text])
                {
                    if(![self.answerField.text isEqualToString: @""])
                    {
                        [o setObject:self.answerField.text forKey:@"password"];
                        [o saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                            UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"密码设定成功" message:@"请重新登录" preferredStyle:UIAlertControllerStyleAlert];
                            UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:nil];
                            [ac addAction:confirm];
                            [self presentViewController:ac animated:YES completion:nil];
                        }];
                    }
                    else
                    {
                        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"密码设定失败" message:@"密码不能为空" preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:nil];
                        [ac addAction:confirm];
                        [self presentViewController:ac animated:YES completion:nil];
                    }
                }
            }
        }];
    }
}

- (IBAction)backAction:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
