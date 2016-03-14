//
//  TTLoopPicDetailDesCell.m
//  TravelTogether
//
//  Created by 马占臣 on 16/3/9.
//
//

#import "TTLoopPicDetailDesCell.h"
#import "TTTravelNoteModel.h"

@interface TTLoopPicDetailDesCell ()

/** title label */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

/** description label */
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

/** descriptionLabel 的高度约束 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightForDescriptionLabel;


@end

@implementation TTLoopPicDetailDesCell

- (void)awakeFromNib
{

}

- (void)setModel:(TTTravelNoteModel *)model
{
    self.titleLabel.text = model.loopTitle;
    NSString *labelText = model.loopDescription;
    self.descriptionLabel.font = [UIFont systemFontOfSize:14];
    self.descriptionLabel.numberOfLines = 0;
    
    // label 行间距
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    //调整行间距
    [paragraphStyle setLineSpacing:5];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    
    self.descriptionLabel.attributedText = attributedString;
    [self.descriptionLabel sizeToFit];
    self.heightForDescriptionLabel.constant = self.descriptionLabel.frame.size.height;
    model.heightForCell = self.descriptionLabel.frame.size.height + 56;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
