//
//  TTCalloutAnnotationView.m
//  TravelTogether
//
//  Created by 马占臣 on 16/3/6.
//
//

#import "TTCalloutAnnotationView.h"
#import "TTMapCalloutView.h"

@interface TTCalloutAnnotationView ()

//@property (nonatomic, strong, readwrite) TTMapCalloutView *calloutView;

@end

@implementation TTCalloutAnnotationView

#define kCalloutWidth       280.0
#define kCalloutHeight      100.0

#pragma mark 重写setSelected方法，设置其calloutView
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if (self.selected == selected)
    {
        return;
    }
    if (selected)
    {
        if (self.calloutView == nil)
        {
            self.calloutView = [[TTMapCalloutView alloc] initWithFrame:CGRectMake(0, 0, kCalloutWidth, kCalloutHeight)];
            self.calloutView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.f + self.calloutOffset.x, -CGRectGetHeight(self.calloutView.bounds) / 2.f + self.calloutOffset.y);
        }
        // 其代理为mapVC，将值传过来赋值到calloutView的属性中
        self.calloutView.iconImage = [self.cvDelegate setImage];
        self.calloutView.topic = [self.cvDelegate setTopicText];
        self.calloutView.tip = [self.cvDelegate setTipText];
        
        // calloutView中的btn的代理也是mapVC，但是在mapVC中指定代理的话，会发生指定代理的时候annotationView的calloutView还没有赋值，因此代理添加不上的问题
        self.calloutView.btnDelegate = self.cvDelegate;
        
        [self addSubview:self.calloutView];
    }
    else
    {
        [self.calloutView removeFromSuperview];
    }
    [super setSelected:selected animated:animated];
}

@end
