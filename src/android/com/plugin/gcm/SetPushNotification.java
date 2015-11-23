package jp.co.matsuyafoods.officialapp.dis;

import net.isana.OneSpeak.OneSpeak;
import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.json.JSONArray;
import org.json.JSONException;

import android.content.Context;
import android.content.SharedPreferences;

public class SetPushNotification extends CordovaPlugin {

	// CouponAppインスタンス作成

	// 許可する場合のアクション定数
	private static final String PUSH_ALLOW = "push_allow";
	// 許可しない場合のアクション定数
	private static final String PUSH_FORBID = "push_forbid";
	// Push通知の設定を確認するアクション定数
	private static final String PUSH_CONFIRM = "push_confirm";

	// 各フラグ定数
	private static final String ONESPEAK_PREFERENCE_FILE = "couponapp_onespeak_pref";
	private static final String ONESPEAK_FLG = "onespeakflg";
	private static final int ONESPEAK_OK = 1;
	private static final int ONESPEAK_NG = 2;

	// 設定変更が完了したメッセージ
	private static final String SUCCESS_UPDATE_MESSAGE = "設定を変更しました。";
	// 例外時のエラーメッセージ
	private static final String EXCEPTION = "例外：";
	// 存在しないメソッド名が実行されようとした時のエラーメッセージ
	private static final String ERR_MSG_UNKNOWN_METHOD = "unknown method.";

	@Override
	public boolean execute(String action, JSONArray data,
			CallbackContext callbackContext) throws JSONException {
		try {
			if (PUSH_ALLOW.equals(action)) {
				// updatePreferenceValueメソッドの呼び出し
				updatePreferenceValue(ONESPEAK_FLG, ONESPEAK_OK);
				// OneSpeakサーバへの更新処理
				updatePushEnabled(true);
				callbackContext.success(SUCCESS_UPDATE_MESSAGE);
				return true;
			} else if (PUSH_FORBID.equals(action)) {
				// updatePreferenceValueメソッドの呼び出し
				updatePreferenceValue(ONESPEAK_FLG, ONESPEAK_NG);
				// OneSpeakサーバへの更新処理
				updatePushEnabled(false);
				callbackContext.success(SUCCESS_UPDATE_MESSAGE);
				return true;
			} else if (PUSH_CONFIRM.equals(action)) {
				Context ctx = cordova.getActivity().getApplicationContext();
				String pushFlag = String.valueOf(OneSpeak.getPushEnabled(ctx));
				callbackContext.success(pushFlag);
				return true;
			} else {
				// 存在しないメソッドが呼ばれたときのエラー処理
				callbackContext.error(ERR_MSG_UNKNOWN_METHOD);
				return false;
			}
		} catch (Exception e) {
			// 例外時のエラー処理
			callbackContext.error(EXCEPTION + e.getMessage());
			return false;
		}
	}

	// SharedPreferencesの更新処理
	private void updatePreferenceValue(String key, int value) {
		Context ctx = cordova.getActivity().getApplicationContext();
		// 端末に値を保存します。
		SharedPreferences preferences = ctx.getSharedPreferences(
				ONESPEAK_PREFERENCE_FILE, Context.MODE_PRIVATE);
		SharedPreferences.Editor editor = preferences.edit();
		editor.putInt(key, value);
		editor.commit();
	}

	// OneSpeakサーバへ通知設定の更新処理
	private void updatePushEnabled(boolean flag) {
		Context ctx = cordova.getActivity().getApplicationContext();
		// 端末に値を保存します。
		OneSpeak.setPushEnabled(ctx, flag);
	}
}
