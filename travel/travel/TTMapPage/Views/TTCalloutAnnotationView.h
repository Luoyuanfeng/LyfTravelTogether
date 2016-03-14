//
//  TTCalloutAnnotationView.h
//  TravelTogether
//
//  Created by 马占臣 on 16/3/6.
//
//

#import <MAMapKit/MAMapKit.h>

#import "TTMapCalloutView.h"

@protocol setCalloutViewDelegate <NSObject>
/**
 *  设置代理为mapVC，将mapVC的image，topic，tip这些值传过来赋值给calloutView的image，topic，tip属性
 */
- (UIImage *)setImage;
- (NSString *)setTopicText;
- (NSString *)setTipText;

@end


@interface TTCalloutAnnotationView : MAAnnotationView

/** 自定义气泡AnnotationView */
@property (nonatomic, readwrite) TTMapCalloutView *calloutView;

/**
 *  annotationView的代理，遵守两个协议是为了给annotationView的calloutView的代理赋值为mapVC
 */
@property (nonatomic, assign)id<setCalloutViewDelegate, mapCalloutViewBtnDelegate> cvDelegate;



@end
