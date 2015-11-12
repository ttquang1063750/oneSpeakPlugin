//
//  CommonUtilities.h
//  CouponApp3
//
//  Created by 杉浦 正光 on 2013/06/11.
//
//

/*
 * URL
 */
#define URL_UPDATE      @"http://www.matsuyafoods.co.jp/map/update.xml"                  // 更新日チェック用URL
#define URL_FEED        @"http://www.matsuyafoods.co.jp/map/index.xml"             // Feed取得URL
#define URL_FEED_DETAIL @"http://www.matsuyafoods.co.jp/map/detail.xml"            // Detail取得URL
#define URL_NEWSHOP     @"http://www.matsuyafoods.co.jp/sp/shopsearch/index.html"      // 新店・一時閉店取得URL
#define URL_CUSTOM      @"http://pkg.navitime.co.jp/matsuyafoods/"         // オプション内カスタム検索取得URL
#define URL_USE_MAP     @"http://www.matsuyafoods.co.jp/sp/shopsearch/map_help.html"  // マップについて取得URL
#define URL_NAVITIME    @"http://pkg.navitime.co.jp/matsuyafoods/spot/detail?code=000000" // navitime URL ※末尾に4桁の店舗IDをつけて利用

/*
 * UserDefaults Key
 */
#define FEED_KEY @"feed"                 // Feed更新日保存用キー
#define LAST_POSITION @"last_position"   // 最終取得ロケーション情報保存キー
#define LAST_ZOOM @"last_zoom"   // 最終取得ズーム値情報保存キー

/*
 *FeedDictionary Key
 */
#define FEED_DICTIONARY_KEY_ID           @"id"
#define FEED_DICTIONARY_KEY_SHOPNAME     @"shopname"
#define FEED_DICTIONARY_KEY_CATEGORY     @"category"
#define FEED_DICTIONARY_KEY_SHOPINFO     @"shopinfo"
#define FEED_DICTIONARY_KEY_LATITUDE     @"latitude"
#define FEED_DICTIONARY_KEY_LONGITUDE    @"longitude"
#define FEED_DICTIONARY_KEY_OPENINGHOURS @"open24h"
#define FEED_DICTIONARY_KEY_PARKING      @"parking"
#define FEED_DICTIONARY_KEY_DRIVETHROUGH @"drivethrough"
#define FEED_DICTIONARY_KEY_TABLESEATS   @"tableseats"
#define FEED_DICTIONARY_KEY_FOODPACK     @"foodpack"
#define FEED_DICTIONARY_KEY_EMONEY       @"e-money"


/*
 * DetailDictionary Key
 */
#define DETAIL_DICTIONARY_KEY_ID            @"id"
#define DETAIL_DICTIONARY_KEY_SHOPNAME      @"shopname"
#define DETAIL_DICTIONARY_KEY_OPENING_HOURS @"opening_hours"
#define DETAIL_DICTIONARY_KEY_ADDRESS       @"address"
#define DETAIL_DICTIONARY_KEY_TEL           @"tel"
#define DETAIL_DICTIONARY_KEY_LATITUDE      @"latitude"
#define DETAIL_DICTIONARY_KEY_LONGITUDE     @"longitude"
#define DETAIL_DICTIONARY_KEY_NAVITIME_ID   @"navitimeid"
#define DETAIL_DICTIONARY_KEY_OPEN24H       @"open24h"
#define DETAIL_DICTIONARY_KEY_PARKING       @"parking"
#define DETAIL_DICTIONARY_KEY_DRIVETHROUGH  @"drivethrough"
#define DETAIL_DICTIONARY_KEY_TABLESEATS    @"tableseats"
#define DETAIL_DICTIONARY_KEY_FOODPACK      @"foodpack"
#define DETAIL_DICTIONARY_KEY_EMONEY        @"e-money"