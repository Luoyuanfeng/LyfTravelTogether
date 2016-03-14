//
//  TTFriendListCell.m
//  TravelTogether
//
//  Created by 罗元丰 on 16/3/9.
//
//

#import "TTFriendListCell.h"
#import "TTFriendListModel.h"

@implementation TTFriendListCell

- (void)awakeFromNib
{
    
}

- (void)setModel:(TTFriendListModel *)model
{
    _model = model;
    self.userPhotoImgView.image = model.friendPhoto;
    self.uerNameLabel.text = model.friendName;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
