//
//  TTTacticDetailCell.m
//  TravelTogether
//
//  Created by 马占臣 on 16/3/2.
//
//

#import "TTTacticDetailCell.h"
#import "TTTacticDetailModel.h"

@implementation TTTacticDetailCell

- (void)awakeFromNib
{
    
}

- (void)setModel:(TTTacticDetailModel *)model
{
    _model = model;
    self.topicLabel.text = model.topic;
    if (model.icon_type == 0)
    {
        self.iconImage.image = [UIImage imageNamed:@"icon_plan_cell_restaurant"];
    } else if (model.icon_type == 1)
    {
        self.iconImage.image = [UIImage imageNamed:@"icon_plan_cell_hotel"];
    } else if (model.icon_type == 2)
    {
        self.iconImage.image = [UIImage imageNamed:@"icon_plan_cell_attraction"];
    }
    [self setDetailViewWithModel:_model];
}

- (void)setDetailViewWithModel:(TTTacticDetailModel *)model
{
    UIView *cellView = [[UIView alloc]init];
    cellView.tag = 111;
    CGFloat imgHeight = self.contentView.width / 2;
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.contentView.width, imgHeight)];
    [imgView sd_setImageWithURL:[NSURL URLWithString:self.model.photo_url] placeholderImage:nil];
    imgView.userInteractionEnabled = YES;
    
    UILabel *introduceLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, imgView.bottomY + 10, self.contentView.width - 20, 20)];
    introduceLabel.numberOfLines = -1;
    
    NSString *labelText = self.model.introduce;
    // label 行间距
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    //调整行间距
    [paragraphStyle setLineSpacing:5];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    
    introduceLabel.attributedText = attributedString;
    introduceLabel.font = [UIFont systemFontOfSize:14];
//    CGRect rect =  [self.model.introduce boundingRectWithSize:CGSizeMake(self.contentView.width, 20000) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]} context:nil];
    [introduceLabel sizeToFit];
    introduceLabel.height = introduceLabel.frame.size.height;
    introduceLabel.userInteractionEnabled = YES;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:@"查看攻略与游记" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.frame = CGRectMake(10, introduceLabel.bottomY + 12, self.contentView.width - 20, 30);
    btn.layer.borderWidth = 1;
    btn.layer.borderColor = [UIColor blackColor].CGColor;
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 10;
    
    UITapGestureRecognizer *enabledNoTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(enabledNoTap)];
    [introduceLabel addGestureRecognizer:enabledNoTap];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(moreTacticsAction)];
    [imgView addGestureRecognizer:tap];
    [btn addTarget:self action:@selector(moreTacticsAction) forControlEvents:UIControlEventTouchUpInside];
    
    [cellView addSubview:imgView];
    [cellView addSubview:introduceLabel];
    [cellView addSubview:btn];

    // 利用model保存行高
    model.heightForCell = introduceLabel.height + imgHeight + 120;
    [cellView setFrame:CGRectMake(0, 45, self.contentView.width, model.heightForCell - 45)];
    self.cellView = cellView;
}

- (void)moreTacticsAction
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(loadMoreTacticsForCell:)])
    {
        [self.delegate loadMoreTacticsForCell:self];
    }
}

- (void)enabledNoTap
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(enabledNo)])
    {
        [self.delegate enabledNo];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
