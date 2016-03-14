//
//  TTFriendsViewController.m
//  TravelTogether
//
//  Created by 罗元丰 on 16/2/29.
//
//

#import "TTFriendsViewController.h"
#import "LYFLoginRegisterViewController.h"
#import "TTChatListViewController.h"
#import "TTSearchFriendViewController.h"

#import "TTFriendListCell.h"
#import "TTFriendListModel.h"

#import "TTRCManager.h"

#import <AVOSCloud/AVOSCloud.h>

typedef NS_ENUM(NSInteger, TTChangeMode)
{
    TTChangeModeFromFriendList = 1,
    TTChangeModeFromChatList
};

@interface TTFriendsViewController () <UITableViewDataSource, UITableViewDelegate, RCIMUserInfoDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photoTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photoWidth;


/** 用户头像 */
@property (weak, nonatomic) IBOutlet UIImageView *userPhotoImageView;

/** 顶部显示用户信息的背景view */
@property (weak, nonatomic) IBOutlet UIView *headBackgroundView;
/** 两个分类按钮的背景view */
@property (weak, nonatomic) IBOutlet UIView *categoryView;

/** 好友按钮 */
@property (weak, nonatomic) IBOutlet UIButton *friendBtn;
/** 好友按钮的左侧距离约束 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *friendBtnMargin;

/** 会话按钮 */
@property (weak, nonatomic) IBOutlet UIButton *chatButton;
/** 会话按钮的右侧距离约束 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *chatBtnMargin;

/** 右上角设置按钮 */
@property (weak, nonatomic) IBOutlet UIButton *settingbtn;

/** 立即登录注册按钮 */
@property (weak, nonatomic) IBOutlet UIButton *goLoginRegBtn;
/** 立即登录注册按钮的顶部距离约束 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lrButton_topMargin;

/** 顶部用户信息中的用户名Label */
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

/** 状态栏背景色view */
@property (nonatomic, strong) UIView *statusBarBg;

/** 好友列表 */
@property (nonatomic, strong) UITableView *friendListTableView;
/** 配合好友列表的数据数组 */
@property (nonatomic, strong) NSMutableArray *friendsArr;

/** 跳转到聊天界面时的状态 */
@property (nonatomic, assign) TTChangeMode changeMode;

/** 会话列表 */
@property (nonatomic, strong) UIView *chatView;

@end

@implementation TTFriendsViewController

#pragma mark - 好友数组的懒加载
- (NSMutableArray *)friendsArr
{
    if(!_friendsArr)
    {
        _friendsArr = [NSMutableArray array];
    }
    return _friendsArr;
}

#pragma mark - 视图完成加载（设置RCIM的userInfoDataSource为self）
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupNav];
    
    [self checkLoginStatus];
   
    [self makeBtnSuitable];
    
    /////////////////////////////////////////////////
    
    [self addTargetActionForBtn];
    
    [self setupFriendListTableView];
    
    self.changeMode = TTChangeModeFromFriendList;
    [RCIM sharedRCIM].userInfoDataSource = self;
    [RCIM sharedRCIM].globalConversationAvatarStyle = RC_USER_AVATAR_CYCLE;
    [RCIM sharedRCIM].globalMessageAvatarStyle = RC_USER_AVATAR_CYCLE;
    
    self.photoTop.constant = [UIScreen mainScreen].bounds.size.height / 3 * 0.28;
    self.photoWidth.constant = [UIScreen mainScreen].bounds.size.height / 3 * 0.32;
    self.userPhotoImageView.layer.cornerRadius = self.photoWidth.constant / 2;
}

#pragma mark - 导航栏设定
- (void)setupNav
{
    self.navigationController.navigationBarHidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.userPhotoImageView.layer.borderColor = [UIColor whiteColor].CGColor;
}

#pragma mark - 检查是否已经登录
- (void)checkLoginStatus
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *uid = [ud objectForKey:@"userId"];
    NSString *pwd = [ud objectForKey:@"password"];
    if(![uid isEqualToString:@""] && ![pwd isEqualToString:@""] && uid != nil && pwd != nil)
    {
        self.isLogin = YES;
        self.userId = uid;
    }
    else
    {
        self.isLogin = NO;
        self.userId = @"";
    }
}

