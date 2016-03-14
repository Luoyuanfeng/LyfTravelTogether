//
//  TTMapViewController.h
//  TravelTogether
//
//  Created by 罗元丰 on 16/2/29.
//
//

#import <UIKit/UIKit.h>

@interface TTMapViewController : UIViewController

/** topic */
@property (nonatomic, copy) NSString *topic;

/** 游玩建议 */
@property (nonatomic, copy) NSString *visit_tip;

/** 地图上小图标type */
@property (nonatomic, copy) NSString *icon_type;

/** id */
@property (nonatomic, copy) NSString *mID;

/** 目标经度 */
@property (nonatomic, assign)double destinationLati;

/** 目标纬度 */
@property (nonatomic, assign)double destinationLongi;


@end
