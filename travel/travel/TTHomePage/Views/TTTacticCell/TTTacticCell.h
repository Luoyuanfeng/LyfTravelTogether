//
//  TTTacticCell.h
//  TravelTogether
//
//  Created by 马占臣 on 16/3/1.
//
//

#import <UIKit/UIKit.h>

@class TTTacticModel;
@interface TTTacticCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *line;

/** 标题label */
@property (weak, nonatomic) IBOutlet UILabel *topicLabel;

/** 旅行灵感label */
@property (weak, nonatomic) IBOutlet UILabel *inspirationLabel;

/** cell背景图片 */
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;


@property (weak, nonatomic) IBOutlet UIView *blackView;

/** Model */
@property (nonatomic, strong) TTTacticModel *tactic;


@end
