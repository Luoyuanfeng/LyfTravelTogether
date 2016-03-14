//
//  TTSearchBar.m
//  TravelTogether
//
//  Created by 罗元丰 on 16/3/3.
//
//

#import "TTSearchBar.h"

@interface TTSearchBar () <UITextFieldDelegate>

@end

@implementation TTSearchBar

/*
+ (void)initialize
{
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList([UISearchBar class], &count);
    for(int i = 0; i < count; i++)
    {
        Ivar ivar = ivars[i];
        TTLog(@"== %s ==", ivar_getName(ivar));
    }
    free(ivars);
}
 */

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        [self setupCancelBtn];
    }
    return self;
}

- (void)setupCancelBtn
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn setTitleColor:[UIColor colorWithRed:0.12 green:0.73 blue:0.82 alpha:1] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(cancelBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self setValue:btn forKeyPath:@"_cancelButton"];
    [self setValue:self forKeyPath:@"_searchField.delegate"];
}

- (void)cancelBtnAction
{
    if(self.cancelBtnDeleagte && [self.cancelBtnDeleagte respondsToSelector:@selector(cancelBtnDidClicked)])
    {
        [self.cancelBtnDeleagte cancelBtnDidClicked];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    self.block(textField);
    return YES;
}

@end
