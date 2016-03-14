//
//  LYFLoginRegisterViewController.h
//  Lyf_BaiSi
//
//  Created by 罗元丰 on 16/2/16.
//  Copyright © 2016年 罗元丰. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^loginFlag)(BOOL isLogin, NSString *userId, NSString *FUCK);

@interface LYFLoginRegisterViewController : UIViewController

/** 判断是否登录的标记 */
@property (nonatomic, copy) loginFlag flag;

@end
