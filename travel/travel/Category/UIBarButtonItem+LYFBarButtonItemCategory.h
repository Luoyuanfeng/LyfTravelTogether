//
//  UIBarButtonItem+LYFMakeBarButtonItem.h
//  Lyf_BaiSi
//
//  Created by 罗元丰 on 16/1/29.
//  Copyright © 2016年 罗元丰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (LYFBarButtonItemCategory)

+(instancetype)itemWithNormalImageName:(NSString *)normalName andHighlightedImageName:(NSString *)highlitedName andAddTarget:(id)target andAction:(SEL)action;

@end
