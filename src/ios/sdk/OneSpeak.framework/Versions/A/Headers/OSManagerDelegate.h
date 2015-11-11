//
//  OSManagerDelegate.h
//  OneSpeak
//
//  Copyright (c) isana.net,inc. All rights reserved.
//  Confidential

@protocol OSManagerDelegate <NSObject>

@optional

/**
 * @brief   OneSpeakで利用する通知カテゴリを設定します
 *
 * @return  カテゴリ
 *
 * このメソッドを実装することでOneSpeakがプッシュ通知をデバイスに登録する際の
 * カテゴリを指定することができます。
 */
- (NSSet *)categoriesForOneSpeak;

/**
 * @brief   OneSpeakサーバへのデバイス登録時に通知するカスタムデータを設定します
 *
 * @return  ユーザデータをNSDictionaryとして返却してください
 *
 * このメソッドを実装することでライブラリがOneSpeakサーバにプッシュ通知を行うデバイスを登録する際に、
 * アプリケーション独自に利用するための任意のデータを送信することができます。
 */
- (NSDictionary *)customDataForOneSpeak;

/**
 * @brief   OneSpeakサーバからカスタムデータを受信した際に通知されます
 *
 * @param   customData      受信したカスタムデータがNSDictionaryとして渡されます
 * @param   needsShowAlert  通知表示の必要性
 * @param   title           デフォルトの通知タイトル
 * @param   message         通知メッセージ
 * @param   category        通知カテゴリ
 * @param   badgeValue      指定バッジ値
 *
 * RemoteNotificationを受信した際に、受信データに含まれるカスタムデータが通知されます。
 * カスタムデータが存在しなかった場合でも空のNSDictionaryが通知されます。
 * needsShowAlertパラメータがYESの場合は、アプリ側でアラートビューの表示をお願いします。
 * アプリアイコンのバッジ表示についてはOneSpeak側で既に設定済みですので、アプリ側での処理は不要です。
 */
- (void)oneSpeakDidReceiveCustomData:(NSDictionary *)customData needsShowAlert:(BOOL)needsShowAlert title:(NSString *)title message:(NSString *)message category:(NSString *)category badgeValue:(NSNumber *)badgeValue;

/**
 * @depricated  代替として(oneSpeakDidReceiveCustomData: needsShowAlert: title: message: category: badgeValue:)をご利用ください
 *
 * @brief   OneSpeakサーバからカスタムデータを受信した際に通知されます
 *
 * @param   customData  受信したカスタムデータがNSDictionaryとして渡されます
 *
 * RemoteNotificationを受信した際に、受信データに含まれるカスタムデータが通知されます。
 * カスタムデータが存在しなかった場合でも空のNSDictionaryが通知されます。
 */
- (void)oneSpeakDidReceiveCustomData:(NSDictionary *)customData;

@end
