//
//  StoreDAO.m
//  CouponApp
//
//  Created by 杉浦 正光 on 2013/05/08.
//
//

#import "StoreDAO.h"
#import "CommonUtilities.h"

@implementation StoreDAO
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
 * テーブル store
 ***********************************************************/

- (BOOL)insertFeedList:(NSArray *)data{
    
    NSLog(@"DB insert 開始");
    
    success_ = YES;
    
    [db_ beginTransaction];

    for (NSDictionary *shop in data) {
        [self insert:shop];
    }
    // 正常終了
    if (success_) {
        [db_ commit];
    }
    // 失敗したらロールバック
    else {
        
        [db_ rollback];
    }
    return success_;
}

// レコードの追加
- (void)insert:(NSDictionary *)data{
    
    // shopアイテムの取得
    NSString *shopid       = [data objectForKey:FEED_DICTIONARY_KEY_ID];
    NSString *shopname     = [data objectForKey:FEED_DICTIONARY_KEY_SHOPNAME];
    NSString *category     = [data objectForKey:FEED_DICTIONARY_KEY_CATEGORY];
    NSString *shopinfo     = [data objectForKey:FEED_DICTIONARY_KEY_SHOPINFO];
    NSNumber *latitude     = [data objectForKey:FEED_DICTIONARY_KEY_LATITUDE];
    NSNumber *longitude    = [data objectForKey:FEED_DICTIONARY_KEY_LONGITUDE];
    NSNumber *openinghours = [data objectForKey:FEED_DICTIONARY_KEY_OPENINGHOURS];
    NSNumber *parking      = [data objectForKey:FEED_DICTIONARY_KEY_PARKING];
    NSNumber *drivethrough = [data objectForKey:FEED_DICTIONARY_KEY_DRIVETHROUGH];
    NSNumber *tableseats   = [data objectForKey:FEED_DICTIONARY_KEY_TABLESEATS];
    NSNumber *foodpack     = [data objectForKey:FEED_DICTIONARY_KEY_FOODPACK];
    NSNumber *e_money      = [data objectForKey:FEED_DICTIONARY_KEY_EMONEY];
    
    // columnの作成
    NSString *columns = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@",
                         COLUMN_ID,
                         COLUMN_SHOPNAME,
                         COLUMN_CATEGORY,
                         COLUMN_SHOPINFO,
                         COLUMN_LATITUDE,
                         COLUMN_LONGITUDE,
                         COLUMN_OPENINGHOURS,
                         COLUMN_PARKING,
                         COLUMN_DRIVETHROUGH,
                         COLUMN_TABLESEATS,
                         COLUMN_FOODPACK,
                         COLUMN_EMONEY];
    
    // sql作成
    NSString *sql = [NSString stringWithFormat:
                     @"INSERT INTO store(%@) VALUES(%@, '%@', '%@', '%@', %f, %f, %d, %d, %d, %d, %d, %d);",
                     columns,
                     shopid,
                     shopname,
                     category,
                     shopinfo,
                     [latitude doubleValue],
                     [longitude doubleValue],
                     [openinghours intValue],
                     [parking intValue],
                     [drivethrough intValue],
                     [tableseats intValue],
                     [foodpack intValue],
                     [e_money intValue]
                     ];
    
    if (![db_ executeUpdate:sql]) {
        // 失敗
        NSLog(@"ERROR: %d: %@", [db_ lastErrorCode], [db_ lastErrorMessage]);
        success_ = NO;
    }
    
}

// データの削除(テーブル store)
- (void)deleteStore{

    NSString *sql = @"DELETE FROM store";
    
    if (![db_ executeUpdate:sql]) {
        // 失敗時
        NSLog(@"DELETE_ERROR: %d: %@", [db_ lastErrorCode], [db_ lastErrorMessage]);
    }
}

/*******************************************************
 *
 *******************************************************/

// レコードの検索（現在地から近い順にソートする）
- (NSMutableArray *)findStore:(NSDictionary *)point{
    
    NSNumber *cLatitude  = [point objectForKey:@"cLatitude"];
    NSNumber *cLongitude = [point objectForKey:@"cLongitude"];
    NSNumber *sLatitude  = [point objectForKey:@"sLatitude"];
    NSNumber *sLongitude = [point objectForKey:@"sLongitude"];
    NSNumber *nLatitude  = [point objectForKey:@"nLatitude"];
    NSNumber *nLongitude = [point objectForKey:@"nLongitude"];
    
    // sql文作成
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM store WHERE (latitude BETWEEN %f AND %f) AND (longitude BETWEEN %f AND %f) ORDER BY (latitude - %f)*(latitude - %f) + (longitude - %f)*(longitude - %f)asc;",[sLatitude doubleValue], [nLatitude doubleValue], [nLongitude doubleValue], [sLongitude doubleValue], [cLatitude doubleValue], [cLatitude doubleValue], [cLongitude doubleValue], [cLongitude doubleValue]];
    
    //    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM store WHERE (latitude BETWEEN %f AND %f) AND (longitude BETWEEN %f AND %f);",[sLatitude doubleValue], [nLatitude doubleValue], [nLongitude doubleValue], [sLongitude doubleValue]];

    
    FMResultSet *rs = [db_ executeQuery:sql];
    NSMutableArray *storeList = [NSMutableArray array];
    while ([rs next]) {
        
        // shop情報の保持オブジェクト
        NSDictionary *store = [NSDictionary dictionaryWithObjectsAndKeys:
                               [rs stringForColumn:COLUMN_ID]          , FEED_DICTIONARY_KEY_ID,
                               [rs stringForColumn:COLUMN_SHOPNAME]    , FEED_DICTIONARY_KEY_SHOPNAME,
                               [rs stringForColumn:COLUMN_CATEGORY]    , FEED_DICTIONARY_KEY_CATEGORY,
                               [rs stringForColumn:COLUMN_SHOPINFO]    , FEED_DICTIONARY_KEY_SHOPINFO,
                               [rs stringForColumn:COLUMN_LATITUDE]    , FEED_DICTIONARY_KEY_LATITUDE,
                               [rs stringForColumn:COLUMN_LONGITUDE]   , FEED_DICTIONARY_KEY_LONGITUDE,
                               [rs stringForColumn:COLUMN_OPENINGHOURS], FEED_DICTIONARY_KEY_OPENINGHOURS,
                               [rs stringForColumn:COLUMN_PARKING]     , FEED_DICTIONARY_KEY_PARKING,
                               [rs stringForColumn:COLUMN_DRIVETHROUGH], FEED_DICTIONARY_KEY_DRIVETHROUGH,
                               [rs stringForColumn:COLUMN_TABLESEATS]  , FEED_DICTIONARY_KEY_TABLESEATS,
                               [rs stringForColumn:COLUMN_FOODPACK]    , FEED_DICTIONARY_KEY_FOODPACK,
                               [rs stringForColumn:COLUMN_EMONEY]      , FEED_DICTIONARY_KEY_EMONEY,
                               nil];
        [storeList addObject:store];
    }
    [rs close];
    return storeList;
    
}





@end
