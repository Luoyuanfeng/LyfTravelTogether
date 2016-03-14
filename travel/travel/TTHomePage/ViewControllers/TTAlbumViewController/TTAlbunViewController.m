//
//  TTAlbunViewController.m
//  TravelTogether
//
//  Created by 罗元丰 on 16/3/3.
//
//

#import "TTAlbunViewController.h"
#import "TTHomeDataManager.h"
#import "TTImageView.h"

@interface TTAlbunViewController () <UIScrollViewDelegate>

/** 轮播图contentView的宽度约束 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthOfAlbum;

/** scrollView */
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

/** 图集（轮播图）的contentView */
@property (weak, nonatomic) IBOutlet UIView *contentView;

/** pageControl */
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@end

@implementation TTAlbunViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self makeAlbum];
    
    [self.view layoutIfNeeded];
}

#pragma mark - 加载相册
- (void)makeAlbum
{
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    CGFloat h = [UIScreen mainScreen].bounds.size.height;
    NSArray *pArr = self.photoArr;
    self.widthOfAlbum.constant = w * (pArr.count - 1);
    self.pageControl.numberOfPages = pArr.count;
    for(NSInteger i = 0; i < pArr.count; i++)
    {
        TTImageView *imgView = pArr[i];
        CGFloat d = w / imgView.picWidth;
        CGFloat ph = imgView.picHeight * d;
        CGFloat dy = h * 3 / 8 - ph / 2;
        imgView.frame = CGRectMake(i * w, dy, w, ph);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backAction)];
        [imgView addGestureRecognizer:tap];
        [self.contentView addGestureRecognizer: tap];
        imgView.userInteractionEnabled = YES;
        [self.contentView addSubview: imgView];
    }
    TTLog(@"%ld", (long)self.index);
    self.scrollView.contentOffset = CGPointMake(self.index * w, 0);
}

- (void)backAction
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat dx = scrollView.contentOffset.x;
    NSInteger page = dx / [UIScreen mainScreen].bounds.size.width + 0.5;
    self.pageControl.currentPage = page;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self backAction];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
