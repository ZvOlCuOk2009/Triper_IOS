//
//  TSSearch.m
//  Triper_IOS
//
//  Created by Mac on 12.08.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#import "TSSearch.h"

@implementation TSSearch

+ (NSMutableArray *)calculationSearchArray:(NSArray *)incomingArray
                                      text:(NSString *)searchString
{
    NSMutableArray *searhArray = [NSMutableArray array];
    NSMutableArray *namesArray = [NSMutableArray array];
    NSMutableArray *tempArray = [NSMutableArray array];
    
    NSString *foundString = nil;
    NSString *curString = nil;
    NSInteger counter = 0;
    
    for (int i = 0; i < [incomingArray count]; i++) {
        NSDictionary *data = [incomingArray objectAtIndex:i];
        NSArray *dataName = [data objectForKey:@"items"];
        NSString *name = [dataName objectAtIndex:0];
        [namesArray addObject:name];
    }
    
    for (int i = 0; i < [namesArray count]; i++) {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains[cd] %@", searchString];
        NSArray *intermediateArray = [namesArray filteredArrayUsingPredicate:predicate];
        
        if ([intermediateArray count] > 0 && counter < [intermediateArray count]) {
            ++counter;
            NSString *currentName = [intermediateArray objectAtIndex:i];
            
            if (![currentName isEqualToString:foundString]) {
                
                for (NSDictionary *friend in [incomingArray reverseObjectEnumerator]) {
                    NSArray *dataNameFriend = [friend objectForKey:@"items"];
                    NSString *name = [dataNameFriend objectAtIndex:0];
                    curString = [NSString stringWithString:currentName];
                    
                    if ([name isEqualToString:currentName]) {
                        [searhArray addObject:friend];
                        foundString = [NSString stringWithString:name];
                    }
                }
            }
        }
    }
    tempArray = [NSMutableArray arrayWithArray:searhArray];
    [searhArray removeAllObjects];
    
    return tempArray;
}


@end
