//
//  TTHomeCell.m
//  TravelTogether
//
//  Created by 罗元丰 on 16/3/1.
//
//

#import "TTHomeCell.h"
#import "TTHomeModel.h"

@implementation TTHomeCell

- (void)awakeFromNib
{
    self.backgroundColor = [UIColor whiteColor];
}

- (void)setHomeModel:(TTHomeModel *)homeModel
{
    _homeModel = homeModel;
    
    [self.imageView sd_setImageWithURL: [NSURL URLWithString:homeModel.photo_url]];
    self.cityLibel.text = homeModel.name;
    self.cityInEnglishLabel.text = homeModel.name_en;
}

@end
