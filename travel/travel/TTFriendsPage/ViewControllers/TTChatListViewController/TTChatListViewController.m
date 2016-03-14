//
//  TTChatListViewController.m
//  TravelTogether
//
//  Created by 罗元丰 on 16/3/8.
//
//

#import "TTChatListViewController.h"

@interface TTChatListViewController ()

@end

@implementation TTChatListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.conversationListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE), @(ConversationType_SYSTEM)]];
}

#pragma mark - 选中会话列表中的会话时，跳转到会话页面（rongCloudSDK）
- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType conversationModel:(RCConversationModel *)model atIndexPath:(NSIndexPath *)indexPath
{
    RCConversationViewController *conversationVC = [[RCConversationViewController alloc] init];
    conversationVC.conversationType = model.conversationType;
    conversationVC.targetId = model.targetId;
    conversationVC.title = model.targetId;
    [self.navigationController pushViewController:conversationVC animated:YES];
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
