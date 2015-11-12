//
//  DetailDAO.h
//  CouponApp3
//
//  Created by 杉浦 正光 on 2013/06/10.
//
//

#import <Foundation/Foundation.h>
#import "FMDatabase/FMDatabase.h"
#import "StoreDB.h"

// COLUMN
#define COLUMN_ID            @"id"
#define COLUMN_SHOPNAME      @"shopname"
#define COLUMN_OPENING_HOURS @"openinghours"
#define COLUMN_ADDRESS       @"address"
#define COLUMN_TEL           @"tel"
#define COLUMN_LATITUDE      @"latitude"
#define COLUMN_LONGITUDE     @"longitude"
#define COLUMN_NAVITIME_ID   @"navitimeid"
#define COLUMN_OPEN24H       @"open24h"
#define COLUMN_PARKING       @"parking"
#define COLUMN_DRIVETHROUGH  @"drivethrough"
#define COLUMN_TABLESEATS    @"tableseats"
#define COLUMN_FOODPACK      @"foodpack"
#define COLUMN_EMONEY        @"emoney"


@interface DetailDAO : NSObject{

    FMDatabase *db_;
    BOOL success_;
}
@property (nonatomic) BOOL success;
@property (nonatomic ,retain) FMDatabase *db;

- (void)insertInfo:(NSDictionary *)data;
- (BOOL)insertInfoList:(NSArray *)data;
- (void)dbClose;
- (NSDictionary *)findIdshopInfo:(NSString *)shopid;
- (BOOL)deleteStoreInfo;

@end
