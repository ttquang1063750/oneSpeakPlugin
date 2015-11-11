//
//  OneSpeak.h
//  OneSpeak
//
//  Copyright (c) isana.net,inc. All rights reserved.
//  Confidential



// How to use:
//
// 1.「OneSpeak.Framework」をプロジェクトに追加する
//
// 2.OneSpeakの動作に必要なフレームワークを追加する
//   Foundation.framework
//   UIKit.framework
//   CoreLocation.framework
//   AVFoundation.framework
//
// 3.OneSpeakを参照する
// #import <OneSpeak/OneSpeak.h>
//
// 4.アプリ起動時にdidFinishLaunchingWithOptionsをコールする
// - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
// {
//     [OSManager didFinishLaunchingWithOptions:launchOptions delegate:self];
//      :
//      :
// }
//
// 5.デバイストークンの取得が行われるので、取得成功・失敗時にそれぞれ対応したメソッドをコールする
// - (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
// {
//     [OSManager didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
// }
// - (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
// {
//     [OSManager didFailToRegisterForRemoteNotificationsWithError:error];
// }
//
// 6.通知受信時にdidReceiveRemoteNotificationをコールする
// - (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo 
// {
//     [OSManager didReceiveRemoteNotification:userInfo];
// }
//
// 6.停止させる必要がある場合は以下のメソッドをコールする
// [OSManager stopTracking];
// [OSManager startTracking];



#import "OSManager.h"
