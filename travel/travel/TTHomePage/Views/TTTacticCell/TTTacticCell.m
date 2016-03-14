//
//  TTTacticCell.m
//  TravelTogether
//
//  Created by 马占臣 on 16/3/1.
//
//

#import "TTTacticCell.h"
#import "TTTacticModel.h"

@implementation TTTacticCell

- (void)setTactic:(TTTacticModel *)tactic
{
    _tactic = tactic;
    self.topicLabel.text = tactic.topic;
    self.inspirationLabel.text = [NSString stringWithFormat:@"-%zd条旅行灵感-", tactic.inspiration_activities_count];
    [self.backgroundImageView sd_setImageWithURL:[NSURL URLWithString:tactic.photo_url] placeholderImage:nil];
    self.blackView.backgroundColor = [UIColor colorWithWhite:0.010 alpha:0.3];
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
