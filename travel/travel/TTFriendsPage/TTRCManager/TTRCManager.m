//
//  TTRCManager.m
//  travel
//
//  Created by 罗元丰 on 16/3/12.
//  Copyright © 2016年 罗元丰. All rights reserved.
//

#import "TTRCManager.h"
#import <RongIMKit/RongIMKit.h>
#import <CommonCrypto/CommonDigest.h>

#define RONG_CLOUD_SECRET @"harCseSxFgVP"
#define RONG_CLOUD_APP_KEY @"qd46yzrf47t1f"

static TTRCManager *manager = nil;

@implementation TTRCManager

+ (instancetype)sharedRCManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[TTRCManager alloc] init];
    });
    return manager;
}

#pragma mark - 使用用户名登录融云
- (void)loginRongCloudByUserName:(NSString *)un completionHandler:(void(^)(NSString *userId))complete
{
    NSInteger random = arc4random();
    NSString *randomStr = [NSString stringWithFormat:@"%ld", (long)random];
    
    NSDate *date = [[NSDate alloc] init];
    NSInteger ts = [date timeIntervalSince1970];
    NSString *timeStamp = [NSString stringWithFormat:@"%ld", (long)ts];
    
    NSString *str = [NSString stringWithFormat:@"%@%@%@", RONG_CLOUD_SECRET, randomStr, timeStamp];
    NSString *s = [self sha1:str];
    
    NSDictionary *param = @{@"userId" : un,
                            @"name" : un,
                            @"portraitUri" : @""};
    
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] init];
    request.timeoutInterval = 10;
    request.HTTPMethod = @"POST";
    request.URL = [NSURL URLWithString:@"https://api.cn.rong.io/user/getToken.json"];
    
    //配置http header
    [request setValue:RONG_CLOUD_APP_KEY forHTTPHeaderField:@"App-Key"];
    [request setValue:randomStr forHTTPHeaderField:@"Nonce"];
    [request setValue:timeStamp forHTTPHeaderField:@"Timestamp"];
    [request setValue:RONG_CLOUD_SECRET forHTTPHeaderField:@"appSecret"];
    //生成hashcode 用以验证签名
    [request setValue:s forHTTPHeaderField:@"Signature"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    request.HTTPBody = [self httpBodyFromParamDictionary:param];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *dic = [NSJSONSerialization  JSONObjectWithData:data options:NSJSONReadingAllowFragments|NSJSONReadingMutableContainers error:nil];
        TTLog(@"%@", dic);
        [[RCIM sharedRCIM] connectWithToken:dic[@"token"] success:^(NSString *userId) {
            NSLog(@"rc登陆成功。当前登录的用户ID：%@", userId);
            complete(userId);
        } error:^(RCConnectErrorCode status) {
            
        } tokenIncorrect:^{
            
        }];
    }];
    [task resume];
}

#pragma mark - 转换httpBody
- (NSData *)httpBodyFromParamDictionary:(NSDictionary *)param
{
    NSMutableString * data = [NSMutableString string];
    for (NSString * key in param.allKeys)
    {
        [data appendFormat:@"%@=%@&",key,param[key]];
    }
    return [[data substringToIndex:data.length-1] dataUsingEncoding:NSUTF8StringEncoding];
}

#pragma mark - 对字段进行哈希算法加密
- (NSString *)sha1:(NSString *)input
{
    const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:input.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes, (unsigned int)data.length, digest);
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i=0; i<CC_SHA1_DIGEST_LENGTH; i++)
    {
        [output appendFormat:@"%02x", digest[i]];
    }
    return output;
}

@end
