//
//  TTTacticDetailTableViewController.m
//  TravelTogether
//
//  Created by 马占臣 on 16/3/2.
//
//

#import "TTTacticDetailTableViewController.h"
#import "TTMethodViewController.h"

#import "TTTacticDetailCell.h"

#import "TTTacticDetailModel.h"

#define TACTIC_DETAIL_URL @"http://q.chanyouji.com/api/v2/activity_collections/"

static NSString *tacticDetailCellID = @"tactic_detail_cell";

@interface TTTacticDetailTableViewController ()<loadMoreTacticsDelegate, UISearchBarDelegate>

/** 用来保存tactic攻略详情model */
@property (nonatomic, strong) NSMutableArray *tacticDetailArray;

@end

@implementation TTTacticDetailTableViewController

#pragma mark 懒加载
- (NSMutableArray *)tacticDetailArray
{
    if (!_tacticDetailArray)
    {
        _tacticDetailArray = [NSMutableArray array];
    }
    return _tacticDetailArray;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = self.topic;
    
    [self setupTableView];

    [self loadData];
}

#pragma mark 初始化tableView
- (void)setupTableView
{
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TTTacticDetailCell class]) bundle:nil] forCellReuseIdentifier:tacticDetailCellID];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}


#pragma mark 加载数据
- (void)loadData
{
    NSString *urlString = [TACTIC_DETAIL_URL stringByAppendingString:[NSString stringWithFormat:@"%@.json", self.tacticID]];
    [SVProgressHUD showWithStatus:@"加载中。。。请稍候" maskType:SVProgressHUDMaskTypeBlack];
    [[AFHTTPSessionManager manager] GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        NSArray *array = responseObject[@"data"][@"inspirations"];
        for (NSDictionary *dict in array)
        {
            TTTacticDetailModel *model = [[TTTacticDetailModel alloc]init];
            [model setValuesForKeysWithDictionary:dict];
            model.photo_url = dict[@"photo"][@"photo_url"];
            model.TTDescription = responseObject[@"data"][@"description"];
            model.isShowingDetail = NO;
            [self.tacticDetailArray addObject:model];
        }
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        TTLog(@"%@", error);
        [SVProgressHUD showErrorWithStatus:@"数据加载失败！" maskType:SVProgressHUDMaskTypeBlack];
        [self.navigationController popViewControllerAnimated:YES];
    }];
}


#pragma mark - Table view data source
#pragma mark 返回row的数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tacticDetailArray.count;
}

#pragma mark 返回cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TTTacticDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:tacticDetailCellID forIndexPath:indexPath];
    for (UIView *v in cell.contentView.subviews)
    {
        if(v.tag == 111)
        {
            [UIView animateWithDuration:0.3 animations:^{
                [v removeFromSuperview];
            }];
        }
    }
    TTTacticDetailModel *tdModel = self.tacticDetailArray[indexPath.row];
    cell.model = tdModel;
    if(tdModel == [self.tacticDetailArray lastObject])
    {
        cell.bottomLine.hidden = YES;
    }
    cell.delegate = self;
    // 添加headView
    if(![tdModel.TTDescription isEqual:[NSNull null]])
    {
        if (![tdModel.TTDescription isEqualToString:@""])
        {
            self.tableView.tableHeaderView = [self setTableViewHeaderWithDescription:tdModel.TTDescription];
        }
    }
    // 如果是展开状态 cell添加详情view
    if(tdModel.isShowingDetail == YES)
    {
        [cell.contentView addSubview:cell.cellView];
    }
    return cell;
}

#pragma mark 点击img和button
- (void)loadMoreTacticsForCell:(TTTacticDetailCell *)cell
{
    TTMethodViewController *mvc = [[TTMethodViewController alloc] init];
    NSIndexPath *index = [self.tableView indexPathForCell:cell];
    TTTacticDetailModel *model = self.tacticDetailArray[index.row];
    mvc.idString = [NSString stringWithFormat:@"%@", model.dID];
    [self.navigationController pushViewController:mvc animated:YES];
}

#pragma mark 点击label不响应
- (void)enabledNo
{
    
}

#pragma mark 返回cell行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TTTacticDetailModel *model = self.tacticDetailArray[indexPath.row];
    if(model.isShowingDetail == YES)
    {
        //cell上的label高度自适应
//        CGRect rect =  [model.introduce boundingRectWithSize:CGSizeMake(self.view.width, 20000) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]} context:nil];
//        CGFloat h = rect.size.height;
        return model.heightForCell;
    }
    else
    {
        return 47;
    }
}

#pragma mark 点击选中cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TTTacticDetailModel *model = self.tacticDetailArray[indexPath.row];
    model.isShowingDetail = !model.isShowingDetail;
    [tableView reloadData];
    [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

#pragma mark - 添加tableViewHeader
- (UIView *)setTableViewHeaderWithDescription:(NSString *)description
{
    UIView *headView = [[UIView alloc]init];
    
    UIImageView *view = [[UIImageView alloc]initWithFrame:CGRectMake(13, 15, 12, 10)];
    view.image = [UIImage imageNamed:@"icon_quote"];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 25, self.view.width - 20, 10)];
    NSString *labelText = description;
    
    // label 行间距
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    //调整行间距
    [paragraphStyle setLineSpacing:5];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    label.attributedText = attributedString;
    
    // label自适应
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:14];
//    CGRect rect = [labelText boundingRectWithSize:CGSizeMake(self.view.width - 20, 20000) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]} context:nil];
    [label sizeToFit];
    label.height = label.frame.size.height;
    
    // 设置一块空白 分开headView和cell
    UIView *clearView = [[UIView alloc]initWithFrame:CGRectMake(0, label.bottomY, self.view.width, 8)];
    clearView.backgroundColor = [UIColor clearColor];
    
    [headView addSubview:clearView];
    [headView addSubview:view];
    [headView addSubview:label];
    
    CGFloat height = clearView.bottomY;
    headView.frame = CGRectMake(10, 0, self.view.width - 20, height);
    return headView;
}

@end