#pragma mark - 视图将要显示（进行判断，是否登录状态）
- (void)viewWillAppear:(BOOL)animated
{
    [self.view layoutIfNeeded];
    for(UIView *v in self.view.subviews)
    {
        if(v.tag == 11111)
        {
            [v removeFromSuperview];
        }
    }
    if(self.changeMode == TTChangeModeFromChatList)
    {
        [self chatListAction:self.chatButton];
    }
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = NO;
    if(self.isLogin == YES)
    {
        self.goLoginRegBtn.hidden = YES;
        self.userNameLabel.text = self.userId;
        
        if([self.FUCK isEqualToString:@"fuck"])
        {
            self.changeMode = TTChangeModeFromFriendList;
            self.FUCK = nil;
        }
        else if([self.FUCK isEqualToString:@"no"])
        {
            self.changeMode = TTChangeModeFromChatList;
            self.FUCK = nil;
        }
        
        self.settingbtn.userInteractionEnabled = YES;
        self.friendBtn.userInteractionEnabled = YES;
        self.chatButton.userInteractionEnabled = YES;
        
        [self makeFriendList];

        [self setupUserPhotoImageView];

        [self reLogin];

        [self checkChangeMode];
    }
    else
    {
        [self backToUnLogin];
    }
}

- (void)checkChangeMode
{
    if(self.changeMode == TTChangeModeFromChatList)
    {
        self.chatButton.selected = YES;
        self.friendBtn.selected = NO;
        self.friendListTableView.hidden = YES;
        self.chatView.hidden = NO;
        [self chatListAction:self.chatButton];
    }
    if(self.changeMode == TTChangeModeFromFriendList)
    {
        self.chatButton.selected = NO;
        self.friendBtn.selected = YES;
        self.friendListTableView.hidden = NO;
        self.chatView.hidden = YES;
    }
}

- (void)reLogin
{
    [[TTRCManager sharedRCManager] loginRongCloudByUserName:self.userId completionHandler:^(NSString *userId) {
        self.userId = userId;
    }];
}

#pragma mark - 置为未登录状态
- (void)backToUnLogin
{
    self.friendListTableView.hidden = YES;
    self.chatView.hidden = YES;
    
    self.userNameLabel.text = @"您还未登录";
    self.goLoginRegBtn.hidden = NO;
    self.userPhotoImageView.userInteractionEnabled = NO;
    self.userPhotoImageView.image = [UIImage imageNamed:@"user_image"];
    
    
    self.friendBtn.selected = NO;
    self.chatButton.selected = NO;
    self.friendBtn.userInteractionEnabled = NO;
    self.chatButton.userInteractionEnabled = NO;
    self.settingbtn.userInteractionEnabled = NO;
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:@"" forKey:@"userId"];
    [ud setObject:@"" forKey:@"password"];
}

#pragma mark - 获取当前登录用户的头像
- (void)setupUserPhotoImageView
{
    self.userPhotoImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectPhoto)];
    [self.userPhotoImageView addGestureRecognizer:tap];
    AVQuery *query = [[AVQuery alloc] initWithClassName:@"TT_User"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        for(AVObject *obj in objects)
        {
            if([obj[@"userId"] isEqualToString:self.userId])
            {
                AVFile *file = obj[@"userPhoto"];
                NSData *photoData = [file getData];
                UIImage *p = [UIImage imageWithData:photoData];
                if(p == nil)
                {
                    p = [UIImage imageNamed:@"user_image"];
                }
                else
                {
                    self.userPhotoImageView.image = p;
                }
            }
        }
    }];
}

#pragma mark - 点击头像位置的响应事件
- (void)selectPhoto
{
    UIAlertController *sfAlert = [UIAlertController alertControllerWithTitle:@"设置头像" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *fromCamera = [UIAlertAction actionWithTitle:@"现在拍一张" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self selectPhotoByCamera];
    }];
    UIAlertAction *fromAlbum = [UIAlertAction actionWithTitle:@"从相册选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self selectPhotoByAlbum];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [sfAlert addAction:fromCamera];
    [sfAlert addAction:fromAlbum];
    [sfAlert addAction:cancel];
    [self presentViewController:sfAlert animated:YES completion:nil];
}

#pragma mark - 通过相机拍摄头像
- (void)selectPhotoByCamera
{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }
    else
    {
        TTLog(@"无相机...");
    }
}

#pragma mark - 通过相册选取头像
- (void)selectPhotoByAlbum
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

