//
//  TTMethodViewController.m
//  TravelTogether
//
//  Created by Winston on 16/3/3.
//
//

#import "TTMethodViewController.h"
#import "TTMethodModel.h"
#import "TTImageView.h"
#import "TTAlbunViewController.h"
#import "TTMapViewController.h"

#define METHOD_URL @"http://q.chanyouji.com/api/v1/inspiration_activities/"

@interface TTMethodViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *introduceLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

/** 对titleLabel距上端的高度修改 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topOfTitleLabel;

/** 对scrollView高度的约束 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightOfContentView;

/** navigationbar切割的背景图 */
@property (nonatomic, strong) UIImage * navImage;

@property (nonatomic, strong) UIImageView *topImageView;

@property (weak, nonatomic) IBOutlet UIScrollView *scroolView;

/** 底部背景View */
@property (weak, nonatomic) IBOutlet UIView *bottomBgView;
/** 底部背景View的高度约束 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomBgViewHeight;

/** 底部图片 */
@property (weak, nonatomic) IBOutlet TTImageView *bottomImgView;
/** 底部图片的高度约束 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomImgViewHeight;

/** 底部游记标题 */
@property (weak, nonatomic) IBOutlet UILabel *bottomTitleLabel;
/** 底部游记内容 */
@property (weak, nonatomic) IBOutlet UILabel *bottomDetailLabel;

@property (nonatomic, strong) TTMethodModel *model;

/** 保存图标type */
@property (nonatomic, assign) NSInteger icon_type;

/** 保存经度 */
@property (nonatomic, assign) double lati;

/** 保存纬度 */
@property (nonatomic, assign) double longi;

/** 保存城市名 */
@property (nonatomic, copy) NSString *city;

/** 保存topic */
@property (nonatomic, copy) NSString *topic;

/** 保存visit_tip */
@property (nonatomic, copy) NSString *visit_tip;

@property (weak, nonatomic) IBOutlet UILabel *cityLabel;

@end

@implementation TTMethodViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupNavigation];
    
    [self setupImage];
    
    [self loadData];
}

- (TTMethodModel *)model
{
    if (!_model)
    {
        _model = [[TTMethodModel alloc] init];
    }
    return _model;
}

- (void)setupNavigation
{
    self.navigationController.navigationBarHidden = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    UIImage *backImage = [UIImage imageNamed:@"nav_back_white"];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithImage:backImage style:UIBarButtonItemStyleDone target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = back;
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    
    UIButton *mapBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    mapBtn.frame = CGRectMake(0, 0, 20, 20);
    [mapBtn setBackgroundImage:[UIImage imageNamed:@"nav_map"] forState:UIControlStateNormal];
    [mapBtn addTarget:self action:@selector(jumpToMap) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithCustomView:mapBtn];
    self.navigationItem.rightBarButtonItem = right;
    
    
}

- (void)setupImage
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    self.topOfTitleLabel.constant = width * 0.6 + 10;
    self.topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, width * 0.6)];
    [self.contentView addSubview:self.topImageView];
}

- (void)loadData
{
    NSString *urlString = [METHOD_URL stringByAppendingString:[NSString stringWithFormat:@"%@.json", self.idString]];
    TTLog(@"%@", urlString);
    [[AFHTTPSessionManager manager] GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject[@"data"];
        //////////////////////////////////////////
        // 定义一些属性传值到maoView
        self.visit_tip = dic[@"visit_tip"];
        self.topic = dic[@"topic"];
        self.icon_type = [dic[@"icon_type"] integerValue];
        self.city = dic[@"destination"][@"name"];
        for (NSDictionary *dict in dic[@"pois"]) {
            self.lati = [dict[@"lat"] doubleValue];
            self.longi = [dict[@"lng"] doubleValue];
        }
        //////////////////////////////////////////
        [self.model setValuesForKeysWithDictionary:dic];
        self.model.ADescription = dic[@"user_activity"][@"description"];
        self.model.contents = dic[@"user_activity"][@"contents"];
        [self reNewView];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        TTLog(@"method载入错误");
    }];
}

