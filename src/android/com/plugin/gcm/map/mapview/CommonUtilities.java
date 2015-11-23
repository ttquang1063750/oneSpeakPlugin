package jp.co.matsuyafoods.officialapp.dis.map.mapview;

import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.location.LocationManager;
import android.util.Log;

import com.google.android.gms.maps.model.LatLng;

/**
 * グローバル変数管理クラス
 *
 */
public final class CommonUtilities {
	
	/**
	 * カスタム検索用URL
	 */
	static final String URL_CUSTOM = "http://pkg.navitime.co.jp/matsuyafoods/";
	
	/**
	 * 店舗マップについてURL
	 */
	static final String URL_USE_MAP = "http://www.matsuyafoods.co.jp/sp/shopsearch/map_help.html";

	/**
	 * 新店・一時閉店用URL
	 */
	static final String URL_NEWSHOP = "http://www.matsuyafoods.co.jp/sp/shopsearch/index.html";
	
	/**
	 * navitimeURL
	 * 店舗IDとなる４桁を末尾に追加して利用
	 */
	static final String URL_NAVITIME = "http://pkg.navitime.co.jp/matsuyafoods/spot/detail?code=000000";

	/**
	 * 更新日チェックURL
	 */
	static final String URL_UPDATE  = "http://www.matsuyafoods.co.jp/map/update.xml";
	
	/**
	 * Feedの取得用URL
	 */
	static final String URL_FEED = "http://www.matsuyafoods.co.jp/map/index.xml";

	/**
	 * FeedDetailの取得用URL
	 */
	static final String URL_FEED_DETAIL = "http://www.matsuyafoods.co.jp/map/detail.xml";

	/**
	 * SharedPreferences項目：feed更新時の記録
	 */
	static final String SHAREDPREF_FEED_UP_DATE = "feed_up_date";

	/**
	 * SharedPreferences項目：detail更新時の記録
	 */
	static final String SHAREDPREF_DETAIL_UP_DATE = "detail_up_data";

	/**
	 * GPS設定変更時フラグ
	 */
	public static boolean SET_GPS = false;

	/**
	 * 吹き出し制御
	 */
	public static boolean BALL_COUNT = false;

	/***********************************
	 * 三鷹駅（東京） (三鷹駅)
	 * 座標: 35.702708, 139.560831
	 ***********************************/
	static final LatLng MITAKA = new LatLng(35.702708, 139.560831);

	/**
	 * Feedの保存期間の確認
	 * 前回更新日と異なるならばfalseを返却
	 * @param preferences
	 * @return boolean
	 */
	public static boolean checkFeed(SharedPreferences preferences, String upDate){

		boolean check = true;
		
		// キャッシュの保存期間の確認をする 
		String lastUpDate = preferences.getString(SHAREDPREF_FEED_UP_DATE, "");
		
		if(!lastUpDate.equals(upDate)){
			check = false;
		}
		
		return check;
	}

	/**
	 *  GPSが有効かCheck、有効になっていなければ、設定画面の表示確認ダイアログを表示します
	 *  端末の設定へ誘導しています。
	 * @param context
	 * @param nlLocationManager
	 */
	public static void chkGpsService(final Context context, LocationManager nlLocationManager) {

		Log.d("GPSLOG", "============ " + nlLocationManager.isProviderEnabled(LocationManager.GPS_PROVIDER));
		Log.d("NETWORKLOG", "============ "+nlLocationManager.isProviderEnabled(LocationManager.NETWORK_PROVIDER));

		//GPSセンサーとネットワークが利用可能か判断

		if (!nlLocationManager.isProviderEnabled(LocationManager.GPS_PROVIDER) && !nlLocationManager.isProviderEnabled(LocationManager.NETWORK_PROVIDER)){

			AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(context);

			alertDialogBuilder.setMessage("GPSが有効になっていません。\n有効化しますか？")

			.setCancelable(false)

			//GPS設定画面起動用ボタンとイベントの定義

			.setPositiveButton("GPS設定起動",

					new DialogInterface.OnClickListener(){

				public void onClick(DialogInterface dialog, int id){

					SET_GPS = true;
					Intent callGPSSettingIntent = new Intent(

							android.provider.Settings.ACTION_LOCATION_SOURCE_SETTINGS);

					context.startActivity(callGPSSettingIntent);

				}
			});

			//キャンセルボタン処理

			alertDialogBuilder.setNegativeButton("キャンセル",

					new DialogInterface.OnClickListener(){

				public void onClick(DialogInterface dialog, int id){

					dialog.cancel();

				}
			});

			AlertDialog alert = alertDialogBuilder.create();

			// 設定画面へ移動するかの問い合わせダイアログを表示

			alert.show();

		}
	}

}
