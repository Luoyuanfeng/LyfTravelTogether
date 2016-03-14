//
//  TTFriendListCell.h
//  TravelTogether
//
//  Created by 罗元丰 on 16/3/9.
//
//

#import <UIKit/UIKit.h>

@class TTFriendListModel;

@interface TTFriendListCell : UITableViewCell

/** 用户头像 */
@property (weak, nonatomic) IBOutlet UIImageView *userPhotoImgView;

/** 用户名 */
@property (weak, nonatomic) IBOutlet UILabel *uerNameLabel;

/** 用户数据模型 */
@property (nonatomic, strong) TTFriendListModel *model;

@end
