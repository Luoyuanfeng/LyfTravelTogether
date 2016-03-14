//
//  TTMethodModel.h
//  TravelTogether
//
//  Created by Winston on 16/3/3.
//
//

#import <Foundation/Foundation.h>

@interface TTMethodModel : NSObject

@property (nonatomic, copy) NSString *cropping_url;
@property (nonatomic, copy) NSString *topic;
@property (nonatomic, copy) NSString *introduce;
@property (nonatomic, copy) NSString *tip;

/** 相关游记的description */
@property (nonatomic, copy) NSString *ADescription;

/** 图片资源数组 */
@property (nonatomic, strong) NSArray *contents;

@end
