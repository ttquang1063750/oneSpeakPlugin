//
//  DetailDAO.m
//  CouponApp3
//
//  Created by 杉浦 正光 on 2013/06/10.
//
//

#import "DetailDAO.h"
#import "CommonUtilities.h"

@implementation DetailDAO
@synthesize success = success_;
@synthesize db = db_;

// 初期準備DBopen
- (id)init{
    if (self = [super init]) {
        
        db_ = [[StoreDB alloc] createDB];
    }
    return self;
}

// DBclose
- (void)dbClose{
    [db_ close];
}


/***********************************************************
 * テーブル store_info
 ***********************************************************/

// shopリストのinsert
- (BOOL)insertInfoList:(NSArray *)data{
    
    NSLog(@"DB insert 開始");
    
    // トランザクションの設定
    [db_ beginTransaction];
    
    success_ = YES;
    for (NSDictionary *shop in data) {
        [self insertInfo:shop];
    }
    
    if (success_) {
        [db_ commit];
    }
    else {
        // 失敗したらロールバック
        [db_ rollback];
    }
    return success_;
}

// レコードの追加 (テーブル store_info）
- (void)insertInfo:(NSDictionary *)data{
    
    // shopアイテムの取得
    NSString *shopid       = [data objectForKey:DETAIL_DICTIONARY_KEY_ID];
    NSString *shopname     = [data objectForKey:DETAIL_DICTIONARY_KEY_SHOPNAME];
    NSString *opening_hours= [data objectForKey:DETAIL_DICTIONARY_KEY_OPENING_HOURS];
    NSString *address      = [data objectForKey:DETAIL_DICTIONARY_KEY_ADDRESS];
    NSString *tel          = [data objectForKey:DETAIL_DICTIONARY_KEY_TEL];
    NSNumber *latitude     = [data objectForKey:DETAIL_DICTIONARY_KEY_LATITUDE];
    NSNumber *longitude    = [data objectForKey:DETAIL_DICTIONARY_KEY_LONGITUDE];
    NSString *navitimeId   = [data objectForKey:DETAIL_DICTIONARY_KEY_NAVITIME_ID];
    NSNumber *open24h      = [data objectForKey:DETAIL_DICTIONARY_KEY_OPEN24H];
    NSNumber *parking      = [data objectForKey:DETAIL_DICTIONARY_KEY_PARKING];
    NSNumber *drivethrough = [data objectForKey:DETAIL_DICTIONARY_KEY_DRIVETHROUGH];
    NSNumber *tableseats   = [data objectForKey:DETAIL_DICTIONARY_KEY_TABLESEATS];
    NSNumber *foodpack     = [data objectForKey:DETAIL_DICTIONARY_KEY_FOODPACK];
    NSNumber *e_money      = [data objectForKey:DETAIL_DICTIONARY_KEY_EMONEY];
    
    // columns作成
    NSString *columns = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@",
                         COLUMN_ID,
                         COLUMN_SHOPNAME,
                         COLUMN_OPENING_HOURS,
                         COLUMN_ADDRESS,
                         COLUMN_TEL,
                         COLUMN_LATITUDE,
                         COLUMN_LONGITUDE,
                         COLUMN_NAVITIME_ID,
                         COLUMN_OPEN24H,
                         COLUMN_PARKING,
                         COLUMN_DRIVETHROUGH,
                         COLUMN_TABLESEATS,
                         COLUMN_FOODPACK,
                         COLUMN_EMONEY];
    // sql作成
    NSString *sql = [NSString stringWithFormat:
                     @"INSERT INTO store_info(%@) VALUES(%@, '%@', '%@', '%@', '%@', %f, %f, '%@', %d, %d, %d, %d, %d, %d);",
                     columns,
                     shopid,
                     shopname,
                     opening_hours,
                     address,
                     tel,
                     [latitude doubleValue],
                     [longitude doubleValue],
                     navitimeId,
                     [open24h intValue],
                     [parking intValue],
                     [drivethrough intValue],
                     [tableseats intValue],
                     [foodpack intValue],
                     [e_money intValue]
                     ];
    
    if (![db_ executeUpdate:sql]) {
        // 失敗
        NSLog(@"insertInfo_ERROR: %d: %@", [db_ lastErrorCode], [db_ lastErrorMessage]);
        success_ = NO;
    }
}

// データの削除(テーブル store_info)
- (BOOL)deleteStoreInfo{
    
    success_ = YES;
    [db_ beginTransaction];
    
    NSString *sql = @"DELETE FROM store_info";
    
    if (![db_ executeUpdate:sql]) {
        // 失敗時
        NSLog(@"DELETE_ERROR: %d: %@", [db_ lastErrorCode], [db_ lastErrorMessage]);
        [db_ rollback];
        success_ = NO;
    }
    else {
        // 成功
        [db_ commit];
        success_ = YES;
    }
    return success_;
}

// Idからinfoデータの取得
- (NSDictionary *)findIdshopInfo:(NSString *)shopid{
    
    //編集用オブジェクト
    NSDictionary *shop = [NSDictionary dictionary];
    
    // sql作成
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM store_info WHERE id = %@;", shopid];
    
    FMResultSet *rs = [db_ executeQuery:sql];
    
    while ([rs next]) {
        
        shop = [NSDictionary dictionaryWithObjectsAndKeys:
                [rs stringForColumn:COLUMN_ID]           , DETAIL_DICTIONARY_KEY_ID,
                [rs stringForColumn:COLUMN_SHOPNAME]     , DETAIL_DICTIONARY_KEY_SHOPNAME,
                [rs stringForColumn:COLUMN_OPENING_HOURS], DETAIL_DICTIONARY_KEY_OPENING_HOURS,
                [rs stringForColumn:COLUMN_ADDRESS]      , DETAIL_DICTIONARY_KEY_ADDRESS,
                [rs stringForColumn:COLUMN_TEL]          , DETAIL_DICTIONARY_KEY_TEL,
                [rs stringForColumn:COLUMN_LATITUDE]     , DETAIL_DICTIONARY_KEY_LATITUDE,
                [rs stringForColumn:COLUMN_LONGITUDE]    , DETAIL_DICTIONARY_KEY_LONGITUDE,
                [rs stringForColumn:COLUMN_NAVITIME_ID]  , DETAIL_DICTIONARY_KEY_NAVITIME_ID,
                [rs stringForColumn:COLUMN_OPEN24H]      , DETAIL_DICTIONARY_KEY_OPEN24H,
                [rs stringForColumn:COLUMN_PARKING]      , DETAIL_DICTIONARY_KEY_PARKING,
                [rs stringForColumn:COLUMN_DRIVETHROUGH] , DETAIL_DICTIONARY_KEY_DRIVETHROUGH,
                [rs stringForColumn:COLUMN_TABLESEATS]   , DETAIL_DICTIONARY_KEY_TABLESEATS,
                [rs stringForColumn:COLUMN_FOODPACK]     , DETAIL_DICTIONARY_KEY_FOODPACK,
                [rs stringForColumn:COLUMN_EMONEY]       , DETAIL_DICTIONARY_KEY_EMONEY,
                nil];
        
        break;
    }
    
    if (![db_ executeQuery:sql]) {
        // 失敗時
        NSLog(@"QUERY_ERROR: %d: %@", [db_ lastErrorCode], [db_ lastErrorMessage]);
    }
    
    [rs close];
    return shop;
}


@end
