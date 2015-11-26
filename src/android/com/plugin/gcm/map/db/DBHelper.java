package com.plugin.gcm.map.db;

import android.content.Context;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;
import android.util.Log;

/**
 * SQLiteOpenHelperを継承したクラスです。
 * 2つのテーブルを作成しています。
 * @author sugi
 *
 */
public class DBHelper extends SQLiteOpenHelper{

	private static final String TAG = "DBHelper"; 
	
	private static final String DATABASE_NAME = "storedata";
	private static final int DATABASE_VARSION = 1;

	private static final String CREATE_TABLE_STORE =
			"CREATE TABLE store (" +
					"id                 INTEGER PRIMARY KEY," +
					"shopname           VARCHAR DEFAULT ('' )," +
					"category           VARCHAR DEFAULT ('' )," +
					"shopinfo           VARCHAR DEFAULT ('' )," +
					"latitude           REAL    NOT NULL DEFAULT ( 0 )," +
					"longitude          REAL    NOT NULL DEFAULT ( 0 )," +
					"openinghours       INTEGER NOT NULL DEFAULT ( 0 )," +
					"parking            INTEGER NOT NULL DEFAULT ( 0 )," +
					"drivethrough       INTEGER NOT NULL DEFAULT ( 0 )," +
					"tableseats         INTEGER NOT NULL DEFAULT ( 0 )," +
					"foodpack           INTEGER NOT NULL DEFAULT ( 0 )," +
					"emoney             INTEGER NOT NULL DEFAULT ( 0 ));" ;

	private static final String CREATE_TABLE_STORE_INFO =
			"CREATE TABLE store_info (" +
					"id                 INTEGER PRIMARY KEY," +
					"shopname           VARCHAR DEFAULT ('' )," +
					"openinghours       VARCHAR DEFAULT ('' )," +
					"address            VARCHAR DEFAULT ('' )," +
					"tel                VARCHAR DEFAULT ('' )," +
					"latitude           REAL    NOT NULL DEFAULT ( 0 )," +
					"longitude          REAL    NOT NULL DEFAULT ( 0 )," +
					"navitimeid         VARCHAR DEFAULT ('' )," +
					"open24h            INTEGER NOT NULL DEFAULT ( 0 )," +
					"parking            INTEGER NOT NULL DEFAULT ( 0 )," +
					"drivethrough       INTEGER NOT NULL DEFAULT ( 0 )," +
					"tableseats         INTEGER NOT NULL DEFAULT ( 0 )," +
					"foodpack           INTEGER NOT NULL DEFAULT ( 0 )," +
					"emoney             INTEGER NOT NULL DEFAULT ( 0 ));" ;

	private static final String DROP_TABLE  = "drop table if exists store";
	private static final String DROP_TABLE2 = "drop table if exists store_info";

	/**
	 * ファクトリーメソッド
	 * @param c
	 * @return
	 */
	public static DBHelper createDBHelper(Context c){
		return new DBHelper(c);
	}

	/**
	 * コンストラクター
	 * @param context
	 */
	public DBHelper(Context context) {
		super(context, DATABASE_NAME, null, DATABASE_VARSION);
	}

	@Override
	public void onCreate(SQLiteDatabase db) {
		db.execSQL(CREATE_TABLE_STORE); // create schedule table.
		db.execSQL(CREATE_TABLE_STORE_INFO);
		Log.d(TAG, "creat_tabke:ok");
		
		Log.d(TAG, "store db sql = "+ CREATE_TABLE_STORE);
		Log.d(TAG, "detail db sql = "+ CREATE_TABLE_STORE_INFO);

	}

	@Override
	public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
		db.execSQL(DROP_TABLE);// drop schedule table if exists.
		db.execSQL(DROP_TABLE2);

		db.execSQL(CREATE_TABLE_STORE); // create schedule table.
		db.execSQL(CREATE_TABLE_STORE_INFO);

	}

}
