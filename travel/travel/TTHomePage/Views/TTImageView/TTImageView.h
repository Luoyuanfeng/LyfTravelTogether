//
//  TTImageView.h
//  TravelTogether
//
//  Created by 罗元丰 on 16/3/2.
//
//

#import <UIKit/UIKit.h>

@interface TTImageView : UIImageView

/*
 {
 "photo":{
 "width":1280,
 "height":600,
 "photo_url":"http://inspiration.chanyouji.cn/Advert/55/1c62bca7f64ee385aba3e51453cb5f19.jpg"
 },
 "id":55,
 "ios_url":"",
 "android_url":"",
 "target_id":"25",
 "advert_type":"album",
 "topic":"伊斯坦布尔的蓝色假期",
 "market":"all",
 "open_in_browser":false
 },
 */

/** 图片id */
@property (nonatomic, copy) NSString *target_id;

/** 图片url */
@property (nonatomic, assign) NSString *photo_url;

/** 图片宽度 */
@property (nonatomic, assign) CGFloat picWidth;

/** 图片高度 */
@property (nonatomic, assign) CGFloat picHeight;

@end
