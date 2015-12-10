package com.plugin.gcm;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.util.Log;
import android.view.KeyEvent;

import net.isana.OneSpeak.OneSpeak;

public class HandlerActivity extends Activity
{
	// OneSpeakのIntentScheme定義
	public static final String INTENE_SCHEME = "OneSpeak";

	// Intent
	Intent intent;

	// //////////////////// プッシュ通知のオプション値保存用 //////////////////////////////////
	private static final String ONESPEAK_CUSTOMDATA = "onespeak_custom_data";
	private static final String ONESPEAK_CUSTOMID = "event_id";

	// /////////////////// プッシュ通知確認ダイアログ用にサンプルとして追加 /////////////////////
	private static final String ONESPEAK_PREFERENCE_FILE = "couponapp_onespeak_pref";
	private static final String ONESPEAK_FLG = "onespeakflg";
	private static final int ONESPEAK_NOT_CHECKED = 0;
	private static final int ONESPEAK_OK = 1;
	private static final int ONESPEAK_NG = 2;

	private int getPreferenceIntValue(String key) {
		// 端末から値を取得します。
		SharedPreferences preferences = getSharedPreferences(ONESPEAK_PREFERENCE_FILE, Context.MODE_PRIVATE);
		// 項目が登録されていない場合は、デフォルト値としてONESPEAK_NOT_CHECKEDを返却します。
		return preferences.getInt(ONESPEAK_FLG, ONESPEAK_NOT_CHECKED);
	}

	private void storePreferenceValue(String key, int value) {
		// 端末に値を保存します。
		SharedPreferences preferences = getSharedPreferences(ONESPEAK_PREFERENCE_FILE, Context.MODE_PRIVATE);
		SharedPreferences.Editor editor = preferences.edit();
		editor.putInt(key, value);
		editor.commit();
	}

	void startOneSpeak() {
		// OneSpeakを開始します。
		OneSpeakPlugin.checkUUID(this);
		OneSpeak.startOneSpeak(getApplicationContext(), intent);
		OneSpeak.registOneSpeak(this);
	}

	// /////////////////// プッシュ通知確認ダイアログ用にサンプルとして追加 /////////////////////

	@Override
	public void onCreate(Bundle savedInstanceState) {
		// プッシュ通知初期設定
		intent = getIntent();

		// OneSpeakサービス起動
		startOneSpeak();

		// /////////////////// プッシュ通知確認ダイアログ用にサンプルとして追加 /////////////////////
		// 端末OneSpeak許可状態を取得します。
		int onespeakflg = getPreferenceIntValue(ONESPEAK_FLG);
		if (onespeakflg == ONESPEAK_OK) {
			// 許可済みの場合は開始処理を行います。
			// startOneSpeak();
		} else if (onespeakflg == ONESPEAK_NOT_CHECKED) {
			// 未チェックの場合はダイアログを表示します。
			AlertDialog.Builder builder = new AlertDialog.Builder(this);
			// タイトルを設定します。
			builder.setTitle("通知確認");
			// メッセージを設定します。
			builder.setMessage("このアプリはPush通知を使用しています。通知を許可しますか？" + "\n" + "設定は「その他」より変更できます。" );
			// 許可しないボタンの設定
			builder.setNegativeButton("許可しない",
					new DialogInterface.OnClickListener() {
						@Override
						public void onClick(DialogInterface dialog, int which) {
							// ダイアログを閉じ、許可しない設定を端末に保存します。
							dialog.dismiss();
							storePreferenceValue(ONESPEAK_FLG, ONESPEAK_NG);
							OneSpeak.setPushEnabled(getApplicationContext(),
									false);
						}
					});
			// 許可するボタンの設定
			builder.setPositiveButton("許可する",
					new DialogInterface.OnClickListener() {
						@Override
						public void onClick(DialogInterface dialog, int which) {
							// ダイアログを閉じ、許可するを端末に保存します。
							dialog.dismiss();
							storePreferenceValue(ONESPEAK_FLG, ONESPEAK_NG);
							OneSpeak.setPushEnabled(getApplicationContext(),
									true);
							// 開始処理を実行します。
							// startOneSpeak();
						}
					});
			builder.setCancelable(false);
			builder.create();
			builder.show();
		}
		// /////////////////// プッシュ通知確認ダイアログ用にサンプルとして追加 /////////////////////

		super.onCreate(savedInstanceState);
		// スプラッシュ画面設定


		String scheme = intent.getScheme();
		// OneSpeakのintentの場合
		if (scheme != null && INTENE_SCHEME.equals(scheme)) {
			this.createParam();
			// 呼び出し先URLにパラメータを付与
		}

	}

	@Override
	// 端末のメニューボタン無効設定
	public boolean dispatchKeyEvent(KeyEvent event) {
		if (event.getAction() == KeyEvent.ACTION_DOWN) {
			switch (event.getKeyCode()) {
				case KeyEvent.KEYCODE_MENU:
					// 親クラスのdispatchKeyEvent()を呼び出さずにtrueを返す
					return true;
			}
		}
		return super.dispatchKeyEvent(event);
	}


	// 遷移先URLに付与するパラメータ作成
	private void createParam() {

		try {
			// 遷移先URLに付与するパラメータ作成
			Bundle extras = intent.getExtras();
			String eventId = null;

			if (extras != null) {
				// OneSpeakで設定したカスタム値を取得
				Bundle customBundle = extras
						.getBundle(OneSpeak.ONESPEAK_EXTRA_CUSTOM_DATA);
				if (customBundle != null) {
					eventId = customBundle.getString(ONESPEAK_CUSTOMID);

					if (eventId != null && !"".equals(eventId)) {
						// オプション値を保存
						SharedPreferences preferences = getSharedPreferences(
								ONESPEAK_CUSTOMDATA, Context.MODE_PRIVATE);
						SharedPreferences.Editor editor = preferences.edit();
						editor.putString(ONESPEAK_CUSTOMID, eventId);
						editor.commit();
					}
				}
			}
		} catch (Exception e) {
			Log.d("PushNotification", e.toString());
		}
	}

}