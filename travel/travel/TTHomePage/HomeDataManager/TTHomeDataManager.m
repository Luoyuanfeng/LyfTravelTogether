//
//  TTHomeDataManager.m
//  TravelTogether
//
//  Created by 罗元丰 on 16/3/1.
//
//

#import "TTHomeDataManager.h"
#import "TTHomeModel.h"
#import "TTLocalTacticModel.h"
#import "TTImageView.h"

#define TT_HOME_MAIN_URL @"http://q.chanyouji.com/api/v2/destinations.json"
#define TT_HOME_LOOPPIC_URL @"http://q.chanyouji.com/api/v1/adverts.json"

#define TT_LOCAL_TACTIC_HEADER @"http://q.chanyouji.com/api/v1/search.json?q="
#define TT_LOCAL_TACTIC_FOOTER @"&search_type=destination"

#define TT_SEARCH_HEADER @"http://q.chanyouji.com/api/v1/search.json?q="
#define TT_SEARCH_FOOTER @"&search_type=hint"

//拼接 **.json
#define TT_HOME_LOOPPIC_ARTICAL_URL @"http://q.chanyouji.com/api/v1/albums/"

@interface TTHomeDataManager ()

/** 数据字典 */
@property (nonatomic, strong) NSMutableDictionary *dataDic;

/** key数组 */
@property (nonatomic, strong) NSMutableArray *keyArr;

/** 轮播图数组 */
@property (nonatomic, strong) NSMutableArray *loopPicArr;

/** 攻略集数组 */
@property (nonatomic, strong) NSMutableArray *localTacticArr;

/** 加载标记 */
@property (nonatomic, assign) BOOL isLoadedLocalTactic;

/** 游记数据字典 */
@property (nonatomic, strong) NSDictionary *tnDic;

/** 搜索历史 */
@property (nonatomic, strong) NSMutableArray *searchHistoryArr;

@end

static TTHomeDataManager *manager = nil;

@implementation TTHomeDataManager

#pragma mark - 单例
+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[TTHomeDataManager alloc] init];
    });
    return manager;
}

#pragma mark - dataDic懒加载
- (NSMutableDictionary *)dataDic
{
    if(!_dataDic)
    {
        _dataDic = [NSMutableDictionary dictionary];
    }
    return _dataDic;
}

#pragma mark - keyArr懒加载
- (NSMutableArray *)keyArr
{
    if(!_keyArr)
    {
        _keyArr = [NSMutableArray array];
    }
    return _keyArr;
}

#pragma mark - 轮播图数组懒加载
- (NSMutableArray *)loopPicArr
{
    if(!_loopPicArr)
    {
        _loopPicArr = [NSMutableArray array];
    }
    return _loopPicArr;
}

#pragma mark - 攻略集数组懒加载
- (NSMutableArray *)localTacticArr
{
    if(!_localTacticArr)
    {
        _localTacticArr = [NSMutableArray array];
    }
    return _localTacticArr;
}

#pragma mark - 游记数据字典懒加载
-(NSDictionary *)tnDic
{
    if(!_tnDic)
    {
        _tnDic = [NSDictionary dictionary];
    }
    return _tnDic;
}

#pragma mark - 搜索历史数组懒加载
- (NSMutableArray *)searchHistoryArr
{
    if(!_searchHistoryArr)
    {
        _searchHistoryArr = [NSMutableArray array];
    }
    return _searchHistoryArr;
}

#pragma mark - 请求数据
-(void)loadHomeDataForCollectionViewCompletionHandler:(void (^)())complete
{
    [[AFHTTPSessionManager manager] GET: TT_HOME_MAIN_URL parameters: nil progress:^(NSProgress * _Nonnull downloadProgress) {
        TTLog(@"正在请求数据...");
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self.keyArr removeAllObjects];
        [self.dataDic removeAllObjects];
        for(NSDictionary *dic in responseObject[@"data"])
        {
            [self.keyArr addObject: dic[@"name"]];
            NSMutableArray *modelsArr = [NSMutableArray array];
            for(NSDictionary *modelDic in dic[@"destinations"])
            {
                TTHomeModel *model = [[TTHomeModel alloc] init];
                [model setValue:dic[@"name"] forKey:@"localName"];
                [model setValuesForKeysWithDictionary:modelDic];
                [modelsArr addObject: model];
            }
            [self.dataDic setObject:modelsArr forKey:dic[@"name"]];
        }
        complete();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        TTLog(@"请求数据失败");
    }];
}

#pragma mark - 返回分组数
- (NSInteger)numberOfSectionInHomeCollectionView
{
    return [self.dataDic allKeys].count;
}

#pragma mark - 返回每组数据数
- (NSInteger)numberOfItemsInSection:(NSInteger)section
{
    NSString *key = [self.keyArr objectAtIndex: section];
    NSArray *arr = self.dataDic[key];
    return arr.count;
}

#pragma mark - 返回模型
- (TTHomeModel *)modelAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *key = self.keyArr[indexPath.section];
    NSArray *arr = self.dataDic[key];
    TTHomeModel *model = [arr objectAtIndex: indexPath.row];
    return model;
}