#pragma mark - 将用户设置的头像上传至数据库
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    UIImage *ri = [self imageWithImageSimple:image scaledToSize:CGSizeMake(100, 100)];
    NSData *photoData = UIImagePNGRepresentation(ri);
    AVFile *file = [AVFile fileWithData:photoData];
    
    AVQuery *query = [AVQuery queryWithClassName:@"TT_User"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        for(AVObject *obj in objects)
        {
            if([obj[@"userId"] isEqualToString:self.userId])
            {
                [obj setObject:file forKey:@"userPhoto"];
                [obj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if(succeeded)
                    {
                        self.userPhotoImageView.image = ri;
                    }
                }];
            }
            AVQuery *q = [[AVQuery alloc] initWithClassName:obj[@"userId"]];
            [q findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                for(AVObject *u_obj in objects)
                {
                    if([u_obj[@"userId"] isEqualToString:self.userId])
                    {
                        [u_obj setObject:file forKey:@"userPhoto"];
                        [u_obj saveInBackground];
                    }
                }
            }];
        }
    }];
}

#pragma mark - 设置页面中按钮的内边距及显示位置
- (void)makeBtnSuitable
{
    self.lrButton_topMargin.constant = [UIScreen mainScreen].bounds.size.height / 3;
    
    self.friendBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 10, -20);
    self.friendBtn.titleEdgeInsets = UIEdgeInsetsMake(self.friendBtn.height - self.friendBtn.currentImage.height + 5, -self.friendBtn.currentImage.width, 0, 0);
    
    self.chatButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 10, -20);
    self.chatButton.titleEdgeInsets = UIEdgeInsetsMake(self.chatButton.height - self.chatButton.currentImage.height + 5, -self.chatButton.currentImage.width, 0, 0);
}

#pragma mark - 为分类按钮添加事件（已登录状态下执行）
- (void)addTargetActionForBtn
{
    [self.friendBtn addTarget:self action:@selector(friendListAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.chatButton addTarget:self action:@selector(chatListAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.settingbtn addTarget:self action:@selector(settingAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.friendBtn.userInteractionEnabled = NO;
    self.chatButton.userInteractionEnabled = NO;
}

#pragma mark - 设置会话列表页面（已登录状态下执行）
- (void)setupChatListView
{
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    CGFloat h = [UIScreen mainScreen].bounds.size.height;
    TTChatListViewController *cvc = [[TTChatListViewController alloc] init];
    [self addChildViewController:cvc];
    cvc.view.tag = 11111;
    self.chatView = cvc.view;
    self.chatView.frame = CGRectMake(0, h / 3, w, h - (h / 3));
    self.chatView.hidden = YES;
}

#pragma mark - 设置好友列表页面（已登录状态下执行）
- (void)setupFriendListTableView
{
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    CGFloat h = [UIScreen mainScreen].bounds.size.height;
    UITableView *friendListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, w, h) style:UITableViewStylePlain];
    friendListTableView.contentInset = UIEdgeInsetsMake(h / 3, 0, 44, 0);
    friendListTableView.delegate = self;
    friendListTableView.dataSource = self;
    [friendListTableView registerNib:[UINib nibWithNibName:NSStringFromClass([TTFriendListCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"fl_cell"];
    friendListTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self makeFriendList];
    }];
    friendListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.friendListTableView = friendListTableView;
    [self.view addSubview:self.friendListTableView];
    self.friendListTableView.hidden = YES;
    [self.view bringSubviewToFront:self.headBackgroundView];
}

#pragma mark - 加载好友列表（已登录状态下执行）
- (void)makeFriendList
{
    [self.friendsArr removeAllObjects];
    [self searchUserInLeanCloudByClassName:self.userId whenSearching:^(NSArray *objects) {
        for(AVObject *obj in objects)
        {
            TTFriendListModel *model = [[TTFriendListModel alloc] init];
            model.friendId = obj[@"userId"];
            model.friendName = obj[@"friend"];
            AVFile *file = obj[@"userPhoto"];
            NSData *pd = [file getData];
            UIImage *p = [UIImage imageWithData:pd];
            if(p == nil)
            {
                model.friendPhoto = [UIImage imageNamed:@"user_image"];
            }
            else
            {
                TTLog(@"%@", obj[@"userId"]);
                model.friendPhoto = p;
            }
            [self.friendsArr addObject:model];
        }
        [self.friendListTableView.mj_header endRefreshing];
        [self.friendListTableView reloadData];
    }];
}

#pragma mark - 好友列表按钮的点击事件（已登录状态下执行）
- (void)friendListAction:(UIButton *)sender
{
    if(sender.selected == NO)
    {
        self.changeMode = TTChangeModeFromFriendList;
        self.chatButton.selected = !self.chatButton.selected;
        sender.selected = !sender.selected;
        self.chatView.hidden = YES;
        self.friendListTableView.hidden = NO;
        [self.view bringSubviewToFront:self.friendListTableView];
        [self.view bringSubviewToFront:self.headBackgroundView];
    }
}

#pragma mark - 会话列表按钮的点击事件（已登录状态下执行）
- (void)chatListAction:(UIButton *)sender
{
    [self setupChatListView];
    if(sender.selected == NO)
    {
        self.changeMode = TTChangeModeFromChatList;
        self.friendBtn.selected = !self.friendBtn.selected;
        sender.selected = !sender.selected;
        self.chatView.hidden = NO;
        self.friendListTableView.hidden = YES;
    }
    [self.view addSubview:self.chatView];
}

#pragma mark - 点击右上角设置按钮时的响应方法（已登录状态下执行）
- (void)settingAction
{
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"设置" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *findFriend = [UIAlertAction actionWithTitle:@"查找好友" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self findFriend];
    }];
    UIAlertAction *cancelLogin = [UIAlertAction actionWithTitle:@"注销登录" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self cancelLogin];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [ac addAction:findFriend];
    [ac addAction:cancelLogin];
    [ac addAction:cancel];
    [self presentViewController:ac animated:YES completion:nil];
}

