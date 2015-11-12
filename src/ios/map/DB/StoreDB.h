//
//  StoreDB.h
//  CouponApp
//
//  Created by 杉浦 正光 on 2013/05/08.
//
//

#import <Foundation/Foundation.h>
#import "FMDatabase/FMDatabase.h"

#define DATABASE_NAME @"storeDB.sqlite"

@interface StoreDB : NSObject{
    FMDatabase *db_;
    
}
- (FMDatabase *)createDB;
@end
