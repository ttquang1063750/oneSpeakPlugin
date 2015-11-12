//
//  FeedXmlParser.m
//  CouponApp
//
//  Created by 杉浦 正光 on 2013/05/16.
//
//

#import "FeedXmlParser.h"

@implementation FeedXmlParser

@synthesize shopList    = shopList_;
@synthesize successFlag = successFlag_;
@synthesize isElement   = isElement_;

- (id)init{
    
    self = [super init];
    if (self) {
        
    }
    return self;
    
}
// 初期準備
- (id)initWithContentsOfURL:(NSString *)url{
    
    self = [super init];
    if (self) {
        
        // flagの初期化
        self.successFlag = NO;
        
        parser_ = [[NSXMLParser alloc] initWithContentsOfURL:[NSURL URLWithString:url]];
        parser_.delegate = self;
        [parser_ parse];
    }
    return self;
}

// XMLのパース開始
- (void)parserDidStartDocument:(NSXMLParser *)parser {
	// element フラグを初期化（NO に設定）
	isElement_     = NO;
    
    // 編集用オブジェクトを初期化
    shop_          = [NSMutableDictionary dictionary];
    shopList_      = [NSMutableArray array];
    elementBuffer_ = [NSMutableString string];
}

// 要素の開始タグを読み込み
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict {
	// element があるかどうかチェック
    if ([ENTRY isEqualToString:elementName]) {
		// element フラグを NO に設定
		isElement_ = NO;
        
		// 要素の値を入れる領域を初期化する
		elementBuffer_ = [NSMutableString string];
        // 編集用 shop_ を初期化
        shop_ = [NSMutableDictionary dictionary];
		
	}
    else if ([FEED isEqualToString:elementName]){
        
        isElement_ = NO;
    }
    else if ([ICON isEqualToString:elementName]){
        
        isElement_ = NO;
    }
    else {
        
        isElement_ = YES;
    }
}

// 要素の値を読み込み
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
	// element フラグが YES かどうかチェック
	if (isElement_) {
		// 要素の値を elementBuffer へ追加
		[elementBuffer_ appendString:string];
	}
}

// 要素の閉じタグを読み込み
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	// element フラグが YES かどうかチェック
	if (isElement_) {
        
        // バッファーに書き込む
        [shop_ setObject:elementBuffer_ forKey:elementName];
        
		// element フラグを NO に設定
		isElement_ = NO;
	}
        
    
    if ([ENTRY isEqualToString:elementName]) {
    
        // shopの読み込み終了なのでshop情報をリストに追加
        [shopList_ addObject:shop_];
    }
    
    // 要素の値を入れる領域を初期化する
    elementBuffer_ = [NSMutableString string];
    
}

// XML のパース終了
- (void)parserDidEndDocument:(NSXMLParser *)parser {
	
    NSLog(@"xml parser success");
    // 正常終了
    self.successFlag = YES;
}

// エラー
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
	// エラーの内容を出力
	NSLog(@"parserError: %li, Column: %li, Line: %i, Description: %@",
          (long)[parseError code],
          (long)[parser columnNumber],
          [parser lineNumber],
          [parseError description]);
    
    // エラー終了
    self.successFlag = NO;
}


@end
