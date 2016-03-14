//
//  TTSearchBar.h
//  TravelTogether
//
//  Created by 罗元丰 on 16/3/3.
//
//

typedef void(^searchFieldRevolkBlock)(UITextField *);

#import <UIKit/UIKit.h>

@protocol TTSearchBarCancelActionDelegate <NSObject>

/**
 * 点击取消按钮时的响应事件代理
 **/
- (void)cancelBtnDidClicked;

@end

@interface TTSearchBar : UISearchBar

/** 代理 */
@property (nonatomic, assign) id<TTSearchBarCancelActionDelegate> cancelBtnDeleagte;

/** 文本框回调 */
@property (nonatomic, copy) searchFieldRevolkBlock block;

@end
