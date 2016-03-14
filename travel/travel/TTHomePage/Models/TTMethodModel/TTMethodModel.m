//
//  TTMethodModel.m
//  TravelTogether
//
//  Created by Winston on 16/3/3.
//
//

#import "TTMethodModel.h"

@implementation TTMethodModel

- (void)setValue:(id)value forKey:(NSString *)key
{
    [super setValue:value forKey:key];
    if([key isEqualToString:@"description"])
    {
        self.ADescription = value;
    }
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end
