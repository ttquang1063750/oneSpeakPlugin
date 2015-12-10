package jp.co.matsuyafoods.officialapp.dis.map.mapview;

import android.content.Context;
import android.database.sqlite.SQLiteDatabase;
import android.os.AsyncTask;
import android.util.Log;

import java.util.List;

import jp.co.matsuyafoods.officialapp.dis.MainActivity;
import jp.co.matsuyafoods.officialapp.dis.map.db.DBHelper;
import jp.co.matsuyafoods.officialapp.dis.map.db.StoreDAO;
import jp.co.matsuyafoods.officialapp.dis.map.entity.RequestRange;
import jp.co.matsuyafoods.officialapp.dis.map.entity.Shop;

/**
 * データベースからデータ取得するクラスです
 * @author sugi
 *
 */
public class DBfindAsyncTask extends AsyncTask<Void, Void, List<Shop>>{

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
			((MainActivity)context).putOverLay(result);
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