//
//  TTHomeCell.h
//  TravelTogether
//
//  Created by 罗元丰 on 16/3/1.
//
//

#import <UIKit/UIKit.h>
@class TTHomeModel;

@interface TTHomeCell : UICollectionViewCell

/** 景点图片 */
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

/** 城市名 */
@property (weak, nonatomic) IBOutlet UILabel *cityLibel;

/** 英文城市名 */
@property (weak, nonatomic) IBOutlet UILabel *cityInEnglishLabel;

/** 模型 */
@property (nonatomic, strong) TTHomeModel *homeModel;

@end
