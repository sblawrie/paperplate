//
//  User.h
//  PaperPlate
//
//  Created by Scot Lawrie on 10/13/12.
//  Copyright (c) 2012 Scot Lawrie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ActiveRecord.h"

@interface User : ActiveRecord

@property (nonatomic) int id;
@property (nonatomic, strong) NSString *first_name;
@property (nonatomic, strong) NSString *last_name;
@property (nonatomic, strong) NSString *email;

+(User *)getUser;
+(NSString *)tableName;



@end
