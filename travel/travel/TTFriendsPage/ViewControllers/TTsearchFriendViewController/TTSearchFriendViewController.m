//
//  TTSearchFriendViewController.m
//  TravelTogether
//
//  Created by 罗元丰 on 16/3/8.
//
//

#import "TTSearchFriendViewController.h"
#import "TTSearchFriendCell.h"

#import <AVOSCloud/AVOSCloud.h>

#define SEARCH_USER_CELL_ID @"user_cell"

@interface TTSearchFriendViewController () <UITableViewDataSource, UITableViewDelegate, addFriendDelegate, UITextFieldDelegate>

/** 搜索按钮 */
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;

/** 用户名输入框 */
@property (weak, nonatomic) IBOutlet UITextField *userNameField;

/** 用于显示结果的tableView */
@property (weak, nonatomic) IBOutlet UITableView *resultTableView;

/** 结果数组 */
@property (nonatomic, strong) NSMutableArray *resultArr;

@end

@implementation TTSearchFriendViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navigationItem.title = @"查找好友";
    
    [self.searchBtn addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.resultTableView registerNib:[UINib nibWithNibName:NSStringFromClass([TTSearchFriendCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:SEARCH_USER_CELL_ID];
}

#pragma mark - 保存查询结果的数组
- (NSMutableArray *)resultArr
{
    if(!_resultArr)
    {
        _resultArr = [NSMutableArray array];
    }
    return _resultArr;
}

#pragma mark - 点击搜索按钮时执行的事件
- (void)searchAction
{
    static NSString *userTable = @"TT_User";
    [self.resultArr removeAllObjects];
    [self searchUserInLeanCloudByClassName:userTable whenSearching:^(NSArray *objects) {
        for(AVObject *obj in objects)
        {
            if([obj[@"userName"] isEqualToString:self.userNameField.text])
            {
                [self.resultArr addObject:obj];
            }
        }
        [self.resultTableView reloadData];
    }];
}

#pragma mark - <UITableViewDelegate, UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.resultArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TTSearchFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:SEARCH_USER_CELL_ID forIndexPath:indexPath];
    cell.userNameLabel.text = [NSString stringWithFormat:@"用户：%@",self.resultArr[indexPath.row][@"userName"]];
    NSData *photoData = [self.resultArr[indexPath.row][@"userPhoto"] getData];
    UIImage *photoImg = [UIImage imageWithData:photoData];
    if(photoImg == nil)
    {
        cell.photoView.image = [UIImage imageNamed:@"user_image"];
    }
    else
    {
        cell.photoView.image = photoImg;
    }
    cell.afDelegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

#pragma mark - 添加查询到的用户为好友
- (void)addFriendInCell:(TTSearchFriendCell *)cell
{
    NSIndexPath *index = [self.resultTableView indexPathForCell:cell];
    AVQuery *query = [[AVQuery alloc] initWithClassName:self.userId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        BOOL isFriend = NO;
        for(AVObject *obj in objects)
        {
            if([obj[@"friend"] isEqualToString:self.resultArr[index.row][@"userId"]])
            {
                isFriend = YES;
            }
        }
        if(isFriend)
        {
            UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"添加失败" message:@"该用户已经是您的好友了" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            [ac addAction:confirm];
            [self presentViewController:ac animated:YES completion:nil];
        }
        else
        {
            AVObject *userObj = [AVObject objectWithClassName:self.userId];
            [userObj setObject:self.resultArr[index.row][@"userName"] forKey:@"friend"];
            [userObj setObject:self.resultArr[index.row][@"userId"] forKey:@"userId"];
            [userObj setObject:self.resultArr[index.row][@"userPhoto"] forKey:@"userPhoto"];
            [userObj saveInBackground];
            UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"添加成功！" message:@"您可以在好友列表中查看~" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            [ac addAction:confirm];
            [self presentViewController:ac animated:YES completion:nil];
        }
    }];
}

#pragma mark - 通过融云数据库查询用户信息
- (void)searchUserInLeanCloudByClassName:(NSString *)className whenSearching:(void(^)(NSArray *objects))whenSearching
{
    AVQuery *query = [AVQuery queryWithClassName:className];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        whenSearching(objects);
    }];
}

#pragma mark - 搜索框收键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
