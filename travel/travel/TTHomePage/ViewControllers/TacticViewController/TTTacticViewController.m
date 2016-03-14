//
//  TTTacticViewController.m
//  TravelTogether
//
//  Created by 马占臣 on 16/3/1.
//
//

#import "TTTacticViewController.h"
#import "TTTacticCell.h"
#import "TTTacticModel.h"
#import "TTTacticDetailTableViewController.h"

#define TACTIC_URL_HEADER @"http://q.chanyouji.com/api/v1/activity_collections.json?destination_id="

@interface TTTacticViewController ()

/** 用来保存tactic攻略model */
@property (nonatomic, strong) NSMutableArray *tacticArray;

@end

static NSString *tacticCellID = @"tactic_cell";
@implementation TTTacticViewController

#pragma mark 懒加载
- (NSMutableArray *)tacticArray
{
    if (!_tacticArray) {
        _tacticArray = [NSMutableArray array];
    }
    return _tacticArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化tableView
    [self setupTableView];
    // 加载数据
    [self loadData];
    self.title = [NSString stringWithFormat:@"%@攻略", self.localTitle];
    
}

#pragma mark 初始化tableView
- (void)setupTableView
{
//    self.automaticallyAdjustsScrollViewInsets = NO;
    // 隐藏滚动条
    self.tableView.showsVerticalScrollIndicator = NO;
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TTTacticCell class]) bundle:nil] forCellReuseIdentifier:tacticCellID];
}

#pragma mark 加载数据
- (void)loadData
{
    NSString *urlString = [TACTIC_URL_HEADER stringByAppendingString:[NSString stringWithFormat:@"%@",self.localID]];
    [SVProgressHUD showInfoWithStatus:@"加载中。。。请稍候" maskType:SVProgressHUDMaskTypeBlack];
    [[AFHTTPSessionManager manager] GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        NSArray *array = responseObject[@"data"];
        for (NSDictionary *dict in array) {
            TTTacticModel *model = [[TTTacticModel alloc]init];
            [model setValuesForKeysWithDictionary:dict];
            [self.tacticArray addObject:model];
        }
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        TTLog(@"%@", error);
        [SVProgressHUD showErrorWithStatus:@"加载数据失败" maskType:SVProgressHUDMaskTypeBlack];
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

#pragma mark - Table view data source
#pragma mark 返回row的数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.tacticArray.count;
}

#pragma mark 返回cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TTTacticCell *cell = [tableView dequeueReusableCellWithIdentifier:tacticCellID forIndexPath:indexPath];
    cell.tactic = self.tacticArray[indexPath.row];
    if (indexPath.row == 0) {
        cell.line.hidden = YES;
    }
    return cell;
}

#pragma mark 返回cell的高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ([UIScreen mainScreen].bounds.size.height - 64) / 4;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TTTacticDetailTableViewController *tdvc = [[TTTacticDetailTableViewController alloc]init];
    TTTacticModel *model = self.tacticArray[indexPath.row];
    tdvc.tacticID = [NSString stringWithFormat:@"%ld", (long)model.tID];
    tdvc.topic = model.topic;
    [self.navigationController pushViewController:tdvc animated:YES];
}


@end
