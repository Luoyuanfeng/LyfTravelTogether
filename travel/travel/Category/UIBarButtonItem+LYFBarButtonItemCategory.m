//
//  UIBarButtonItem+LYFMakeBarButtonItem.m
//  Lyf_BaiSi
//
//  Created by 罗元丰 on 16/1/29.
//  Copyright © 2016年 罗元丰. All rights reserved.
//

#import "UIBarButtonItem+LYFBarButtonItemCategory.h"
#import "UIView+LYFViewCategory.h"

@implementation UIBarButtonItem (LYFBarButtonItemCategory)


//封装了UIbarButtonItem对象的创建
+(instancetype)itemWithNormalImageName:(NSString *)normalName andHighlightedImageName:(NSString *)highlitedName andAddTarget:(id)target andAction:(SEL)action
{
    UIButton *btn = [UIButton buttonWithType: UIButtonTypeCustom];
    [btn setBackgroundImage: [UIImage imageNamed: normalName] forState: UIControlStateNormal];
    [btn setBackgroundImage: [UIImage imageNamed: highlitedName] forState: UIControlStateHighlighted];
    btn.size = btn.currentBackgroundImage.size;
    [btn addTarget: target action: action forControlEvents: UIControlEventTouchUpInside];
    
    //使用initWithCustomView:方法通过一个自定义的控件初始化一个UIBarButtonItem对象
    return [[self alloc] initWithCustomView: btn];
}

@end
