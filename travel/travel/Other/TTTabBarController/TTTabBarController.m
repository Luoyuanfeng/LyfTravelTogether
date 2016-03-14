//
//  TTTabBarController.m
//  TravelTogether
//
//  Created by 罗元丰 on 16/2/29.
//
//

#import "TTTabBarController.h"
#import "TTHomeViewController.h"
#import "TTTravelNoteViewController.h"
#import "TTMapViewController.h"
#import "TTFriendsViewController.h"

@interface TTTabBarController ()

@end

@implementation TTTabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //设置tabBar
    [self setupTabBar];
}

#pragma mark - 设置tabBar
- (void)setupTabBar
{
    self.tabBar.barTintColor = [UIColor whiteColor];
    self.tabBar.tintColor = [UIColor colorWithRed:0.12 green:0.73 blue:0.82 alpha:1];
    
    TTHomeViewController *hvc = [[TTHomeViewController alloc] init];
    TTNavigationController *hnvc = [[TTNavigationController alloc] initWithRootViewController: hvc];
    [self tabBarItemWithViewController:hnvc andTitle:@"首页" andNormalImageName:@"tab_home" andSelectedImageName:@"tab_home_selected"];
    
    TTTravelNoteViewController *tvc = [[TTTravelNoteViewController alloc] init];
    UINavigationController *tnvc = [[UINavigationController alloc] initWithRootViewController: tvc];
    [self tabBarItemWithViewController:tnvc andTitle:@"游记" andNormalImageName:@"tab_activities" andSelectedImageName:@"tab_activities_selected"];
    
    TTMapViewController *mvc = [[TTMapViewController alloc] init];
    UINavigationController *mnvc = [[UINavigationController alloc] initWithRootViewController: mvc];
    [self tabBarItemWithViewController:mnvc andTitle:@"地图" andNormalImageName:@"tab_plans" andSelectedImageName:@"tab_plans_selected"];
    
    TTFriendsViewController *fvc = [[TTFriendsViewController alloc] init];
    TTNavigationController *fnvc = [[TTNavigationController alloc] initWithRootViewController: fvc];
    [self tabBarItemWithViewController:fnvc andTitle:@"好友" andNormalImageName:@"tab_me" andSelectedImageName:@"tab_me_selected"];
    
    self.viewControllers = @[hnvc, tnvc, mnvc, fnvc];
}

#pragma mark - 为tabBar设置item
- (void)tabBarItemWithViewController:(UIViewController *)viewController andTitle:(NSString *)title andNormalImageName:(NSString *)normalName andSelectedImageName:(NSString *)selectedName
{
    viewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image: [UIImage imageNamed:normalName] selectedImage: [UIImage imageNamed:selectedName]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
