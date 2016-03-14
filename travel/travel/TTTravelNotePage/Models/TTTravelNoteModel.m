//
//  TTTravelNoteModel.m
//  TravelTogether
//
//  Created by Winston on 16/3/1.
//
//

#import "TTTravelNoteModel.h"

@implementation TTTravelNoteModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

+ (CGFloat)heightForTitleLabelWithString:(NSString *)string font:(UIFont *)font
{
    CGRect rect = [string boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width-20, 20000) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
    return rect.size.height;
}

@end
