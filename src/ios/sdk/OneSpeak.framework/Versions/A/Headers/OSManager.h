//
//  OSManager.h
//  OneSpeak
//
//  Copyright (c) isana.net,inc. All rights reserved.
//  Confidential

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "OSManagerDelegate.h"

@interface OSManager : NSObject

/**
 * @brief   アプリケーションが起動したことをライブラリに通知します
 *
 * @param   launchOptions   起動パラメータ
 * @param   aDelegate       ライブラリからの通知などを受けるdelegate
 *
 * アプリケーション起動時にコールしてください。
 * delegateはカスタムデータを使用しない場合はnilを設定可能です。
 */
+ (void)didFinishLaunchingWithOptions:(NSDictionary *)launchOptions delegate:(id<OSManagerDelegate>)aDelegate;

/**
 * @brief   設定の登録完了をライブラリに通知します
 *
 * @param   notificationSettings    プッシュ通知設定
 *
 * 設定完了時にコールして下さい。
 */
+ (void)didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings;

/**
 * @brief   受信したデバイストークンをライブラリに通知します
 *
 * @param   deviceToken 受信したデバイストークン
 *
 * デバイストークン受信時にコールしてください。
 */
+ (void)didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;

/**
 * @brief   RemoteNotificationの登録に失敗したことをライブラリに通知します
 *
 * @param   error   失敗の原因となるエラー
 *
 * デバイストークン取得失敗時にコールしてください。
 */
+ (void)didFailToRegisterForRemoteNotificationsWithError:(NSError *)error;

/**
 * @brief   RemoteNotificationを受信したことをライブラリに通知します
 *
 * @param   userInfo    受信したNotification
 *
 * RemoteNotification受信時にコールしてください。
 * 設定内容によってデフォルトの動作を実行します。
 * ・アラートビューによる通知内容の表示
 * ・通知効果測定
 */
+ (void)didReceiveRemoteNotification:(NSDictionary *)userInfo;

/**
 * @brief   カスタムデータの送信が必要なことをライブラリに通知します
 *
 * didFinishLaunchingWithOptionsにて設定したdelegateよりカスタムデータを取得し、送信します。
 */
+ (void)sendCustomData;


/**
 * @brief   位置情報連動通知が有効に動作するかどうかを返します
 *
 * @retval  YES 有効
 * @retval  NO  無効
 */
+ (BOOL)isAvailable;


/**
 * @brief   設定項目：位置情報プッシュ有効状態を設定する
 *
 * @param   有効状態（YES=ON／NO=OFF）
 */
+ (void)setTrackingEnabled:(BOOL)enabled;

/**
 * @brief   設定項目：位置情報プッシュ有効状の現在の設定値を返す
 *
 * @retval  YES 位置情報プッシュ設定ON
 * @retval  NO  位置情報プッシュ設定OFF
 */
+ (BOOL)trackingEnabled;

@end
