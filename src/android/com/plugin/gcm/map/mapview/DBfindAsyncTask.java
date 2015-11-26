package com.plugin.gcm.map.mapview;

import android.content.Context;
import android.database.sqlite.SQLiteDatabase;
import android.os.AsyncTask;
import android.util.Log;

import com.plugin.gcm.map.db.DBHelper;
import com.plugin.gcm.map.db.StoreDAO;
import com.plugin.gcm.map.entity.RequestRange;
import com.plugin.gcm.map.entity.Shop;

import java.util.List;

/**
 * データベースからデータ取得するクラスです
 * @author sugi
 *
 */
class DBfindAsyncTask extends AsyncTask<Void, Void, List<Shop>>{

	private RequestRange range;

	// DB
	private DBHelper dbHelper;
	private SQLiteDatabase db;
	private StoreDAO storeDAO;

	private Context context;

	// 取得店舗リスト
	private List<Shop> stores = null;

	/**
	 * コンストラクター
	 * 四隅の座標と現在地を受け取る
	 * @param context
	 * @param range
	 */
	public DBfindAsyncTask(Context context, RequestRange range){

		this.context = context;
		this.range   = range;
	}
	@Override
	protected void onPreExecute() {
		super.onPreExecute();
		Log.d("DBfindAsyncTask","start");
		// DBマネージャー
		dbHelper = DBHelper.createDBHelper(context);
		db = dbHelper.getReadableDatabase();
		// storeDAO
		storeDAO = new StoreDAO(db);
	}
	@Override
	protected List<Shop> doInBackground(Void... arg0) {
		// DBからstoreの取得
		Log.d("DBtask", "doInBackgroundStart");
		stores = storeDAO.findStore(range);

		return stores;
	}
	@Override
	protected void onPostExecute(List<Shop> result) {
		super.onPostExecute(result);
		Log.d("DBtask", "onPostExecute size = "+result.size());

		db.close();
		dbHelper = null;
		if(result.size() > 0){
			((com.plugin.gcm.map.mapview.MapMainActivity)context).putOverLay(result);
		}
	}
	@Override
	protected void onCancelled() {
		// TODO 自動生成されたメソッド・スタブ
		super.onCancelled();
		Log.d("DBfindAsyncTask","onCancelled");
		db.close();
		dbHelper = null;
	}

}