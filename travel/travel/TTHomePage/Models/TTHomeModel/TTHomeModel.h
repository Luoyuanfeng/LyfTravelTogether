//
//  TTHomeModel.h
//  TravelTogether
//
//  Created by 罗元丰 on 16/3/1.
//
//

#import <Foundation/Foundation.h>

@interface TTHomeModel : NSObject

/*
 "data":[
 {
 "name":"大陆热门目的地",
 "region":"china",
 "destinations":[
 {
 "id":109,
 "district_id":100007,
 "parent_id":5,
 "name":"云南",
 "name_en":"Yunnan",
 "name_pinyin":"yun nan|yn",
 "score":1165,
 "level":3,
 "path":".1.5.109.",
 "published":true,
 "is_in_china":true,
 "inspiration_activities_count":0,
 "activity_collections_count":0,
 "wishes_count":0,
 "wiki_destination_id":null,
 "photo_url":"http://inspiration.chanyouji.cn/Destination/109/2b85ab3d7ebda3c321436a6147153f09.jpg",
 "lat":25.0454,
 "lng":102.71
 },
 */

/** 地区 */
@property (nonatomic, copy) NSString *localName;
/** id */
@property (nonatomic, assign) NSInteger LID;
/** 地名 */
@property (nonatomic, copy) NSString *name;
/** 英文地名 */
@property (nonatomic, copy) NSString *name_en;
/** 图片url */
@property (nonatomic, copy) NSString *photo_url;

@end
