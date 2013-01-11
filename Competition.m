//
//  Competition.m
//  PaperPlate
//
//  Created by Scot Lawrie on 12/2/12.
//  Copyright (c) 2012 Scot Lawrie. All rights reserved.
//

#import "Competition.h"

@implementation Competition


static NSString *tableName = @"competitions";


@synthesize game=_game;
@synthesize desc=_desc;
@synthesize id=_id;


+(NSString *)tableName
{
    return tableName;
}

@end
