//
//  TSSearch.m
//  Triper_IOS
//
//  Created by Mac on 12.08.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#import "TSSearch.h"
#import "TSParsingUserName.h"

@implementation TSSearch

+ (NSMutableArray *)calculationSearchArray:(NSArray *)incomingArray
                                      text:(NSString *)searchString
{
    NSMutableArray *searhArray = [NSMutableArray array];
    NSMutableArray *tempArray = [NSMutableArray array];
    
    NSString *foundString = nil;
    NSString *curString = nil;
    NSInteger counter = 0;
    
    NSMutableArray *userNames = [TSParsingUserName parsingOfTheUserName:incomingArray];
    
    for (int i = 0; i < [userNames count]; i++) {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains[cd] %@", searchString];
        NSArray *intermediateArray = [userNames filteredArrayUsingPredicate:predicate];
        
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
