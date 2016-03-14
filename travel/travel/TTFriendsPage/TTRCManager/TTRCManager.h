//
//  TTRCManager.h
//  travel
//
//  Created by 罗元丰 on 16/3/12.
//  Copyright © 2016年 罗元丰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTRCManager : NSObject

+ (instancetype)sharedRCManager;

- (void)loginRongCloudByUserName:(NSString *)un completionHandler:(void(^)(NSString *userId))complete;

@end
