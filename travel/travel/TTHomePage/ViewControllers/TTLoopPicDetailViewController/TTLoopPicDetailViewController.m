//
//  TTLoopPicDetailViewController.m
//  TravelTogether
//
//  Created by 马占臣 on 16/3/9.
//
//

#import "TTLoopPicDetailViewController.h"
#import "TTHomeDataManager.h"
#import "TTTravelNoteModel.h"
#import "TTAlbunViewController.h"

#import "TTImageView.h"
#import "TTLoopPicDetailDesCell.h"
#import "LYFTTTravelNoteCell.h"


static NSString * const picCellID = @"pic_cell";
static NSString * const textCellID = @"text_cell";
@interface TTLoopPicDetailViewController ()<clickMainImgDelegate>

/** 接收字典 */
@property (nonatomic, strong)NSDictionary *dataDict;

/** 保存数据 */
@property (nonatomic, strong)NSMutableArray *dataArray;

@property (nonatomic)BOOL isFirst;

@property (nonatomic, strong)NSMutableArray *cells;

@end

@implementation TTLoopPicDetailViewController

- (NSMutableArray *)dataArray
{
    if (!_dataArray)
    {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)cells
{
    if(!_cells)
    {
        _cells = [NSMutableArray array];
    }
    return _cells;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"遇见世界";

    self.isFirst = YES;
    
    [self setupTableView];
    
    [self loadData];
}

- (void)setupTableView
{
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LYFTTTravelNoteCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:picCellID];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TTLoopPicDetailDesCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:textCellID];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
}

- (void)loadData
{
    [[TTHomeDataManager sharedManager] loadLoopPicDetailByTargetID:self.targetID comletionHandler:^(NSDictionary *resultDic) {
        // 添加headerView
        NSString *titleHeader = resultDic[@"data"][@"title"];
        NSString *descriptionHeader = resultDic[@"data"][@"summary"];
        self.tableView.tableHeaderView = [self setTableViewHeaderWithTitle:titleHeader Description:descriptionHeader];
        for (NSDictionary *dic in resultDic[@"data"][@"items"])
        {
            TTTravelNoteModel *model = [[TTTravelNoteModel alloc]init];
            model.loopTitle = dic[@"title"];
            model.loopDescription = dic[@"description"];
            if (![dic[@"user_activity"] isEqual:[NSNull null]])
            {
                model.noteTitle = dic[@"user_activity"][@"topic"];
                model.noteDetail = dic[@"user_activity"][@"description"];
                NSArray *imagesArray = dic[@"user_activity"][@"contents"];
                model.imageUrlArray = [NSMutableArray array];
                for (NSDictionary *dic in imagesArray)
                {
                    if ([dic[@"position"] integerValue] == 0)
                    {
                        CGFloat width = [dic[@"width"] floatValue];
                        CGFloat height = [dic[@"height"] floatValue];
                        model.size = CGSizeMake(width, height);
                    }
                    [model.imageUrlArray addObject:dic];
                }
            }
            [self.dataArray addObject:model];
        }
        [self.tableView reloadData];
    }];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.cells.count > 0 && self.isFirst == YES)
    {
        [self.tableView reloadRowsAtIndexPaths:self.cells withRowAnimation:UITableViewRowAnimationNone];
        self.isFirst = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TTTravelNoteModel *model = self.dataArray[indexPath.row];
    if ([model.loopTitle isKindOfClass:[NSNull class]] || [model.loopTitle isKindOfClass:[NSNull class]] ||[model.loopTitle isEqualToString:@""] || [model.loopDescription isEqualToString:@""])
    {
        LYFTTTravelNoteCell *cell = [tableView dequeueReusableCellWithIdentifier:picCellID forIndexPath:indexPath];
        cell.clickDelegate = self;
        cell.model = model;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else
    {
        TTLoopPicDetailDesCell *cell = [tableView dequeueReusableCellWithIdentifier:textCellID forIndexPath:indexPath];
        cell.model = model;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TTTravelNoteModel *model = self.dataArray[indexPath.row];
    if ( [model.loopTitle isEqual:[NSNull null]] || [model.loopDescription isEqual:[NSNull null]])
    {
        CGFloat heightOfMainImage = self.view.width * model.size.height / model.size.width;
        CGFloat height = model.heightForCell + heightOfMainImage;
        if (height >= 300)
        {
            [self.cells addObject:indexPath];
        }
        return height;
    }
    else
    {
        return model.heightForCell;
    }
}

#pragma mark - 添加tableViewHeader
- (UIView *)setTableViewHeaderWithTitle:(NSString *)title Description:(NSString *)description
{
    UIView *headView = [[UIView alloc]init];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 12, self.view.width - 24, 30)];
    titleLabel.font = [UIFont systemFontOfSize:17 weight:2];
    titleLabel.text = title;
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(12, 40, self.view.width - 24, 10)];
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
    [label sizeToFit];
    label.height = label.frame.size.height;
    
    // 设置一块空白 分开headView和cell
    UIView *clearView = [[UIView alloc]initWithFrame:CGRectMake(0, label.bottomY + 10, self.view.width, 8)];
    clearView.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1];
    
    [headView addSubview:clearView];
    [headView addSubview:titleLabel];
    [headView addSubview:label];
    
    CGFloat height = clearView.bottomY;
    headView.frame = CGRectMake(10, 0, self.view.width - 24, height);
    return headView;
}

- (void)mainImageClickedByImageUrlArr:(NSArray *)imgArr andClickIndex:(NSInteger)index
{
    TTAlbunViewController *avc = [[TTAlbunViewController alloc] init];
    NSMutableArray *picArr = [NSMutableArray array];
    for (NSDictionary *dic in imgArr)
    {
        TTImageView *img = [[TTImageView alloc] init];
        img.picWidth = [dic[@"width"] floatValue];
        img.picHeight = [dic[@"height"] floatValue];
        [img sd_setImageWithURL:[NSURL URLWithString:dic[@"photo_url"]]];
        [picArr addObject:img];
    }
    avc.photoArr = picArr;
    avc.index = index;
    [self presentViewController:avc animated:NO completion:nil];
}

@end
