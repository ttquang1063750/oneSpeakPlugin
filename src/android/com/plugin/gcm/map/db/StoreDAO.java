package jp.co.matsuyafoods.officialapp.dis.map.db;

import android.content.ContentValues;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.provider.BaseColumns;
import android.util.Log;

import java.util.ArrayList;
import java.util.List;

import jp.co.matsuyafoods.officialapp.dis.map.entity.RequestRange;
import jp.co.matsuyafoods.officialapp.dis.map.entity.Shop;

/**
 * データベースの操作クラス
 * @author sugi
 *
 */
public class StoreDAO {


	public static final long ERROR = -1;


	private interface Columns extends BaseColumns {

		public static final String ID           = "id";
		public static final String SHOPNAME     ="shopname";
		public static final String CATEGORY     ="category";
		public static final String SHOPINFO     ="shopinfo";
		public static final String LATITUDE     ="latitude";
		public static final String LONGITUDE    ="longitude";
		public static final String OPENINGHOURS ="openinghours";// icon
		public static final String PARKING      ="parking";
		public static final String DRIVETHROUGH ="drivethrough";
		public static final String TABLESEATS   ="tableseats";
		public static final String FOODPACK     ="foodpack";
		public static final String EMONEY       ="emoney";
	}

	private static final String TABLE_NAME_STORE = "store";



	private static final String[] COLUMNS = {
		Columns.ID,
		Columns.SHOPNAME,
		Columns.CATEGORY,
		Columns.SHOPINFO,
		Columns.LATITUDE,
		Columns.LONGITUDE,
		Columns.OPENINGHOURS,
		Columns.PARKING,
		Columns.DRIVETHROUGH,
		Columns.TABLESEATS,
		Columns.FOODPACK,
		Columns.EMONEY
	};

	private SQLiteDatabase db;

	/**
	 * コンストラクター
	 * @param db
	 */
	public StoreDAO(SQLiteDatabase db) {
		this.db = db;
	}

	/**
	 * レコードの挿入（Feed）
	 * @param shop
	 * @return
	 */
	public synchronized long insert(Shop shop) {


			ContentValues values = new ContentValues();
			values.put(Columns.ID,           shop.getId());
			values.put(Columns.SHOPNAME,     shop.getShopname());
			values.put(Columns.CATEGORY,     shop.getCategory());
			values.put(Columns.SHOPINFO,     shop.getShopinfo());
			values.put(Columns.LATITUDE,     shop.getLatitude());
			values.put(Columns.LONGITUDE,    shop.getLongitude());
			values.put(Columns.OPENINGHOURS, shop.getOpeninghours());
			values.put(Columns.PARKING,      shop.getParking());
			values.put(Columns.DRIVETHROUGH, shop.getDrivethrough());
			values.put(Columns.TABLESEATS,   shop.getTableseats());
			values.put(Columns.FOODPACK,     shop.getFoodpack());
			values.put(Columns.EMONEY,       shop.geteMoney());

			return db.insert(TABLE_NAME_STORE, null, values);
	}

	/**
	 * Feedデータの全件削除
	 */
	public synchronized void deleteAll(){

		db.delete(TABLE_NAME_STORE, null, null);
	}

	/**
	 * レコードの検索
	 * 現在地から近い順にソートして、リストを返しています。
	 * @param range
	 * @return
	 */
	public synchronized List<Shop> findStore(RequestRange range) {

		Log.d("StoreDAO", "findStore");

		List<Shop> stores = new ArrayList<Shop>();
		Shop file = null;

		String selection = "(latitude between " + range.getWestLat() + " and " + range.getEastLat() + ") and (longitude between " + range.getSouthLng() +" and " + range.getNorthLng() + ") ";
		String orderBy = "(latitude -" + range.getcLatitude() + ")*(latitude - "+range.getcLatitude()+") + (longitude - " + range.getcLongitude() +")*(longitude - " + range.getcLongitude() + ") asc";


//		String orderBy = "(latitude -35.70271365049957)*(latitude - 35.70271365049957) + (longitude - 139.56083089113235)*(longitude - 139.56083089113235) asc";
//		String selection = "(latitude between 35.69566200046794 and 35.70975297061779) and (longitude between 139.55310579389334 and 139.56855565309525)  ";
		Cursor c = db.query(TABLE_NAME_STORE, COLUMNS, selection, null, null, null, orderBy);

		System.out.println("=====findStore:selection======");
		System.out.println(selection);
		System.out.println("=====findStore:orderBy======");
		System.out.println(orderBy);

		while(c.moveToNext()) {
			file = new Shop();
			file.setId(c.getString(c.getColumnIndex(Columns.ID)));
			file.setShopname(c.getString(c.getColumnIndex(Columns.SHOPNAME)));
			file.setCategory(c.getString(c.getColumnIndex(Columns.CATEGORY)));
			file.setShopinfo(c.getString(c.getColumnIndex(Columns.SHOPINFO)));
			file.setLatitude(c.getDouble(c.getColumnIndex(Columns.LATITUDE)));
			file.setLongitude(c.getDouble(c.getColumnIndex(Columns.LONGITUDE)));
			file.setOpeninghours(c.getInt(c.getColumnIndex(Columns.OPENINGHOURS)));
			file.setParking(c.getInt(c.getColumnIndex(Columns.PARKING)));
			file.setDrivethrough(c.getInt(c.getColumnIndex(Columns.DRIVETHROUGH)));
			file.setTableseats(c.getInt(c.getColumnIndex(Columns.TABLESEATS)));
			file.setFoodpack(c.getInt(c.getColumnIndex(Columns.FOODPACK)));
			file.seteMoney(c.getInt(c.getColumnIndex(Columns.EMONEY)));

			stores.add(file);
		}
		c.close();
		return stores;// Listを返す
	}




}
