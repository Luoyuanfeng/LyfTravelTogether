//
//  UIView+LYFViewProperty.m
//  Lyf_BaiSi
//
//  Created by 罗元丰 on 16/1/29.
//  Copyright © 2016年 罗元丰. All rights reserved.
//

#import "UIView+LYFViewCategory.h"

@implementation UIView (LYFViewCategory)

#pragma mark - size
- (CGSize)size
{
    return self.frame.size;
}

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

#pragma mark - width
- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

#pragma mark - height
- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

#pragma mark - leftX
- (CGFloat)leftX
{
    return self.frame.origin.x;
}

- (void)setLeftX:(CGFloat)leftX
{
    CGRect frame = self.frame;
    frame.origin.x = leftX;
    self.frame = frame;
}

#pragma mark - rightX
- (CGFloat)rightX
{
    return self.frame.origin.x + self.width;
}

#pragma mark - topY
- (CGFloat)topY
{
    return self.frame.origin.y;
}

- (void)setTopY:(CGFloat)topY
{
    CGRect frame = self.frame;
    frame.origin.y = topY;
    self.frame = frame;
}

#pragma mark - bottomY
- (CGFloat)bottomY
{
    return self.frame.origin.y + self.height;
}

#pragma mark - midX
- (void)setMidX:(CGFloat)midX
{
    CGPoint center = self.center;
    center.x = midX;
    self.center = center;
}

- (CGFloat)midX
{
    return self.frame.origin.x + self.width / 2;
}

#pragma mark - midY
- (CGFloat)midY
{
    return self.frame.origin.y + self.height / 2;
}

- (void)setMidY:(CGFloat)midY
{
    CGPoint center = self.center;
    center.y = midY;
    self.center = center;
}

@end
