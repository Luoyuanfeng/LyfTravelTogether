//
//  TTTacticDetailModel.m
//  TravelTogether
//
//  Created by 马占臣 on 16/3/2.
//
//

#import "TTTacticDetailModel.h"

@implementation TTTacticDetailModel

- (void)setValue:(id)value forKey:(NSString *)key
{
    [super setValue:value forKey:key];
    if ([key isEqualToString:@"description"])
    {
        _TTDescription = value;
    }
    else if([key isEqualToString: @"id"])
    {
        _dID = value;
    }
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}



@end
