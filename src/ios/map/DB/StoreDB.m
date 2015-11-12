//
//  StoreDB.m
//  CouponApp
//
//  Created by 杉浦 正光 on 2013/05/08.
//
//

#import "StoreDB.h"

@implementation StoreDB

// db使用の準備
- (FMDatabase *)createDB{
    
    BOOL success = YES;
    
    NSString* databaseName = DATABASE_NAME;
    
    // データベース存在チェック
    NSError* error;
    NSFileManager* fm = [NSFileManager defaultManager];
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* writableDBPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:databaseName];
    success = [fm fileExistsAtPath:writableDBPath];
    
    
    
    // 存在しなかった場合
    if (!success) {
        
        // 初期準備していたデータベースをコピー
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:databaseName];
        NSLog(@"%@",defaultDBPath);
        success = [fm copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
        if (!success) {
            NSLog(@"Error : %@", [error localizedDescription]);
        }
        success = YES;
    }
    if (success) {
        
        // データベースオープン
        db_ = [FMDatabase databaseWithPath:writableDBPath];
        if ([db_ open]) {
            [db_ setShouldCacheStatements:YES];
        }
        else{
            NSLog(@"Failed to open database.");
            success = NO;
        }
    }
    
    #pragma unused(success)
    return db_;
    
}

@end