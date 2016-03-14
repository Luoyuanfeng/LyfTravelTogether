//
//  TTTravelNoteViewController.m
//  TravelTogether
//
//  Created by 罗元丰 on 16/2/29.
//
//

#import "TTTravelNoteViewController.h"
#import "TTTravelNoteModel.h"
#import "LYFTTTravelNoteCell.h"
#import "TTAlbunViewController.h"
#import "TTImageView.h"

#define kTravelNoteUrl @"http://q.chanyouji.com/api/v1/timelines.json"

@interface TTTravelNoteViewController () <UITableViewDataSource, UITableViewDelegate, clickMainImgDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, assign) BOOL isLoadingData;

@property (nonatomic, assign) NSInteger page;

/** 保存cell的indexPath */
@property (nonatomic, strong) NSMutableArray *cells;

/** 标记是否第一个cell */
@property (nonatomic, assign) BOOL isFirst;

@end

static NSString *tvID = @"cell_note";

@implementation TTTravelNoteViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"旅行奇遇";
    self.isFirst = YES;
    self.page = 1;
    
    [self setupTableView];
    
    [self loadData];
}

- (NSMutableArray *)dataArray
{
    if(!_dataArray)
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

- (void)viewWillAppear:(BOOL)animated
{
    [self.tableView layoutIfNeeded];
}


- (void)setupTableView
{
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LYFTTTravelNoteCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:tvID];
}

- (void)loadData
{
    self.isLoadingData = YES;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"page"] = [NSString stringWithFormat:@"%ld", self.page];
    params[@"per"] = @"20";
    [[AFHTTPSessionManager manager] GET:kTravelNoteUrl parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *array = responseObject[@"data"];
        for (NSDictionary *dic in array)
        {
            NSDictionary *dict = dic[@"activity"];
            TTTravelNoteModel *model = [[TTTravelNoteModel alloc] init];
            model.noteTitle = dict[@"topic"];
            model.noteDetail = dict[@"description"];
            NSArray *imagesArray = dict[@"contents"];
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
            [self.dataArray addObject:model];
        }
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        TTLog(@"载入错误");
    }];
    self.isLoadingData = NO;
}

- (void)loadNewData
{
    [self.dataArray removeAllObjects];
    self.page = 1;
    [self loadData];
}

- (void)loadMoreData
{
    self.page++;
    [self loadData];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.cells.count > 0 && self.isFirst == YES)
    {
        [self.tableView reloadRowsAtIndexPaths:self.cells withRowAnimation:UITableViewRowAnimationNone];
        self.isFirst = NO;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TTTravelNoteModel *model = self.dataArray[indexPath.row];
    CGFloat heightOfMainImage = self.view.width * model.size.height / model.size.width;
    CGFloat height = model.heightForCell + heightOfMainImage;
    if (height >= 200)
    {
        [self.cells addObject:indexPath];
    }
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LYFTTTravelNoteCell *cell = [tableView dequeueReusableCellWithIdentifier:tvID forIndexPath:indexPath];
    TTTravelNoteModel *model = self.dataArray[indexPath.row];
    cell.clickDelegate = self;
    cell.model = model;
    return cell;
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
