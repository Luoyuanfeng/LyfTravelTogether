//
//  TTLocalNoteCell.h
//  TravelTogether
//
//  Created by 罗元丰 on 16/3/2.
//
//

#import <UIKit/UIKit.h>

@protocol imgViewInCellDelegate <NSObject>

@optional
/**
 * imgView被点击时的代理方法
 **/
- (void)imgViewBeTaped:(UIImageView *)imgView;

@end

@class TTImageView;

@interface TTLocalNoteCell : UITableViewCell

/** 标题 */
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;

/** 图片 */
@property (nonatomic, weak) IBOutlet TTImageView *imgView;

/** 内容 */
@property (nonatomic, weak) IBOutlet UILabel *contentLabel;

/** 更多游记 */
@property (nonatomic, weak) IBOutlet UIButton *moreBtn;

/** 数据字典 */
@property (nonatomic, strong) NSDictionary *dataDic;

/** 代理 */
@property (nonatomic, assign) id<imgViewInCellDelegate> delegate;

@end
