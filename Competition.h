//
//  Competition.h
//  PaperPlate
//
//  Created by Scot Lawrie on 12/2/12.
//  Copyright (c) 2012 Scot Lawrie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ActiveRecord.h"

@interface Competition : ActiveRecord


@property (nonatomic) int id;
@property (nonatomic, strong) NSString *game;
@property (nonatomic, strong) NSString *desc;

+(NSString *)tableName;


@end
