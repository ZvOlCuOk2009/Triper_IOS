//
//  TSParsingUserName.m
//  Triper_IOS
//
//  Created by Mac on 17.08.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#import "TSParsingUserName.h"

@implementation TSParsingUserName

+ (NSMutableArray *)parsingOfTheUserName:(NSArray *)friends
{
    NSMutableArray *namesArray = [NSMutableArray array];
    
    for (int i = 0; i < [friends count]; i++) {
        NSDictionary *data = [friends objectAtIndex:i];
        NSArray *dataName = [data objectForKey:@"items"];
        NSString *name = [dataName objectAtIndex:0];
        [namesArray addObject:name];
    }
    return namesArray;
}

@end