- (void)reNewView
{
//    CGFloat heightOfIntroduce = [self heightForTitleLabelWithString:self.model.introduce font:[UIFont systemFontOfSize:16] dx:20];
//    CGFloat heightOfTip = [self heightForTitleLabelWithString:self.model.tip font:[UIFont systemFontOfSize:14] dx:20];

    self.tipLabel.text = self.model.tip;
    
    NSString *introduceText = self.model.introduce;
    
    // label 行间距
    NSMutableAttributedString *introduceAttributedString = [[NSMutableAttributedString alloc] initWithString:introduceText];
    NSMutableParagraphStyle *paragraphStyleIntroduce = [[NSMutableParagraphStyle alloc] init];
    //调整行间距
    [paragraphStyleIntroduce setLineSpacing:5];
    [introduceAttributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyleIntroduce range:NSMakeRange(0, [introduceText length])];
    self.introduceLabel.attributedText = introduceAttributedString;
    [self.introduceLabel sizeToFit];
    self.introduceLabel.height = self.introduceLabel.frame.size.height;
    CGFloat heightOfIntroduce = self.introduceLabel.height;
    
    NSString *tipText = self.model.tip;
    // label 行间距
    NSMutableAttributedString *tipAttributedString = [[NSMutableAttributedString alloc] initWithString:tipText];
    NSMutableParagraphStyle *paragraphStyleTip = [[NSMutableParagraphStyle alloc] init];
    //调整行间距
    [paragraphStyleTip setLineSpacing:3];
    [tipAttributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyleTip range:NSMakeRange(0, [tipText length])];
    self.tipLabel.attributedText = tipAttributedString;
    [self.tipLabel sizeToFit];
    self.tipLabel.height = self.tipLabel.frame.size.height;
    CGFloat heightOfTip = self.tipLabel.height;
    
    
    [self.topImageView sd_setImageWithURL:[NSURL URLWithString:self.model.cropping_url]];
    self.titleLabel.text = self.model.topic;

    self.cityLabel.text = self.city;
    
    if(self.model.ADescription == nil && self.model.contents == nil)
    {
        self.bottomBgView.hidden = YES;
        self.heightOfContentView.constant = (self.view.width * 0.6 + heightOfIntroduce + heightOfTip + 125) - self.view.height;
        return;
    }
    else
    {
        self.bottomBgView.hidden = NO;
        
        NSDictionary *dic = [self.model.contents firstObject];
        NSString *url = dic[@"photo_url"];
        [self.bottomImgView sd_setImageWithURL:[NSURL URLWithString:url]];
        CGFloat w = [UIScreen mainScreen].bounds.size.width;
        self.bottomImgViewHeight.constant = ((w - 20) / [dic[@"width"] floatValue]) * [dic[@"height"] floatValue];
        self.bottomImgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage)];
        [self.bottomImgView addGestureRecognizer:tap];
        
        self.bottomTitleLabel.text = self.model.topic;
        
        NSString *aDescriptionText = self.model.ADescription;

        // label 行间距
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:aDescriptionText];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        //调整行间距
        [paragraphStyle setLineSpacing:5];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [aDescriptionText length])];
        self.bottomDetailLabel.attributedText = attributedString;
        [self.bottomDetailLabel sizeToFit];
        self.bottomDetailLabel.height = self.bottomDetailLabel.frame.size.height;
        
//        CGFloat dh = [self heightForTitleLabelWithString:self.model.ADescription font:[UIFont systemFontOfSize:14] dx:40];
        CGFloat dh = self.bottomDetailLabel.height;
        
        self.bottomBgViewHeight.constant = self.bottomImgViewHeight.constant + dh + 110;
        
        self.heightOfContentView.constant = (self.view.width * 0.6 + heightOfIntroduce + heightOfTip + 240 + self.bottomImgViewHeight.constant + dh) - self.view.height;
    }
}

- (void)tapImage
{
    TTAlbunViewController *avc = [[TTAlbunViewController alloc] init];
    NSMutableArray *pArr = [NSMutableArray array];
    for(NSDictionary *dic in self.model.contents)
    {
        TTImageView *img = [[TTImageView alloc] init];
        [img sd_setImageWithURL:[NSURL URLWithString:dic[@"photo_url"]]];
        img.picWidth = [dic[@"width"] floatValue];
        img.picHeight = [dic[@"height"] floatValue];
        [pArr addObject:img];
    }
    avc.photoArr = pArr;
    [self presentViewController:avc animated:NO completion:nil];
}

- (void)backAction
{
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    [self.navigationController popViewControllerAnimated:YES];
}

/*
- (CGFloat)heightForTitleLabelWithString:(NSString *)string font:(UIFont *)font dx:(NSInteger)dx
{
    CGRect rect = [string boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - dx, 20000) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
    return rect.size.height;
}
*/
 
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat offSet = self.scroolView.contentOffset.y;
    CGFloat height = width * 0.6;
    if (offSet >= height - 64)
    {
        CGFloat point = offSet - (height - 64);
        self.topImageView.topY = point;
    }
    else
    {
        self.topImageView.topY = 0;
    }
}

- (void)jumpToMap
{
    TTMapViewController *map = [[TTMapViewController alloc]init];
    map.destinationLati = self.lati;
    map.destinationLongi = self.longi;
    map.icon_type = [NSString stringWithFormat:@"%ld", self.icon_type];
    map.topic = self.topic;
    map.mID = self.idString;
    if (![self.visit_tip isEqual:[NSNull null]])
    {
        if ([self.visit_tip isEqualToString:@""])
        {
            map.visit_tip = self.city;
        } else {
            map.visit_tip = [[self.city stringByAppendingString:@"･建议玩"] stringByAppendingString:self.visit_tip];
        }
    }
    [self presentViewController:map animated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
