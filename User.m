//
//  User.m
//  PaperPlate
//
//  Created by Scot Lawrie on 10/13/12.
//  Copyright (c) 2012 Scot Lawrie. All rights reserved.
//

#import "User.h"

@implementation User

static NSString *tableName = @"users";

@synthesize first_name=_first_name;
@synthesize last_name=_last_name;
@synthesize email=_email;
@synthesize id=_id;



+(User *)getUser
{
    NSString *uidstr;
    if ((uidstr = [[NSUserDefaults standardUserDefaults] stringForKey:@"uid"]))
    {
        NSDictionary *conditions = [NSDictionary dictionaryWithObjectsAndKeys:uidstr, @"id", nil];
        User *user = [self getWhere:conditions];
        return user;
    }
    else
    {
        return false;
    }
   
}

+(NSString *)tableName
{
    return tableName;
}






@end
