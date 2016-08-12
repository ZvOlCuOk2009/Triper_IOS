//
//  TSSearch.h
//  Triper_IOS
//
//  Created by Mac on 12.08.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSSearch : NSObject

+ (NSMutableArray *)calculationSearchArray:(NSArray *)incomingArray
                                      text:(NSString *)searchString;

@end