#pragma mark - 返回标题
- (NSString *)areaAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *area = self.keyArr[indexPath.section];
    return area;
}

#pragma mark - 加载轮播图数据
- (void)loadLoopPicDataCompletionHandler:(void (^)())complete
{
    [[AFHTTPSessionManager manager] GET:TT_HOME_LOOPPIC_URL parameters: nil progress:^(NSProgress * _Nonnull downloadProgress) {
        TTLog(@"正在请求轮播图数据...");
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self.loopPicArr removeAllObjects];
        for(NSDictionary *dic in responseObject[@"data"])
        {
            TTImageView *ttImg = [[TTImageView alloc] init];
            ttImg.photo_url = dic[@"photo"][@"photo_url"];
            ttImg.target_id = dic[@"target_id"];
            [ttImg sd_setImageWithURL:[NSURL URLWithString:ttImg.photo_url]];
            [self.loopPicArr addObject: ttImg];
        }
        complete();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        TTLog(@"请求轮播图数据失败...");
    }];
}

#pragma mark - 返回轮播图数组
- (NSArray *)getLoopPicArr
{
    return self.loopPicArr;
}

#pragma mark - 请求轮播图详情
- (void)loadLoopPicDetailByTargetID:(NSString *)ti comletionHandler:(void (^)(NSDictionary *))complete
{
    NSString *urlString = [TT_HOME_LOOPPIC_ARTICAL_URL stringByAppendingString:[ti stringByAppendingString:@".json"]];
    [[AFHTTPSessionManager manager] GET:urlString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        TTLog(@"请求轮播图详情...");
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        complete(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        TTLog(@"请求轮播图详情失败...");
    }];
}

#pragma mark - 请求攻略集数据
- (void)getLocalTacticDataByLocalID:(NSInteger)localID beginHandler:(void (^)())begin completionHandler:(void (^)())complete
{
    [self.localTacticArr removeAllObjects];
    self.tnDic = nil;
    begin();
    NSString *urlString = [NSString stringWithFormat:@"%@%ld%@", TT_LOCAL_TACTIC_HEADER, (long)localID, TT_LOCAL_TACTIC_FOOTER];
    [[AFHTTPSessionManager manager] GET:urlString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        TTLog(@"正在请求攻略集数据...");
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.tnDic = [responseObject[@"data"][@"user_activities"] firstObject];
        for(NSDictionary *dic in responseObject[@"data"][@"destinations"])
        {
            TTLocalTacticModel *ltModel = [[TTLocalTacticModel alloc] init];
            [ltModel setValuesForKeysWithDictionary: dic];
            [self.localTacticArr addObject: ltModel];
        }
        self.isLoadedLocalTactic = YES;
        complete();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        TTLog(@"请求攻略集数据失败...");
    }];
}

#pragma mark - 获取ltModel
- (TTLocalTacticModel *)ltModelAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.isLoadedLocalTactic == YES)
    {
        return self.localTacticArr[indexPath.row];
    }
    return nil;
}

#pragma mark - 返回攻略本数
- (NSInteger)numberOfLocalTacticInLocalTacticArr
{
    return self.localTacticArr.count;
}

#pragma mark - 返回相关游记数据字典
- (NSDictionary *)dataOfTravelNote
{
    if(self.isLoadedLocalTactic == YES)
    {
        return self.tnDic;
    }
    return nil;
}

#pragma mark - 返回描述文本
- (NSString *)getLocalContent
{
    return self.tnDic[@"description"];
}

#pragma mark - 返回图集数组
- (NSArray *)getPhotoAlbumArr
{
    NSArray *photoUrlArr = self.tnDic[@"contents"];
    NSMutableArray *photoArr = [NSMutableArray array];
    for(NSDictionary *dic in photoUrlArr)
    {
        TTImageView *imgView = [[TTImageView alloc] init];
        [imgView sd_setImageWithURL:[NSURL URLWithString: dic[@"photo_url"]]];
        imgView.picWidth = [dic[@"width"] floatValue];
        imgView.picHeight = [dic[@"height"] floatValue];
        [photoArr addObject: imgView];
    }
    return photoArr;
}

#pragma mark - 搜索
- (void)searchByKeyWord:(NSString *)kw completionHandler:(void (^)())complete
{
    NSString *encoding = [kw stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString *header = [TT_SEARCH_HEADER stringByAppendingString: encoding];
    NSString *urlString = [header stringByAppendingString: TT_SEARCH_FOOTER];
    TTLog(@"%@", urlString);
    [[AFHTTPSessionManager manager] GET:urlString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        TTLog(@"正在搜索...");
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        for(NSDictionary *dic in responseObject)
        {
            if(dic != nil)
            {
                if([self.searchHistoryArr containsObject:dic])
                {
                    [self.searchHistoryArr removeObject:dic];
                }
                [self.searchHistoryArr insertObject:dic atIndex:0];
            }
        }
        complete();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        TTLog(@"搜索失败...");
    }];
}

#pragma mark - 搜索历史
- (NSArray *)getSearchHistory
{
    return self.searchHistoryArr;
}

#pragma mark - 清除搜索历史
- (void)cleanSearchHistory
{
    [self.searchHistoryArr removeAllObjects];
}

@end