#pragma mark - 跳转到搜索好友页面（已登录状态下执行）
- (void)findFriend
{
    TTSearchFriendViewController *svc = [[TTSearchFriendViewController alloc] init];
    svc.userId = self.userId;
    [self.navigationController pushViewController:svc animated:YES];
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = YES;
}

#pragma mark - 注销登录（已登录状态下执行）
- (void)cancelLogin
{
    self.friendListTableView.hidden = YES;
    self.chatView.hidden = YES;
    self.chatView = nil;

    self.isLogin = NO;
    self.userId = @"";
    self.FUCK = @"fuck";
    
    [self.friendsArr removeAllObjects];
    [self.friendListTableView reloadData];
    
    [self viewWillAppear:NO];
    [self goLoginRegAction:self.goLoginRegBtn];
}

#pragma mark - 在未登录时，点击立即登录注册按钮显示登录注册页面
- (IBAction)goLoginRegAction:(UIButton *)sender
{
    LYFLoginRegisterViewController *lrvc = [[LYFLoginRegisterViewController alloc] init];
    lrvc.flag = ^(BOOL isLogin, NSString *userId, NSString *FUCK){
        self.isLogin = isLogin;
        self.userId = userId;
        self.FUCK = FUCK;
    };
    [self presentViewController:lrvc animated:YES completion:nil];
}

#pragma mark - 使用leanCloudSDK进行数据库查询
- (void)searchUserInLeanCloudByClassName:(NSString *)className whenSearching:(void(^)(NSArray *objects))whenSearching
{
    AVQuery *query = [AVQuery queryWithClassName:className];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        whenSearching(objects);
    }];
}

#pragma mark - <UITableViewDataSource, UITableViewDelegate>

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TTFriendListCell *cell = [self.friendListTableView dequeueReusableCellWithIdentifier:@"fl_cell" forIndexPath:indexPath];
    TTFriendListModel *model = self.friendsArr[indexPath.row];
    cell.model = model;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.friendsArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RCConversationViewController *chat = [[RCConversationViewController alloc] init];
    chat.conversationType = ConversationType_PRIVATE;
    chat.targetId = [self.friendsArr[indexPath.row] friendId];
    chat.title = [self.friendsArr[indexPath.row] friendName];
    
    [self.navigationController pushViewController:chat animated:YES];
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    TTFriendListModel *model = self.friendsArr[indexPath.row];
    AVQuery *query = [[AVQuery alloc] initWithClassName:self.userId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        for(AVObject *obj in objects)
        {
            if([model.friendId isEqualToString:obj[@"userId"]])
            {
                [obj deleteInBackground];
            }
        }
    }];
    [self.friendsArr removeObject:model];
    [self.friendListTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - 返回用户数据
- (void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion
{
    AVQuery *query = [[AVQuery alloc] initWithClassName:@"TT_User"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        for(AVObject *obj in objects)
        {
            if([obj[@"userId"] isEqualToString:userId])
            {
                AVFile *file = obj[@"userPhoto"];
                NSString *name = file.name;
                AVQuery *q = [[AVQuery alloc] initWithClassName:@"_File"];
                [q findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                    for(AVObject *fObj in objects)
                    {
                        if([fObj[@"name"] isEqualToString:name])
                        {
                            RCUserInfo *info = [[RCUserInfo alloc] initWithUserId:userId name:userId portrait:fObj[@"url"]];
                            completion(info);
                        }
                    }
                }];
            }
        }
    }];
}

- (UIImage *)imageWithImageSimple:(UIImage *)image scaledToSize:(CGSize )newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake (0, 0, newSize.width, newSize.height)];
    
    // Get the new image from the context
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
