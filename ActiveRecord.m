//
//  ActiveRecord.m
//  PaperPlate
//
//  Created by Scot Lawrie on 10/25/12.
//  Copyright (c) 2012 Scot Lawrie. All rights reserved.
//

#import "ActiveRecord.h"
#import "AppDelegate.h"

@implementation ActiveRecord

static NSManagedObjectContext *moc = nil;
static NSString *root_url = @"http://localhost/paperplate2/";

+(void)initialize
{
    if(!moc)
    {
        moc = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    }
}

+(id)getWhere:(NSDictionary *)conditions
{
    NSArray *raw = [self sendRequestWithConditions:conditions];
    NSDictionary *results = [raw objectAtIndex:0];
    id object = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([self class]) inManagedObjectContext:moc];
    return [self mapDictionary:results toObject:object];
}

+(id)sendRequestWithConditions:(NSDictionary *)conditions
{
    NSString *tableName = [self valueForKey:@"tableName"];
    NSString *credentials = [self getCredentials];
    NSString *queryString = [[NSString alloc] init];
    NSString *url;
    if([conditions count]>0)
    {
        for(NSString *key in conditions)
        {
            queryString = [NSString stringWithFormat:@"%@&%@=%@", queryString, key, [conditions objectForKey:key]];
        }
        url = [NSString stringWithFormat:@"%@%@?%@%@", root_url, tableName, credentials, queryString];
    }
    else
    {
        url = [NSString stringWithFormat:@"%@%@?%@", root_url, tableName, credentials];
    }

    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    return [NSJSONSerialization JSONObjectWithData: response options: NSJSONReadingMutableContainers error: nil];
}

+(id)getByID:(int)userID
{
    NSString *stringUid = [NSString stringWithFormat:@"%d", userID];
    NSDictionary *conditions = [NSDictionary dictionaryWithObjectsAndKeys:@"id", stringUid, nil];
    id newObject = [self getWhere:conditions];
    return newObject;
}

+(NSMutableArray *)getAllWhere:(NSDictionary *)conditions
{
    NSArray *results = [self sendRequestWithConditions:conditions];
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    for(NSDictionary *dict in results)
    {
        id object = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([self class]) inManagedObjectContext:moc];
        object = [self mapDictionary:dict toObject:object];
        [objects addObject:object];
    }
    return objects;
}

+(NSMutableArray *)getAll
{
    return [self getAllWhere:[[NSDictionary alloc] init]];
}

+(id)create:(NSDictionary *)conditions
{
    NSString *tableName = [self valueForKey:@"tableName"];
    NSString *credentials = [self getCredentials];
    NSString *queryString = [[NSString alloc] init];
    NSString *url;
    if([conditions count]>0)
    {
        for(NSString *key in conditions)
        {
            queryString = [NSString stringWithFormat:@"%@&%@=%@", queryString, key, [conditions objectForKey:key]];
        }
        url = [NSString stringWithFormat:@"%@%@/create?%@%@", root_url, tableName, credentials, queryString];
    }
    else
    {
        url = [NSString stringWithFormat:@"%@%@/create?%@", root_url, tableName, credentials];
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary *results = [NSJSONSerialization JSONObjectWithData: response options: NSJSONReadingMutableContainers error: nil];
    if([[results objectForKey:@"success"] isEqualToString:@"true"])
    {
        id object = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([self class]) inManagedObjectContext:moc];
        NSDictionary *objectDict = [results objectForKey:@"Object"];
        return [self mapDictionary:objectDict toObject:object];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Error Creating Object in %@",tableName] message:[results objectForKey:@"reason"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return false;
    }


}

+(id)mapDictionary:(NSDictionary *)dict toObject:(id)object
{
    for(NSString *field in dict)
    {
        NSString *setterStr = [NSString stringWithFormat:@"set%@%@:",
                               [[field substringToIndex:1] capitalizedString],
                               [field substringFromIndex:1]];
        if ([object respondsToSelector:NSSelectorFromString(setterStr)])
        {
            [object setValue:[dict objectForKey:field] forKey:field];
        }
    }
    return object;
}

+(NSString *)getCredentials
{
    return [NSString stringWithFormat:@"uid=%@&handle=%@",[[NSUserDefaults standardUserDefaults]  stringForKey:@"uid"], [[NSUserDefaults standardUserDefaults]  stringForKey:@"handle"]];
}

@end
