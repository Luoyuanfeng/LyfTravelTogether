//
//  TTLocalTacticCell.m
//  TravelTogether
//
//  Created by 罗元丰 on 16/3/2.
//
//

#import "TTLocalTacticCell.h"
#import "TTLocalTacticModel.h"

@implementation TTLocalTacticCell

- (void)awakeFromNib
{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setLtModel:(TTLocalTacticModel *)ltModel
{
    _ltModel = ltModel;
    [self.localImgView sd_setImageWithURL: [NSURL URLWithString: ltModel.photo_url]];
    self.areaNameLabel.text = ltModel.name;
    self.travelIdeaLabel.text = [NSString stringWithFormat:@"%@条旅行灵感", ltModel.inspiration_activities_count];
}

@end
