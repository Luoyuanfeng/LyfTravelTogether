//
//  TTHomeModel.m
//  TravelTogether
//
//  Created by 罗元丰 on 16/3/1.
//
//

#import "TTHomeModel.h"

@implementation TTHomeModel

- (void)setValue:(id)value forKey:(NSString *)key
{
    [super setValue:value forKey:key];
    if([key isEqualToString: @"id"])
    {
        self.LID = [value integerValue];
    }
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end
