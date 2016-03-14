//
//  TTAlbunViewController.h
//  TravelTogether
//
//  Created by 罗元丰 on 16/3/3.
//
//

#import <UIKit/UIKit.h>

@interface TTAlbunViewController : UIViewController

/** 图片数组 */
@property (nonatomic, strong) NSArray *photoArr;

/** 点击第几张图 */
@property (nonatomic, assign) NSInteger index;

@end
