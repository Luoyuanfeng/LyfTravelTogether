//
//  LYFMultyColorPlaceHolderTextField.m
//  Lyf_BaiSi
//
//  Created by 罗元丰 on 16/2/17.
//  Copyright © 2016年 罗元丰. All rights reserved.
//

#import "LYFMultyColorPlaceHolderTextField.h"
#import <objc/runtime.h>

@implementation LYFMultyColorPlaceHolderTextField

/*+ (void)initialize
{
    unsigned int count = 0;
    //该方法返回一个拷贝出的类中所有成员变量的列表
    Ivar *ivars = class_copyIvarList([UITextField class], &count);
    for(int i = 0; i < count; i++)
    {
        //Ivar ivar = *(ivars + i);
        Ivar ivar = ivars[i];
        
        TTLog(@"%s", ivar_getName(ivar));
    }
    //释放内存
    free(ivars);
}*/

- (void)awakeFromNib
{
    self.tintColor = self.textColor;
    [self setValue: [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1] forKeyPath: @"_placeholderLabel.textColor"];
}

- (BOOL)becomeFirstResponder
{
    [super becomeFirstResponder];
    [self setValue: [UIColor whiteColor] forKeyPath: @"_placeholderLabel.textColor"];
    return YES;
}

- (BOOL)resignFirstResponder
{
    [super resignFirstResponder];
    [self setValue: [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1] forKeyPath: @"_placeholderLabel.textColor"];
    return YES;
}

@end
