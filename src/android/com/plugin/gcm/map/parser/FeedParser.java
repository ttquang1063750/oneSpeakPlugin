package jp.co.matsuyafoods.officialapp.dis.map.parser;

import java.io.IOException;
import java.io.StringReader;
import java.util.ArrayList;
import java.util.List;

import jp.co.matsuyafoods.officialapp.dis.map.entity.Shop;

import org.xmlpull.v1.XmlPullParser;
import org.xmlpull.v1.XmlPullParserException;
import org.xmlpull.v1.XmlPullParserFactory;

import android.util.Log;

/**
 * 取得したFeedXMLをパースするクラスです。
 * @author sugi
 *
 */
public class FeedParser {

	// 要素タグ
	private static final String ENTRY        = "entry";
	private static final String ID           = "id";
	private static final String SHOPNAME     = "shopname";
	private static final String CATEGORY     = "category";
	private static final String SHOPINFO     = "shopinfo";
	private static final String LATITUDE     = "latitude";
	private static final String LONGITUDE    = "longitude";
	private static final String OPENINGHOURS = "open24h";
	private static final String PARKING      = "parking";
	private static final String DRIVETHROUGH = "drivethrough";
	private static final String TABLESEATS   = "tableseats";
	private static final String FOODPACK     = "foodpack";
	private static final String EMONEY       = "e-money";

	private String mXml;
	private List<Shop> mList = new ArrayList<Shop>();

	/**
	 * コンストラクター
	 * @param xml
	 */
	public FeedParser(String xml){

		mXml = xml;
	}

	/**
	 * 初期準備から解析の開始をします。
	 * @return 正常取得:true 失敗:false
	 */
	public boolean init(){

		boolean success = true;

		try {
			// XMLPullParserの使用準備
			XmlPullParserFactory factory = XmlPullParserFactory.newInstance();
			XmlPullParser         parser = factory.newPullParser();

			parser.setInput(new StringReader(mXml));

			// 処理の準備
			int event  = parser.getEventType();
			Shop shop  = null;
			String tag = null;


			while(event != XmlPullParser.END_DOCUMENT){

				switch(event){

				case XmlPullParser.START_TAG:

					tag = parser.getName();
					if(ENTRY.equals(tag)){
						shop = new Shop();
					}
					break;

				case XmlPullParser.TEXT:

					String text = parser.getText();

					if(text.trim().length() != 0){

						// アイテム（ID）
						if(ID.equals(tag)) {
							shop.setId(text);
						}
						// アイテム（shopname）
						else if(SHOPNAME.equals(tag)){
							shop.setShopname(text);
						}
						// アイテム（category）
						else if(CATEGORY.equals(tag)){
							shop.setCategory(text);
						}
						// アイテム（shopinfo）
						else if(SHOPINFO.equals(tag)){
							shop.setShopinfo(text);
						}
						// アイテム（latitude）
						else if(LATITUDE.equals(tag)){
							shop.setLatitude(Double.valueOf(text));
						}
						// アイテム（longitude）
						else if(LONGITUDE.equals(tag)){
							shop.setLongitude(Double.valueOf(text));
						}
						// アイテム（openinghours）
						else if(OPENINGHOURS.equals(tag)){
							shop.setOpeninghours(Integer.valueOf(text));
						}
						// アイテム（parking）
						else if(PARKING.equals(tag)){
							shop.setParking(Integer.valueOf(text));
						}
						// アイテム（drivathrough）
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
	 * 解析されたリストを返します。
	 * @return List<Shop>
	 */
	public List<Shop> getList(){
		return mList;
	}

}
