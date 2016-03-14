//
//  TTHomeViewController.m
//  TravelTogether
//
//  Created by 罗元丰 on 16/2/29.
//
//

#import "TTHomeViewController.h"
#import "TTLocalViewController.h"
#import "TTLoopPicDetailViewController.h"

#import "TTHomeCell.h"
#import "TTHomeModel.h"
#import "TTHomeDataManager.h"
#import "TTImageView.h"

static NSString *cID = @"collection_item";
static NSString *headerID = @"HeaderView";

@interface TTHomeViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate, UISearchBarDelegate>

/** 显示热门地区的collectionView */
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
/** 头部集成view */
@property (weak, nonatomic) IBOutlet UIView *headView;
/** 搜索栏 */
@property (weak, nonatomic) IBOutlet UISearchBar *sb;

/** 轮播图scrollView */
@property (weak, nonatomic) IBOutlet UIScrollView *loopPicScrollView;
/** 轮播图的contentView */
@property (weak, nonatomic) IBOutlet UIView *loopPicContentView;
/** 轮播图数组 */
@property (nonatomic, strong) NSArray *lpArr;
/** 轮播图pageControl */
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@end

@implementation TTHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupNavigation];
    
    [self setupCollectionView];
    
    [self makeLoopPic];
    
    [[TTHomeDataManager sharedManager] loadHomeDataForCollectionViewCompletionHandler:^{
        [self.collectionView reloadData];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = NO;
}

#pragma mark - 轮播图数组懒加载
- (NSArray *)lpArr
{
    if(!_lpArr)
    {
        _lpArr = [NSArray array];
    }
    return _lpArr;
}

#pragma mark - 设置导航栏
- (void)setupNavigation
{
    self.navigationController.navigationBarHidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - 加载轮播图
- (void)makeLoopPic
{
    self.loopPicScrollView.delegate = self;
    self.loopPicScrollView.pagingEnabled = YES;
    self.loopPicScrollView.bounces = NO;
    self.loopPicScrollView.showsHorizontalScrollIndicator = NO;
    
    [self.headView bringSubviewToFront: self.pageControl];
    
    [[TTHomeDataManager sharedManager] loadLoopPicDataCompletionHandler:^{
        self.lpArr = [[TTHomeDataManager sharedManager] getLoopPicArr];
        for(NSInteger i = 1; i < self.lpArr.count - 1; i++)
        {
            TTImageView *ttImg = self.lpArr[i];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLoopPicAction)];
            [ttImg addGestureRecognizer: tap];
            ttImg.userInteractionEnabled = YES;
            ttImg.frame = CGRectMake((i - 1) * self.view.width, 0, self.view.width, self.view.height / 3 - 40);
            [self.loopPicContentView addSubview: ttImg];
        }
    }];
}

#pragma mark - 轮播图点击
- (void)tapLoopPicAction
{
    NSString *targetID = nil;
    if(self.loopPicScrollView.contentOffset.x == 0)
    {
        targetID = [self.lpArr[1] target_id];
    }
    if(self.loopPicScrollView.contentOffset.x == self.view.width)
    {
        targetID = [self.lpArr[2] target_id];
    }
    TTLoopPicDetailViewController * lpdVC = [[TTLoopPicDetailViewController alloc]init];
    lpdVC.targetID = targetID;
    [self.navigationController pushViewController:lpdVC animated:YES];
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = YES;
}

#pragma mark - 设置collectionView
- (void)setupCollectionView
{
    //设置collectionView的内边距
    self.collectionView.contentInset = UIEdgeInsetsMake([UIScreen mainScreen].bounds.size.height / 3, 0, self.tabBarController.tabBar.height, 0);
    
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [[TTHomeDataManager sharedManager] loadHomeDataForCollectionViewCompletionHandler:^{
            [self.collectionView reloadData];
            [self.collectionView.mj_header endRefreshing];
        }];
    }];
    
    //设置collectionView的layout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    //collectionView的sectionHeader的尺寸
    layout.headerReferenceSize = CGSizeMake(self.view.width, 40);
    self.collectionView.collectionViewLayout = layout;
    
    //设置collectionView的背景色
    self.collectionView.backgroundColor = [UIColor colorWithRed:223/255.0 green:223/255.0 blue:223/255.0 alpha:1];
    
    //注册collectionViewCell 和 reuseableView
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([TTHomeCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:cID];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerID];
}

