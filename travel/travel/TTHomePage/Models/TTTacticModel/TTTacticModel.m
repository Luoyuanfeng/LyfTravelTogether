//
//  TTTacticModel.m
//  TravelTogether
//
//  Created by 马占臣 on 16/3/1.
//
//

#import "TTTacticModel.h"

@implementation TTTacticModel

- (void)setValue:(id)value forKey:(NSString *)key
{
    [super setValue:value forKey:key];
    if([key isEqualToString: @"id"])
    {
        self.tID = [value integerValue];
    }
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end
