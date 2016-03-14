//
//  LYFTTTravelNoteCell.h
//  TravelTogether
//
//  Created by 罗元丰 on 16/3/6.
//
//

#import <UIKit/UIKit.h>
#import "TTItemForCollectionViewInCell.h"

@protocol clickMainImgDelegate <NSObject>

@optional
/**
 * 点击大图时的动作
 **/
- (void)mainImageClickedByImageUrlArr:(NSArray *)imgArr andClickIndex:(NSInteger)index;

@end

@class TTTravelNoteModel;

@interface LYFTTTravelNoteCell : UITableViewCell

/** 标题 */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

/** 主要图片（大图） */
@property (weak, nonatomic) IBOutlet UIImageView *mainImgView;
/** 大图的高度约束 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mainImgHeight;

/** 小图片collectionView */
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

/** 游记内容 */
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

/** 模型 */
@property (nonatomic, strong) TTTravelNoteModel *model;

/** 点击大图代理 */
@property (nonatomic, assign) id<clickMainImgDelegate> clickDelegate;

@end
