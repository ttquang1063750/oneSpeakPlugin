package jp.co.matsuyafoods.officialapp.dis.map.mapview;

import android.content.Context;
import android.os.AsyncTask;

import jp.co.matsuyafoods.officialapp.dis.MainActivity;
import jp.co.matsuyafoods.officialapp.dis.map.parser.FeedUpDateParser;
/**
 * 更新日取得通信クラス
 * @author sugi
 *
 */
public class UpdateCheckAsyncTask extends AsyncTask<Void, Void, String>{
	
	private static final String TAG = "UpdateCheckAsyncTask";

	private Context context;
	private String mUpDateString;
	private boolean success;
	
	public UpdateCheckAsyncTask(Context context){
		this.context = context;
	}
	
	@Override
	protected void onPreExecute() {
		super.onPreExecute();
		success = true;
		mUpDateString = "";
	}
	
	@Override
	protected String doInBackground(Void... params) {
		
		HttpConnectionsHelper httpHelper = new HttpConnectionsHelper();
		String xml = httpHelper.sendGet(CommonUtilities.URL_UPDATE);
		
		
		if(xml != null && !xml.startsWith(HttpConnectionsHelper.ERROR)){
			
			FeedUpDateParser dateParser = new FeedUpDateParser(xml);
			
			if(dateParser.init()){
				
				mUpDateString = dateParser.getUpDateString();
			}
			// パース失敗時
			else {
				success = false;
			}
		}
		else {
			success = false;
		}
		return null;
	}
	
	@Override
	protected void onPostExecute(String result) {
	
		if(success){
			// 成功時の呼び出し
			((MainActivity)context).loadSuccess(mUpDateString);
		}
		else {
			// 失敗時の呼び出し
			((MainActivity)context).loadError();
		}
	}
	

}
