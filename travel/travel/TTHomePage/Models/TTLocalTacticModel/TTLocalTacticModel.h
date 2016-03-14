//
//  TTLocalTacticModel.h
//  TravelTogether
//
//  Created by 罗元丰 on 16/3/2.
//
//

#import <Foundation/Foundation.h>

@interface TTLocalTacticModel : NSObject

/*
 "id":35,
 "district_id":360,
 "parent_id":34,
 "name":"台北",
 "name_en":"Taipei",
 "name_pinyin":"tai bei|tb",
 "score":100,
 "level":4,
 "path":".1.5.34.35.",
 "published":true,
 "is_in_china":true,
 "inspiration_activities_count":85,
 "activity_collections_count":12,
 "wishes_count":26262,
 "wiki_destination_id":null,
 "photo_url":"http://inspiration.chanyouji.cn/Destination/35/c58656438fa551ebd2ae67a8425ef5aa.jpg",
 "lat":25.0479,
 "lng":121.517
 */

/** 图片url */
@property (nonatomic, copy) NSString *photo_url;

/** 景点名 */
@property (nonatomic, copy) NSString *name;

/** 灵感数 */
@property (nonatomic, copy) NSString *inspiration_activities_count;

/** id */
@property (nonatomic, copy) NSString *LocalID;

@end
