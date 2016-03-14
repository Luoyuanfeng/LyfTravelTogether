//
//  TTTacticDetailCell.h
//  TravelTogether
//
//  Created by 马占臣 on 16/3/2.
//
//

#import <UIKit/UIKit.h>

@class TTTacticDetailCell;

@protocol loadMoreTacticsDelegate <NSObject>

@optional

- (void)loadMoreTacticsForCell:(TTTacticDetailCell *)cell;

- (void)enabledNo;

@end

@class TTTacticDetailModel;

@interface TTTacticDetailCell : UITableViewCell

/** 底部分割线 */
@property (weak, nonatomic) IBOutlet UIView *bottomLine;

/** 图标 */
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;

/** 标题label */
@property (weak, nonatomic) IBOutlet UILabel *topicLabel;

/** 模型 */
@property (nonatomic, strong)TTTacticDetailModel *model;

/** 代理 */
@property (nonatomic, assign) id<loadMoreTacticsDelegate> delegate;

/** 点击cell展开的ciew */
@property (nonatomic, strong) UIView *cellView;

@end
