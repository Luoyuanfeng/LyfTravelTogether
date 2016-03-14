//
//  TTSearchFriendCell.m
//  TravelTogether
//
//  Created by 罗元丰 on 16/3/8.
//
//

#import "TTSearchFriendCell.h"

@implementation TTSearchFriendCell

- (void)awakeFromNib
{
    
}

#pragma mark - 点击“+ 好友”按钮时的点击事件
- (IBAction)addFriendAction:(UIButton *)sender
{
    if(self.afDelegate && [self.afDelegate respondsToSelector:@selector(addFriendInCell:)])
    {
        [self.afDelegate addFriendInCell:self];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
