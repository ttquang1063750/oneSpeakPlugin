package jp.co.matsuyafoods.officialapp.dis;

import android.content.Context;
import android.os.Bundle;
import android.util.Log;

import com.plugin.gcm.OneSpeakPlugin;

import net.isana.OneSpeak.OneSpeakBaseService;

public class OneSpeakService extends OneSpeakBaseService {
	// カスタムデータExtraキー
	public static final String EXTRA_KEY_CUSTOM_DATA = "jp.co.matsuyafoods.officialapp.dis.OneSpeakService.EXTRA.CUSTOM_DATA";

	/**
	 * 通知から起動するアクティビティクラスの取得
	 * 
	 * @return クラス
	 * 
	 *         <p>
	 *         通知をタップした際に起動するアクティビティのクラスを指定します。
	 *         </p>
	 */
	public Class<?> bootFromNotificationActivityClass() {
		return MainActivity.class;
	}

	/**
	 * 通知受信時のアイコン画像設定
	 * 
	 * @return リソースID
	 * 
	 *         <p>
	 *         通知時に表示されるアイコン画像を指定します。
	 *         </p>
	 */
	public int applicationIcon() {
		return R.drawable.icon;
	}

	/**
	 * ユーザ属性の取得
	 * 
	 * @param context
	 *            コンテキスト
	 * @param customData
	 *            空のカスタムデータ
	 * 
	 *            <p>
	 *            端末IDに紐づけるユーザ属性を指定します。
	 *            </p>
	 */
	public void customDataForOneSpeak(Context context, Bundle customData) {
		OneSpeakPlugin.setUpCustomData(context, customData);
		// customData.putString("user_id", "0021");
		// customData.putString("type", "A");
	}

	/**
	 * オプション情報の受信
	 * 
	 * @param context
	 *            コンテキスト
	 * @param customData
	 *            オプション情報
	 * 
	 *            <p>
	 *            通知受信時にコールされ、通知内容に含まれていたオプション情報が渡されます。
	 *            オプション情報が含まれていない場合もコールされ、customDataの件数は0件となります。
	 *            </p>
	 */
	public void onReceiveCustomData(Context context, Bundle customData) {
		Log.d("get PushNotification", customData.getString("event_id"));
//		try {
//			String eventId = null;
//			eventId = customData.getString("event_id");
//			if (eventId != null && !"".equals(eventId)) {
//				EasyTracker.getInstance().setContext(context);
//				Tracker tracker = EasyTracker.getTracker();
//				tracker.sendEvent("PushNotification", "Receive", eventId,
//						null);
//			}
//		} catch (Exception e) {
//			Log.d("PushNotification", e.toString());
//		}
	}

	/**
	 * 通知受信時のサウンド設定
	 * 
	 * @return サウンド設定
	 * 
	 *         <p>
	 *         独自の通知音を使用する場合のみ実装する。 通知時に再生されるサウンドを指定します。
	 *         </p>
	 */
	/*
	 * @Override public Uri notificationSound() { return
	 * Settings.System.DEFAULT_NOTIFICATION_URI; //return
	 * Uri.parse("android.resource://net.isana.OneSpeak.demo/" + R.raw.tomo); }
	 */

	/**
	 * 通知受信時のバイブ設定
	 * 
	 * @return バイブ設定（非振動時間、振動時間の繰返し。単位はミリ秒。）
	 * 
	 *         <p>
	 *         独自のバイブパターンを使用する場合のみ実装する。 通知時のバイブパターンを指定します。
	 *         </p>
	 */

	@Override
	public long[] notificationVibrate() {
		return new long[] { 0, 500, 0, 500 };
	}

	/**
	 * 通知タップ時のアクティビティ起動フラグ設定
	 * 
	 * <p>
	 * 通知タップ時の起動フラグを変更する場合のみ実装する。 デフォルトでは「Intent.FLAG_ACTIVITY_NEW_TASK」で起動する。
	 * </p>
	 * 
	 * @return アクティビティ起動フラグ
	 */
	/*
	 * public int intentFlags() { return Intent.FLAG_ACTIVITY_NEW_TASK; }
	 */
}