//
//  TTMapCalloutView.h
//  TravelTogether
//
//  Created by 马占臣 on 16/3/6.
//
//

#import <UIKit/UIKit.h>

@protocol mapCalloutViewBtnDelegate <NSObject>
/**
 *  地图气泡上的button代理，用来响应button的响应事件
 */
@optional
/**
 *  回到攻略页面
 */
- (void)goMethodVC;

/**
 *  用苹果地图导航
 */
- (void)useAppleMapNav;

@end

@interface TTMapCalloutView : UIView
/** 图片 */
@property (nonatomic, strong) UIImage *iconImage;

/** topic */
@property (nonatomic, copy) NSString *topic;

/** tip */
@property (nonatomic, copy) NSString *tip;

/** 导航按钮 */
@property (strong, nonatomic) UIButton *naviBtn;

/** 查看攻略按钮 */
@property (strong, nonatomic) UIButton *tacticBtn;

/** delegate */
@property (nonatomic, assign) id<mapCalloutViewBtnDelegate> btnDelegate;


@end
