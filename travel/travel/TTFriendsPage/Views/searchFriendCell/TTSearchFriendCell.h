//
//  TTSearchFriendCell.h
//  TravelTogether
//
//  Created by 罗元丰 on 16/3/8.
//
//

#import <UIKit/UIKit.h>

@class TTSearchFriendCell;

@protocol addFriendDelegate <NSObject>

/**
 * 添加好友
 **/
- (void)addFriendInCell:(TTSearchFriendCell *)cell;

@end

@interface TTSearchFriendCell : UITableViewCell

/** 显示用户名 */
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

/** 用户头像 */
@property (weak, nonatomic) IBOutlet UIImageView *photoView;

/** 代理 */
@property (nonatomic, assign) id<addFriendDelegate> afDelegate;

@end
