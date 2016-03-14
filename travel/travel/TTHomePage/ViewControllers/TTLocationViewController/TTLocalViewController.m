//
//  TTLocalViewController.m
//  TravelTogether
//
//  Created by 罗元丰 on 16/3/2.
//
//

#import "TTLocalViewController.h"
#import "TTAlbunViewController.h"
#import "TTTacticViewController.h"

#import "TTHomeDataManager.h"

#import "TTLocalTacticCell.h"
#import "TTLocalNoteCell.h"
#import "TTSearchBar.h"

#import "TTLocalTacticModel.h"

#define TTNavBarColor [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1]

static NSString *ltID = @"lt_cell";
static NSString *nID = @"note_cell";
static NSString *sID = @"search_cell";

@interface TTLocalViewController () <UITableViewDataSource, UITableViewDelegate, imgViewInCellDelegate, UISearchBarDelegate, TTSearchBarCancelActionDelegate>

/** tableView */
@property (weak, nonatomic) IBOutlet UITableView *tableView;

/** 搜索栏 */
@property (nonatomic, strong) UISearchBar *sb;

/** 搜索或查看 */
@property (nonatomic, assign) BOOL isSearch;

@end

@implementation TTLocalViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if(self.localName == nil)
    {
        self.isSearch = YES;
    }
    else
    {
        self.isSearch = NO;
        [[TTHomeDataManager sharedManager] getLocalTacticDataByLocalID: self.localID beginHandler:^{
            [self.tableView reloadData];
        } completionHandler:^{
            [self.tableView reloadData];
        }];
    }
    
    [self setupNavigation];
    
    [self setupTableView];
}

#pragma mark - 设置导航栏
- (void)setupNavigation
{
    self.navigationController.navigationBar.barTintColor = TTNavBarColor;
    
    TTSearchBar *sb = [[TTSearchBar alloc] init];
    sb.text = self.localName;
    sb.cancelBtnDeleagte = self;
    sb.delegate = self;
    sb.showsCancelButton = YES;
    sb.placeholder = @"搜索目的地";
    sb.block = ^(UITextField *tf)
    {
        [tf resignFirstResponder];
    };
    self.sb = sb;

    self.navigationItem.titleView = self.sb;
}

#pragma mark - 设置tableView
- (void)setupTableView
{
    if(self.isSearch)
    {
        self.automaticallyAdjustsScrollViewInsets = YES;
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:sID];
        UIButton *cleanHis = [UIButton buttonWithType:UIButtonTypeSystem];
        cleanHis.frame = CGRectMake(0, 0, self.view.width, 40);
        [cleanHis setTitle:@"清除搜索历史" forState:UIControlStateNormal];
        [cleanHis addTarget:self action:@selector(caeanHistoryAction) forControlEvents:UIControlEventTouchUpInside];
        cleanHis.titleLabel.font = [UIFont systemFontOfSize:15];
        [cleanHis setTitleColor:[UIColor colorWithRed:0.12 green:0.73 blue:0.82 alpha:1] forState:UIControlStateNormal];
        self.tableView.tableFooterView = cleanHis;
    }
    else
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.tableView.tableFooterView = nil;
        [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TTLocalTacticCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:ltID];
        [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TTLocalNoteCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:nID];
        self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    }
}

- (void)caeanHistoryAction
{
    [[TTHomeDataManager sharedManager] cleanSearchHistory];
    [self.tableView reloadData];
}

#pragma mark - <UITableViewDelegate>

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    if(self.isSearch)
    {
        height = 60;
    }
    else
    {
        if(indexPath.section == 0)
        {
            height = 80;
        }
        if(indexPath.section == 1)
        {
            NSString *content = [[TTHomeDataManager sharedManager] getLocalContent];
            CGFloat h = [self getContentHeightByContent:content];
            height = h + 410;
        }
    }
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.isSearch)
    {
        NSDictionary *dic = [[TTHomeDataManager sharedManager] getSearchHistory][indexPath.row];
        self.localID = [dic[@"id"] integerValue];
        self.sb.text = dic[@"name"];
        self.isSearch = NO;
        [self setupTableView];
        [[TTHomeDataManager sharedManager] getLocalTacticDataByLocalID: self.localID beginHandler:^{
            [self.tableView reloadData];
        } completionHandler:^{
            [self.tableView reloadData];
        }];
        [self.tableView reloadData];
    }
    else
    {
        if(indexPath.section == 0)
        {
            TTTacticViewController *tvc = [[TTTacticViewController alloc] init];
            TTLocalTacticModel *model = [[TTHomeDataManager sharedManager] ltModelAtIndexPath:indexPath];
            tvc.localID = model.LocalID;
            tvc.localTitle = model.name;
            [self.navigationController pushViewController:tvc animated:YES];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(self.isSearch)
    {
        return 0;
    }
    else
    {
        return 10;
    }
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger n = 0;
    if(self.isSearch)
    {
        n = [[TTHomeDataManager sharedManager] getSearchHistory].count;
    }
    else
    {
        if(section == 0)
        {
            n = [[TTHomeDataManager sharedManager] numberOfLocalTacticInLocalTacticArr];
        }
        if(section == 1)
        {
            n = 1;
        }
    }
    return n;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(self.isSearch)
    {
        return 1;
    }
    else
    {
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *resultCell = nil;
    if(self.isSearch)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sID forIndexPath:indexPath];
        NSDictionary *dic = [[TTHomeDataManager sharedManager] getSearchHistory][indexPath.row];
        cell.textLabel.text = dic[@"name"];
        resultCell = cell;
    }
    else
    {
        if(indexPath.section == 0)
        {
            TTLocalTacticCell *cell = [tableView dequeueReusableCellWithIdentifier: ltID forIndexPath:indexPath];
            TTLocalTacticModel *ltModel = [[TTHomeDataManager sharedManager] ltModelAtIndexPath:indexPath];
            cell.ltModel = ltModel;
            resultCell = cell;
        }
        if(indexPath.section == 1)
        {
            TTLocalNoteCell *cell = [tableView dequeueReusableCellWithIdentifier:nID forIndexPath:indexPath];
            cell.dataDic = [[TTHomeDataManager sharedManager]dataOfTravelNote];
            cell.delegate = self;
            resultCell = cell;
        }
        resultCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return resultCell;
}

#pragma mark - <tapImgViewInCellDelegate>
- (void)imgViewBeTaped:(UIImageView *)imgView
{
    TTAlbunViewController *avc = [[TTAlbunViewController alloc] init];
    avc.photoArr = [[TTHomeDataManager sharedManager] getPhotoAlbumArr];
    [self presentViewController:avc animated:NO completion:nil];
}

#pragma mark - 文字高度自适应
- (CGFloat)getContentHeightByContent:(NSString *)content
{
    CGSize size = CGSizeMake([UIScreen mainScreen].bounds.size.width - 30, 20000);
    NSDictionary *dic = @{NSFontAttributeName : [UIFont systemFontOfSize:15]};
    CGRect rect = [content boundingRectWithSize:size options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    return rect.size.height;
}

#pragma mark - <TTSearchBarCancelActionDelegate>
- (void)cancelBtnDidClicked
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - <UISearchBarDelegate>
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [[TTHomeDataManager sharedManager] searchByKeyWord:searchText completionHandler:^{
        [self.tableView reloadData];
    }];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    if(!self.isSearch)
    {
        [[TTHomeDataManager sharedManager] searchByKeyWord:searchBar.text completionHandler:^{
            self.isSearch = YES;
            [self setupTableView];
            [self.tableView reloadData];
        }];
    }
    return YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
