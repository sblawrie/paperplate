//
//  ActiveRecord.h
//  PaperPlate
//
//  Created by Scot Lawrie on 10/25/12.
//  Copyright (c) 2012 Scot Lawrie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActiveRecord : NSManagedObject

+(id)getWhere:(NSDictionary *)conditions;
+(id)getByID:(int)userID;
+(id)sendRequestWithConditions:(NSDictionary *)conditions;
+(NSMutableArray *)getAllWhere:(NSDictionary *)conditions;
+(NSMutableArray *)getAll;
+(NSString *)getCredentials;
+(id)create:(NSDictionary *)conditions;
+(id)mapDictionary:(NSDictionary *)dict toObject:(id)object;

@end
