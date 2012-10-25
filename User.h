//
//  User.h
//  PaperPlate
//
//  Created by Scot Lawrie on 10/13/12.
//  Copyright (c) 2012 Scot Lawrie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSManagedObject

@property (nonatomic) int uid;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;

-(void)awakeFromInsert;

@end
