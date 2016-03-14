//
//  TTTacticModel.h
//  TravelTogether
//
//  Created by 马占臣 on 16/3/1.
//
//

#import <Foundation/Foundation.h>

@interface TTTacticModel : NSObject

/*
 "description": "每年3月下旬至4月初是东京的樱花季，届时遍布东京各个角落的樱花树便竞相绽放，整个城市笼罩在粉红色的海洋中。东京的赏樱名所为数众多，且历史悠久，这里列出了7个各具特色的赏樱地。",
 "id": 26,
 "inspiration_activities_count": 7,
 "photo_url": "http://inspiration.chanyouji.cn/InspirationActivity/159/68ebb1cd69be1e115d447e7047b7aaa5.jpg?imageMogr2/crop/!1500x900a0a0/thumbnail/800",
 "topic": "樱花季"
 */

/** id */
@property (nonatomic, assign) NSInteger tID;

/** 旅行灵感数 */
@property (nonatomic, assign) NSInteger inspiration_activities_count;

/** 图片地址 */
@property (nonatomic, copy) NSString *photo_url;

/** 标题 */
@property (nonatomic, copy) NSString *topic;


@end
