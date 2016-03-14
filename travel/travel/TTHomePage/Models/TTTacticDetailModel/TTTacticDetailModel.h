//
//  TTTacticDetailModel.h
//  TravelTogether
//
//  Created by 马占臣 on 16/3/2.
//
//

#import <Foundation/Foundation.h>

@interface TTTacticDetailModel : NSObject

/*
 "data":{
 "id":26,
 "description":"每年3月下旬至4月初是东京的樱花季，届时遍布东京各个角落的樱花树便竞相绽放，整个城市笼罩在粉红色的海洋中。东京的赏樱名所为数众多，且历史悠久，这里列出了7个各具特色的赏樱地。",
 "topic":"樱花季",
 "inspiration_activities_count":7,
 "wiki_page":null,
 "inspirations":[
 {
 "wished":false,
 "id":159,
 "wishes_count":680,
 "visit_tip":"1-2小时",
 "topic":"上野公园：历史悠久的赏樱胜地",
 "introduce":"上野公园可说是东京最热闹、最有名、历史最悠久的赏樱胜地了，从江户时代开始，这里就已是花见名所。加上邻近美术馆、动物园的缘故，这里成为日本民众赏樱亲子游的首选之地。 目前公园已有1300多株樱花树，其中发掘自上野公园的樱花名品“染井吉野樱”尤具代表性。夹道的樱树，天空仿佛被染成粉色，风过之处更是落英缤纷，岂一句烂漫唯美可形容！",
 "user_activities_count":1,
 "icon_type":2,
 "photo":{
 "width":1500,
 "height":900,
 "photo_url":"http://inspiration.chanyouji.cn/InspirationActivity/159/68ebb1cd69be1e115d447e7047b7aaa5.jpg?imageMogr2/crop/!1500x900a0a0/thumbnail/800"
 },
 "district":Object{...},
 "destination":Object{...},
 "activity_category":Object{...},
 "wiki_page":null
 },
 */

/** 描述 */
@property (nonatomic, copy) NSString *TTDescription;

/** 标题 */
@property (nonatomic, copy) NSString *topic;

/** 介绍 */
@property (nonatomic, copy) NSString *introduce;

/** cell上小图标type */
@property (nonatomic, assign) NSInteger icon_type;

/** 图片url */
@property (nonatomic, copy) NSString *photo_url;

/** 展开标记 */
@property (nonatomic, assign) BOOL isShowingDetail;

/** id */
@property (nonatomic, copy) NSString *dID;


/** 保存高度 */
@property (nonatomic, assign) CGFloat heightForCell;

@end
