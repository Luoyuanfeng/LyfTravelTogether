//
//  TTHomeDataManager.h
//  TravelTogether
//
//  Created by 罗元丰 on 16/3/1.
//
//
#import <Foundation/Foundation.h>

@class TTHomeModel;
@class TTLocalTacticModel;

@interface TTHomeDataManager : NSObject

/**
 * 首页数据管理类单例
 **/
+ (instancetype)sharedManager;

/**
 * 请求数据
 **/
- (void)loadHomeDataForCollectionViewCompletionHandler:(void(^)())complete;

/**
 * 返回分组数
 * @return NSInteger
 **/
- (NSInteger)numberOfSectionInHomeCollectionView;

/**
 * 返回每组数据数
 * @param section
 * @return NSInteger
 **/
- (NSInteger)numberOfItemsInSection:(NSInteger)section;

/**
 * 返回模型
 * @param indexPath
 * @return Model
 **/
- (TTHomeModel *)modelAtIndexPath:(NSIndexPath *)indexPath;

/**
 * 返回标题
 * @param indexPath
 * @return NSString
 **/
- (NSString *)areaAtIndexPath:(NSIndexPath *)indexPath;

/**
 * 加载轮播图数据
 **/
- (void)loadLoopPicDataCompletionHandler:(void(^)())complete;

/**
 * 返回轮播图
 * @return arr
 **/
- (NSArray *)getLoopPicArr;

/**
 * 请求轮播图详情
 * @param target_id
 **/
- (void)loadLoopPicDetailByTargetID:(NSString *)ti comletionHandler:(void(^)(NSDictionary *resultDic))complete;

/**
 * 获取攻略集数据
 **/
- (void)getLocalTacticDataByLocalID:(NSInteger)localID beginHandler:(void(^)())begin completionHandler:(void(^)())complete;

/**
 * 获取攻略集model
 * @param indexPath
 * @return ltModel
 **/
- (TTLocalTacticModel *)ltModelAtIndexPath:(NSIndexPath *)indexPath;

/**
 * 返回攻略本数
 * @return NSInteger
 **/
- (NSInteger)numberOfLocalTacticInLocalTacticArr;

/**
 * 返回相关游记数据字典
 * @return dic
 **/
- (NSDictionary *)dataOfTravelNote;

/**
 * 返回描述文本
 * @return NSString
 **/
- (NSString *)getLocalContent;

/**
 * 返回图集数组
 * @return arr
 **/
- (NSArray *)getPhotoAlbumArr;

/**
 * 搜索
 * @param 关键字
 * @return dic
 **/
- (void)searchByKeyWord:(NSString *)kw completionHandler:(void(^)())complete;

/**
 * 搜索历史
 * @return arr
 **/
- (NSArray *)getSearchHistory;

/**
 * 清除搜索历史
 **/
- (void)cleanSearchHistory;

@end
