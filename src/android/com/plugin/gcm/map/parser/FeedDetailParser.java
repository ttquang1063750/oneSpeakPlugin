package com.plugin.gcm.map.parser;

import android.util.Log;

import com.plugin.gcm.map.entity.ShopDetail;

import org.xmlpull.v1.XmlPullParser;
import org.xmlpull.v1.XmlPullParserException;
import org.xmlpull.v1.XmlPullParserFactory;

import java.io.IOException;
import java.io.StringReader;
import java.util.ArrayList;
import java.util.List;

/**
 * 取得したDetailXMLを解析するクラスです。
 * @author sugi
 *
 */
public class FeedDetailParser {

	// 要素タグ
	private static final String ENTRY        = "entry";
	private static final String ID           = "id";
	private static final String SHOPNAME     = "shopname";
	private static final String OPENINGHOURS = "opening_hours";
	private static final String ADDRESS      = "address";
	private static final String TEL          = "tel";
	private static final String LATITUDE     = "latitude";
	private static final String LONGITUDE    = "longitude";
	private static final String OPEN24H      = "open24h";
	private static final String PARKING      = "parking";
	private static final String DRIVETHROUGH = "drivethrough";
	private static final String TABLESEATS   = "tableseats";
	private static final String FOODPACK     = "foodpack";
	private static final String EMONEY       = "e-money";
	private static final String NAVITIME_ID  = "navitimeid";

	private String mXml;
	private List<ShopDetail> mList = new ArrayList<ShopDetail>();

	/**
	 * コンストラクター
	 * @param xml
	 */
	public FeedDetailParser(String xml){

		mXml = xml;
	}

	/**
	 * 初期準備から解析の開始
	 */
	public boolean init(){

		boolean success =true;
		try {
			// XMLPullParserの使用準備
			XmlPullParserFactory factory = XmlPullParserFactory.newInstance();
			XmlPullParser         parser = factory.newPullParser();

			parser.setInput(new StringReader(mXml));

			// 処理の準備
			int event  = parser.getEventType();
			ShopDetail shop  = null;
			String tag = null;


			while(event != XmlPullParser.END_DOCUMENT){

				switch(event){

				case XmlPullParser.START_TAG:

					tag = parser.getName();
					if(ENTRY.equals(tag)){
						shop = new ShopDetail();
					}
					break;

				case XmlPullParser.TEXT:

					String text = parser.getText();

					if(text.trim().length() != 0){

						// アイテム（id）
						if(ID.equals(tag)) {
							shop.setId(text);
						}
						// アイテム（shopname）
						else if(SHOPNAME.equals(tag)){
							shop.setShopname(text);
						}
						// アイテム（opening_hours）
						else if(OPENINGHOURS.equals(tag)){
							shop.setOpeningHours(text);
						}
						// アイテム（address）
						else if(ADDRESS.equals(tag)){
							shop.setAddress(text);
						}
						// アイテム（tel）
						else if(TEL.equals(tag)){
							shop.setTel(text);
						}
						// アイテム（latitude）
						else if(LATITUDE.equals(tag)){
							shop.setLatitude(Double.valueOf(text));
						}
						// アイテム（longitude）
						else if(LONGITUDE.equals(tag)){
							shop.setLongitude(Double.valueOf(text));
						}
						// アイテム（navitimeid）
						else if(NAVITIME_ID.equals(tag)){
							shop.setNavitimeId(text);
						}
						// アイテム（24h）
						else if(OPEN24H.equals(tag)){
							shop.setOpen24h(Integer.valueOf(text));
						}
						// アイテム（parking）
						else if(PARKING.equals(tag)){
							shop.setParking(Integer.valueOf(text));
						}
						// アイテム（drivethrough）
						else if(DRIVETHROUGH.equals(tag)){
							shop.setDrivethrough(Integer.valueOf(text));
						}
						// アイテム（tableseats）
						else if(TABLESEATS.equals(tag)){
							shop.setTableseats(Integer.valueOf(text));
						}
						// アイテム（foodpack）
						else if(FOODPACK.equals(tag)){
							shop.setFoodpack(Integer.valueOf(text));
						}
						// アイテム（e-money）
						else if(EMONEY.equals(tag)){
							shop.seteMoney(Integer.valueOf(text));
						}

					}
					break;

				case XmlPullParser.END_TAG:

					tag = parser.getName();
					if(ENTRY.equals(tag)){
						mList.add(shop);
					}
					break;
				}
				event = parser.next();
			}

		} catch (XmlPullParserException e) {
			e.printStackTrace();
			Log.e("FeedParser#init", e.toString(), e);
			success = false;
		} catch (IOException e) {
			e.printStackTrace();
			Log.e("FeedParser#init", e.toString(), e);
			success = false;
		}

		return success;
	}

	/**
	 * 解析したDetailリストを返します。
	 * @return
	 */
	public List<ShopDetail> getList(){
		return mList;
	}

}
