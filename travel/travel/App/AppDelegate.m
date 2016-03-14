//
//  AppDelegate.m
//  TravelTogether
//
//  Created by 马占臣 on 16/2/29.
//  Copyright © 2016年 马占臣. All rights reserved.
//

#import "AppDelegate.h"
#import "TTTabBarController.h"

#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <AVOSCloud/AVOSCloud.h>
#import <RongIMKit/RongIMKit.h>

#define LEAN_CLOUD_APPID @"YlzyfRuTmVsJ5wWw4TqN3xRa-gzGzoHsz"
#define LEAN_CLOUD_CLIENT_KEY @"1WgHx00bGzzA45FFuVITvU8f"
#define RONG_CLOUD_APP_KEY @"qd46yzrf47t1f"

static NSString * const KEYN = @"f3cbfc601db7a4917fb304dd00542d1f";

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // 地图服务
    [MAMapServices sharedServices].apiKey = KEYN;
    [AMapSearchServices sharedServices].apiKey = KEYN;
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    TTTabBarController *tbc = [[TTTabBarController alloc] init];
    
    self.window.rootViewController = tbc;
    
    [AVOSCloud setApplicationId:LEAN_CLOUD_APPID clientKey:LEAN_CLOUD_CLIENT_KEY];
    [[RCIM sharedRCIM] initWithAppKey:RONG_CLOUD_APP_KEY];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
   
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    
}

@end
