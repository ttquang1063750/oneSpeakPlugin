//
//  FeedXmlParser.h
//  CouponApp
//
//  Created by 杉浦 正光 on 2013/05/16.
//
//

#import <Foundation/Foundation.h>

// タグ
#define ENTRY @"entry"
#define FEED  @"feed"
#define ICON  @"icon"

@interface FeedXmlParser : NSObject<NSXMLParserDelegate>{
   
    BOOL isElement_;    // elementの有無を管理
    BOOL successFlag_;  // 成功確認フラグ
    
    NSXMLParser* parser_;
    
	NSMutableString     *elementBuffer_;   // 要素編集用
    NSMutableDictionary *shop_;            // 店舗データ編集
    NSMutableArray      *shopList_;        // 店舗リスト編集
    
}
@property(readwrite)BOOL                        isElement;
@property(readwrite)BOOL                        successFlag;
@property(nonatomic, retain)NSMutableArray      *shopList;

- (id)initWithContentsOfURL:(NSString *)url;
@end
