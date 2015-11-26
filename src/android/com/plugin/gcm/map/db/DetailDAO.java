package com.plugin.gcm.map.db;

import android.content.ContentValues;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.provider.BaseColumns;

import com.plugin.gcm.map.entity.ShopDetail;

public class DetailDAO {

	public static final long ERROR = -1;

	private interface Columns extends BaseColumns {

		public static final String ID           = "id";
		public static final String SHOPNAME     ="shopname";
		public static final String OPENINGHOURS ="openinghours";
		public static final String ADDRESS      ="address";
		public static final String TEL          ="tel";
		public static final String LATITUDE     ="latitude";
		public static final String LONGITUDE    ="longitude";
		public static final String NAVITIME_ID  ="navitimeid";
		public static final String OPEN24H      ="open24h";
		public static final String PARKING      ="parking";
		public static final String DRIVETHROUGH ="drivethrough";
		public static final String TABLESEATS   ="tableseats";
		public static final String FOODPACK     ="foodpack";
		public static final String EMONEY       ="emoney";
	}

	private static final String TABLE_NAME_STORE_INFO = "store_info";

	private static final String[] INFO_COLUMNS = {
		Columns.ID,
		Columns.SHOPNAME,
		Columns.OPENINGHOURS,// 営業時間
		Columns.ADDRESS,
		Columns.TEL,
		Columns.LATITUDE,
		Columns.LONGITUDE,
		Columns.NAVITIME_ID,
		Columns.OPEN24H,
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
	public DetailDAO(SQLiteDatabase db) {
		this.db = db;
	}

	/**
	 * レコードの挿入（Detail）
	 * @param shop
	 * @return
	 */
	public synchronized long insertInfo(ShopDetail shop) {

			ContentValues values = new ContentValues();

			values.put(Columns.ID,           shop.getId());
			values.put(Columns.SHOPNAME,     shop.getShopname());
			values.put(Columns.OPENINGHOURS, shop.getOpeningHours());
			values.put(Columns.ADDRESS,      shop.getAddress());
			values.put(Columns.TEL,          shop.getTel());
			values.put(Columns.LATITUDE,     shop.getLatitude());
			values.put(Columns.LONGITUDE,    shop.getLongitude());
			values.put(Columns.NAVITIME_ID,  shop.getNavitimeId());
			values.put(Columns.OPEN24H,      shop.getOpen24h());
			values.put(Columns.PARKING,      shop.getParking());
			values.put(Columns.DRIVETHROUGH, shop.getDrivethrough());
			values.put(Columns.TABLESEATS,   shop.getTableseats());
			values.put(Columns.FOODPACK,     shop.getFoodpack());
			values.put(Columns.EMONEY,       shop.geteMoney());

			return db.insert(TABLE_NAME_STORE_INFO, null, values);

	}

	/**
	 * 店舗IDからレコードの取得（Detail）
	 *
	 * @param id
	 * @return ShopDetail
	 */
	public synchronized ShopDetail findShopDetail(String id){

		ShopDetail file = null;
		// 検索条件はId
		String selection = "id = ?";
		String[] s = {id};
		Cursor c = db.query(TABLE_NAME_STORE_INFO, INFO_COLUMNS, selection, s, null, null, null);

		while(c.moveToNext()) {
			file = new ShopDetail();
			file.setId(c.getString(c.getColumnIndex(Columns.ID)));
			file.setShopname(c.getString(c.getColumnIndex(Columns.SHOPNAME)));
			file.setOpeningHours(c.getString(c.getColumnIndex(Columns.OPENINGHOURS)));
			file.setAddress(c.getString(c.getColumnIndex(Columns.ADDRESS)));
			file.setTel(c.getString(c.getColumnIndex(Columns.TEL)));
			file.setLatitude(c.getDouble(c.getColumnIndex(Columns.LATITUDE)));
			file.setLongitude(c.getDouble(c.getColumnIndex(Columns.LONGITUDE)));
			file.setNavitimeId(c.getString(c.getColumnIndex(Columns.NAVITIME_ID)));
			file.setOpen24h(c.getInt(c.getColumnIndex(Columns.OPEN24H)));
			file.setParking(c.getInt(c.getColumnIndex(Columns.PARKING)));
			file.setDrivethrough(c.getInt(c.getColumnIndex(Columns.DRIVETHROUGH)));
			file.setTableseats(c.getInt(c.getColumnIndex(Columns.TABLESEATS)));
			file.setFoodpack(c.getInt(c.getColumnIndex(Columns.FOODPACK)));
			file.seteMoney(c.getInt(c.getColumnIndex(Columns.EMONEY)));
//			Log.d("findRowIdInfo", "get Id = "+ id);
			break;
		}
		c.close();
		return file;
	}

	/**
	 * Detailデータの全件削除
	 */
	public synchronized void deleteInfoAll(){

		db.delete(TABLE_NAME_STORE_INFO, null, null);
	}





}
