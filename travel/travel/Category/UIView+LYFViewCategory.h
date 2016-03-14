//
//  UIView+LYFViewProperty.h
//  Lyf_BaiSi
//
//  Created by 罗元丰 on 16/1/29.
//  Copyright © 2016年 罗元丰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (LYFViewCategory)

@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;

@property (nonatomic, assign) CGFloat leftX;
@property (nonatomic, assign, readonly) CGFloat rightX;

@property (nonatomic, assign) CGFloat topY;
@property (nonatomic, assign, readonly) CGFloat bottomY;

@property (nonatomic, assign) CGFloat midX;
@property (nonatomic, assign) CGFloat midY;

@property (nonatomic, assign) CGSize size;

/***** 在类目中声明@property，只会生成其get和set方法的声明，并不会生成方法的实现和 _属性名 的实例变量 *****/

@end
