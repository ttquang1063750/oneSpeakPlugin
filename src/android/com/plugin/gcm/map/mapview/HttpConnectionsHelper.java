package com.plugin.gcm.map.mapview;

import android.util.Log;

import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.params.BasicHttpParams;
import org.apache.http.params.HttpConnectionParams;
import org.apache.http.params.HttpParams;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;

/**
 * HTTP通信クラス
 * @author sugi
 *
 */
public class HttpConnectionsHelper {

	public static final String  ERROR = "error";

	/**
	 * コンストラクター
	 */
	public HttpConnectionsHelper(){}

	/**
	 * get通信
	 * @param url
	 * @return String
	 */
	public String sendGet(String url){
		String jsonString = "";
		// URLを設定
		String locationFeed = url;
		HttpParams params = new BasicHttpParams();

		// タイムアウトを設定
		HttpConnectionParams.setConnectionTimeout(params, 5 * 1000); // 接続のタイムアウト
		HttpConnectionParams.setSoTimeout(params, 5 * 1000); // データ取得のタイムアウト
		HttpClient objHttp = new DefaultHttpClient(params);

		// GETメソッド設定
		HttpGet objGet = new HttpGet(locationFeed);

		// レスポンス取得（受信）
		InputStream objStream = null;
		try {
			Log.i("sendGet", "通信開始");
			HttpResponse objResponse = objHttp.execute(objGet);
			if (objResponse.getStatusLine().getStatusCode() == HttpURLConnection.HTTP_OK) {
				// 正常取得
				objStream = objResponse.getEntity()
						.getContent();

				InputStreamReader objReader = new InputStreamReader(objStream);
				BufferedReader objBuf = new BufferedReader(objReader);
				StringBuilder objJson = new StringBuilder();
				String sLine;
				while ((sLine = objBuf.readLine()) != null) {
					objJson.append(sLine);
				}
				jsonString = objJson.toString();

			}else{
				jsonString = "error,"+ String.valueOf(objResponse.getStatusLine().getStatusCode());
				Log.d("sendGet","エラーコード="+String.valueOf(objResponse.getStatusLine().getStatusCode()));
			}


		} catch (IOException e) {
			Log.d("sendGet",e.toString(), e);
			e.printStackTrace();
			jsonString = "error";

		}finally{
			Log.i("sendGet", "通信終了");
			// 終了処理
			try {
				if(objStream != null){
					objStream.close();
				}
			} catch (IOException e) {
				e.printStackTrace();
				Log.d("objStream", "close", e);
			}
			objHttp.getConnectionManager().shutdown();
		}
		return jsonString;

	}

}
