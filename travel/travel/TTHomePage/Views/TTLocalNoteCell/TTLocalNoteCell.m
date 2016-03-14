//
//  TTLocalNoteCell.m
//  TravelTogether
//
//  Created by 罗元丰 on 16/3/2.
//
//

#import "TTLocalNoteCell.h"
#import "TTImageView.h"

@implementation TTLocalNoteCell

- (void)awakeFromNib
{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    self.titleLabel.text = dataDic[@"topic"];
    [self.imgView sd_setImageWithURL: [NSURL URLWithString:[dataDic[@"contents"]firstObject][@"photo_url"]]];
    self.imgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.imgView addGestureRecognizer:tap];
    self.contentLabel.text = dataDic[@"description"];
}

- (void)tapAction
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(imgViewBeTaped:)])
    {
        [self.delegate imgViewBeTaped: self.imgView];
    }
}

@end
