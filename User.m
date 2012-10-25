//
//  User.m
//  PaperPlate
//
//  Created by Scot Lawrie on 10/13/12.
//  Copyright (c) 2012 Scot Lawrie. All rights reserved.
//

#import "User.h"

@implementation User

@synthesize uid=_uid;
@synthesize firstName=_firstName;
@synthesize lastName=_lastName;

-(void)awakeFromInsert
{
    self.uid = [[NSUserDefaults standardUserDefaults] stringForKey:@"uid"].intValue;
    NSString *url = [NSString stringWithFormat:@"http://localhost/paperplate/users?handle=%@&uid=%d", [[NSUserDefaults standardUserDefaults]  stringForKey:@"handle"], self.uid];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    //NSString *get = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    NSMutableDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData: response options: NSJSONReadingMutableContainers error: nil];
    [self setValue:[jsonDict objectForKey:@"first_name"] forKey:@"firstName"];
    [self setValue:[jsonDict objectForKey:@"last_name"] forKey:@"lastName"];
}

@end
