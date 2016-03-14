//
//  TTLocalTacticModel.m
//  TravelTogether
//
//  Created by 罗元丰 on 16/3/2.
//
//

#import "TTLocalTacticModel.h"

@implementation TTLocalTacticModel

- (void)setValue:(id)value forKey:(NSString *)key
{
    [super setValue:value forKey:key];
    if([key isEqualToString: @"id"])
    {
        self.LocalID = value;
    }
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end
