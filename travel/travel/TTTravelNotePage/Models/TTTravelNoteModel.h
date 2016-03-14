//
//  TTTravelNoteModel.h
//  TravelTogether
//
//  Created by Winston on 16/3/1.
//
//

#import <Foundation/Foundation.h>

@interface TTTravelNoteModel : NSObject

/** loopPic标题 */
@property (nonatomic, copy) NSString *loopTitle;

/** loopPic description */
@property (nonatomic, copy) NSString *loopDescription;

/** TravelNote标题 */
@property (nonatomic, copy) NSString *noteTitle;
/** TravelNote内容*/
@property (nonatomic,copy)  NSString *noteDetail;
/** 第一张大图的size*/
@property(nonatomic, assign) CGSize size;
/** 所有图片链接的数组*/
@property (nonatomic, strong) NSMutableArray *imageUrlArray;


/** label高度 */
@property (nonatomic, assign) CGFloat currentLabelHeight;
/** 保存高度 */
@property (nonatomic, assign) CGFloat heightForCell;

/** 全文开关 */
@property (nonatomic, assign) BOOL isOpen;


+ (CGFloat)heightForTitleLabelWithString:(NSString *)string font:(UIFont *)font;

@end
