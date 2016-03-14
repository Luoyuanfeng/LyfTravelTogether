//
//  TTLocalTacticCell.h
//  TravelTogether
//
//  Created by 罗元丰 on 16/3/2.
//
//

#import <UIKit/UIKit.h>

@class TTLocalTacticModel;

@interface TTLocalTacticCell : UITableViewCell

/** 景点图片 */
@property (weak, nonatomic) IBOutlet UIImageView *localImgView;

/** 景点名 */
@property (weak, nonatomic) IBOutlet UILabel *areaNameLabel;

/** 旅行灵感 */
@property (weak, nonatomic) IBOutlet UILabel *travelIdeaLabel;

/** 模型 */
@property (nonatomic, strong) TTLocalTacticModel *ltModel;

@end
