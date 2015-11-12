//
//  StoreDAO.h
//  CouponApp
//
//  Created by 杉浦 正光 on 2013/05/08.
//
//

#import <Foundation/Foundation.h>
#import "FMDatabase/FMDatabase.h"
#import "StoreDB.h"

// COLUMN
#define COLUMN_ID           @"id"
#define COLUMN_SHOPNAME     @"shopname"
#define COLUMN_CATEGORY     @"category"
#define COLUMN_SHOPINFO     @"shopinfo"
#define COLUMN_LATITUDE     @"latitude"
#define COLUMN_LONGITUDE    @"longitude"
#define COLUMN_OPENINGHOURS @"openinghours"
#define COLUMN_PARKING      @"parking"
#define COLUMN_DRIVETHROUGH @"drivethrough"
#define COLUMN_TABLESEATS   @"tableseats"
#define COLUMN_FOODPACK     @"foodpack"
#define COLUMN_EMONEY       @"emoney"


@interface StoreDAO : NSObject{
    FMDatabase *db_;
    BOOL success_;
}
@property (nonatomic)BOOL success;
@property (nonatomic, retain)FMDatabase *db;

- (BOOL)insertFeedList:(NSArray *)data;
- (void)insert:(NSDictionary *)data;
- (void)dbClose;
- (NSMutableArray *)findStore:(NSDictionary *)point;
- (void)deleteStore;



@end
