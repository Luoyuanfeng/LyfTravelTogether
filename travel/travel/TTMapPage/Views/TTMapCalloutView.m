//
//  TTMapCalloutView.m
//  TravelTogether
//
//  Created by 马占臣 on 16/3/6.
//
//

#import "TTMapCalloutView.h"

#define kPortraitMargin     10
#define kPortraitWidth      24
#define kPortraitHeight     24

#define kTitleWidth         220
#define kTitleHeight        20

@interface TTMapCalloutView ()

/** icon */
@property (strong, nonatomic) UIImageView *iconImg;

/** topic */
@property (strong, nonatomic) UILabel *topicLabel;

/** visit_tipLabel */
@property (strong, nonatomic) UILabel *tipLabel;

@end

@implementation TTMapCalloutView

/**
 *  重写drawRect等方法，目的是画出气泡的背景
 */
- (void)drawRect:(CGRect)rect
{
    [self drawInContext:UIGraphicsGetCurrentContext()];
    
    self.layer.shadowColor = [[UIColor whiteColor] CGColor];
    self.layer.shadowOpacity = 1.0;
    self.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
}

- (void)drawInContext:(CGContextRef)context
{
    CGContextSetLineWidth(context, 2.0);
    CGContextSetFillColorWithColor(context, [UIColor colorWithWhite:1.000 alpha:0.800].CGColor);
    
    [self getDrawPath:context];
    CGContextFillPath(context);
}

- (void)getDrawPath:(CGContextRef)context
{
    CGRect rrect = self.bounds;
    CGFloat radius = 6.0;
    CGFloat minx = CGRectGetMinX(rrect),
    midx = CGRectGetMidX(rrect),
    maxx = CGRectGetMaxX(rrect);
    CGFloat miny = CGRectGetMinY(rrect),
    maxy = CGRectGetMaxY(rrect) - 10;
    
    CGContextMoveToPoint(context, midx + 10, maxy);
    CGContextAddLineToPoint(context, midx, maxy + 10);
    CGContextAddLineToPoint(context, midx - 10, maxy);
    
    CGContextAddArcToPoint(context, minx, maxy, minx, miny, radius);
    CGContextAddArcToPoint(context, minx, minx, maxx, miny, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, maxx, radius);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    CGContextClosePath(context);
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews
{
    self.iconImg = [[UIImageView alloc] initWithFrame:CGRectMake(kPortraitMargin, kPortraitMargin, kPortraitWidth, kPortraitHeight)];
    [self addSubview:self.iconImg];
    
    self.topicLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPortraitMargin * 2 + kPortraitWidth, kPortraitMargin, kTitleWidth, kTitleHeight)];
    self.topicLabel.font = [UIFont boldSystemFontOfSize:14];
    [self addSubview:self.topicLabel];
    
    self.tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPortraitMargin * 2 + kPortraitWidth, kPortraitMargin + kTitleHeight + 2, kTitleWidth, kTitleHeight)];
    self.tipLabel.font = [UIFont systemFontOfSize:11];
    self.tipLabel.textColor = [UIColor lightGrayColor];
    [self addSubview:self.tipLabel];
    
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.tipLabel.frame) + 5, self.size.width - 20, 1)];
    view.backgroundColor = [UIColor colorWithWhite:0.810 alpha:1.000];
    [self addSubview:view];
    
    self.naviBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.naviBtn.frame = CGRectMake(kPortraitMargin, CGRectGetMaxY(self.tipLabel.frame) + 9, 120, 25);
    self.naviBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.naviBtn setTitle:@"地图导航" forState:UIControlStateNormal];
    [self.naviBtn setTitleColor:[UIColor colorWithRed:0.086 green:0.675 blue:0.784 alpha:1.000] forState:UIControlStateNormal];
    [self.naviBtn addTarget:self action:@selector(naviAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview: self.naviBtn];
    
    self.tacticBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.tacticBtn.frame = CGRectMake(150, CGRectGetMaxY(self.tipLabel.frame) + 9, 120, 25);
    self.tacticBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.tacticBtn setTitle:@"查看攻略" forState:UIControlStateNormal];
    [self.tacticBtn setTitleColor:[UIColor colorWithRed:0.086 green:0.675 blue:0.784 alpha:1.000] forState:UIControlStateNormal];
    [self.tacticBtn addTarget:self action:@selector(tacticAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview: self.tacticBtn];
}

#pragma mark "地图导航"button 响应事件
- (void)naviAction
{
    if (_btnDelegate && [_btnDelegate respondsToSelector:@selector(useAppleMapNav)]) {
        [_btnDelegate useAppleMapNav];
    }
}

#pragma mark "查看攻略"button 响应事件
- (void)tacticAction
{
    if (_btnDelegate && [_btnDelegate respondsToSelector:@selector(goMethodVC)]) {
        [_btnDelegate goMethodVC];
    }
}

#pragma mark 设置topic，tip，image
/**
 *  此处逻辑比较混乱，地图上点击出来的是annotationView，气泡是annotationView的calloutView
 *  在calloutView中定义image，topic和tip属性，在上面属性的setter方法中给imageView，topicLabel，tipLabel赋值，而这个值是在annotationView的calloutView属性中赋过来的，在calloutView赋值的时候在让其代理（也就是mapVC）调用代理方法将值传到annotationView中的callout属性上，才完成了赋值
 */
- (void)setIconImage:(UIImage *)iconImage
{
    self.iconImg.image = iconImage;
}

- (void)setTopic:(NSString *)topic
{
    self.topicLabel.text = topic;
}

- (void)setTip:(NSString *)tip
{
    self.tipLabel.text = tip;
}

@end
