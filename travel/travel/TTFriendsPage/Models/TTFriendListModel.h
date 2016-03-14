//
//  TTFriendListModel.h
//  TravelTogether
//
//  Created by 罗元丰 on 16/3/9.
//
//

#import <Foundation/Foundation.h>

@interface TTFriendListModel : NSObject

/** 好友id */
@property (nonatomic, copy) NSString *friendId;

/** 好友昵称 */
@property (nonatomic, copy) NSString *friendName;

/** 好友头像 */
@property (nonatomic, strong) UIImage *friendPhoto;

@end
