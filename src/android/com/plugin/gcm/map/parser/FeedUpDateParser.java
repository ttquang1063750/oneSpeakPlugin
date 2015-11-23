package jp.co.matsuyafoods.officialapp.dis.map.parser;

import java.io.IOException;
import java.io.StringReader;

import org.xmlpull.v1.XmlPullParser;
import org.xmlpull.v1.XmlPullParserException;
import org.xmlpull.v1.XmlPullParserFactory;

import android.util.Log;

public class FeedUpDateParser {
	
	private static final String TAG = "FeedUpDateParser";
	
	// 要素タグ
	private static final String DATE = "date";

	private String mXml;
	private String mUpDateString;

	/**
	 * コンストラクター
	 * @param xml
	 */
	public FeedUpDateParser(String xml){
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
			String tag = null;


			while(event != XmlPullParser.END_DOCUMENT){

				switch(event){

				case XmlPullParser.START_TAG:

					tag = parser.getName();
					break;

				case XmlPullParser.TEXT:

					String text = parser.getText();
					
					if(text.trim().length() != 0){

						// アイテム（ID）
						if(DATE.equals(tag)) {
							
							mUpDateString = text;
						}
					}
					break;

				case XmlPullParser.END_TAG:

				}
				event = parser.next();
			}

		} catch (XmlPullParserException e) {
			e.printStackTrace();
			Log.e(TAG+"#init", e.toString(), e);
			success = false;
		} catch (IOException e) {
			e.printStackTrace();
			Log.e(TAG+"#init", e.toString(), e);
			success = false;
		}
		return success;

	}

	/**
	 * 解析した更新日を返します
	 * @return String 
	 */
	public String getUpDateString(){
		return mUpDateString;
	}

}