#pragma mark - <UISearchBarDelegate>
#pragma mark - 点击搜索栏
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    TTLocalViewController *lvc = [[TTLocalViewController alloc] init];
    TTNavigationController *nav = [[TTNavigationController alloc] initWithRootViewController:lvc];
    [self presentViewController:nav animated:YES completion:nil];
    return YES;
}

#pragma mark - 点击cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    TTLocalViewController *lovc = [[TTLocalViewController alloc] init];
    lovc.localName = [[[TTHomeDataManager sharedManager] modelAtIndexPath:indexPath] name];
    lovc.localID = [[[TTHomeDataManager sharedManager] modelAtIndexPath:indexPath] LID];
    TTNavigationController *nav = [[TTNavigationController alloc] initWithRootViewController:lovc];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - <UICollectionViewDataSource>

#pragma mark 有几个section
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [[TTHomeDataManager sharedManager] numberOfSectionInHomeCollectionView];
}

#pragma mark 每个section有几个cell
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[TTHomeDataManager sharedManager] numberOfItemsInSection: section];
}

#pragma mark 返回cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TTHomeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cID forIndexPath: indexPath];
    TTHomeModel *model = [[TTHomeDataManager sharedManager] modelAtIndexPath: indexPath];
    cell.homeModel = model;
    return cell;
}

#pragma mark 对sectionHeader的设置
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *view = nil;
    if(kind == UICollectionElementKindSectionHeader)
    {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerID forIndexPath:indexPath];
        view = headerView;
        for (UIView *v in view.subviews)
        {
            [v removeFromSuperview];
        }
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, view.width, 10)];
        line.backgroundColor = [UIColor colorWithRed:223/255.0 green:223/255.0 blue:223/255.0 alpha:1];
        if(indexPath.section == 0)
        {
            line.backgroundColor = [UIColor whiteColor];
        }
        UILabel *areaLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, view.width - 20, 30)];
        areaLabel.text = [[TTHomeDataManager sharedManager] areaAtIndexPath: indexPath];
        areaLabel.textColor = [UIColor lightGrayColor];
        areaLabel.font = [UIFont systemFontOfSize: 15];
        
        [view addSubview: areaLabel];
        [view addSubview: line];
        
        view.backgroundColor = [UIColor whiteColor];
    }
    return view;
}

#pragma mark - <UICollectionViewDelegateFlowLayout>

#pragma mark 每个cell的size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.view.width / 3, self.view.width / 3 + 60);
}


#pragma mark - 监测collectionView和轮播图的滚动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView == self.collectionView)
    {
        if(scrollView == self.collectionView && self.collectionView.contentOffset.y > -self.view.height / 3)
        {
            self.headView.topY = -(self.view.height / 3 + self.collectionView.contentOffset.y);
        }
        if(scrollView == self.collectionView && self.collectionView.contentOffset.y < -self.view.height / 3)
        {
            [UIView animateWithDuration:0.2 animations:^{
                self.headView.topY = 0;
            }];
        }
        if(self.headView.topY <= -(self.view.height / 3 - 60))
        {
            self.navigationController.navigationBarHidden = NO;
            self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
            UISearchBar *sb = [[UISearchBar alloc] init];
            sb.placeholder = @"搜索目的地";
            sb.delegate = self;
            self.navigationItem.titleView = sb;
        }
        else
        {
            self.navigationController.navigationBarHidden = YES;
        }
    }
    if(scrollView == self.loopPicScrollView)
    {
        CGFloat dx = self.loopPicScrollView.contentOffset.x;
        NSInteger page = dx / self.view.width + 0.5;
        if(page == 0)
        {
            self.pageControl.currentPage = 0;
        }
        else if(page == 1)
        {
            self.pageControl.currentPage = 1;
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
