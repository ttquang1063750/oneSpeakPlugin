package jp.co.matsuyafoods.officialapp.dis.map;

import android.content.Context;
import android.os.Handler;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;

import jp.co.matsuyafoods.officialapp.dis.MainActivity;

/**
 * プラグインからの呼び出しクラス
 * @author sugi
 *
 */
public class MyMapContent {

	// log関連
	private static final String LOG_TAG = "MyMapContent";
	private boolean mLogFlg = true;	// trueの場合、logを出力する。

	// view関連
	private View mLayoutMain;	//
	//	private TextView	 mTextView;		// 仮のTextView

	// 領域を表示/非表示を判定するフラグ
	private boolean mMapVisibilityFlg = false;

	// UI更新用Handler
	private static Handler mHandler;	// ハンドラー

	// インスタンス
	private static MyMapContent mMapContent;

	// Context
	private Context mContext;

	// map開始Flag
	private boolean isFirst = false;


	public void setmMapVisibilityFlg( final boolean mMapVisibilityFlg) {
		this.mMapVisibilityFlg = mMapVisibilityFlg;
		this.mapContentVisibility();
	}

	/**********************************************
	 * インスタンスの作成
	 * @return
	 *********************************************/
	static public MyMapContent getInstance(){

		if( mMapContent == null ){
			mMapContent = new MyMapContent();
		}
		return mMapContent;
	}

	/**********************************************
	 * コンストラクタ
	 *********************************************/
	private MyMapContent(){
	}

	/**********************************************
	 * logの出力メソッド
	 * @param tag
	 * @param msg
	 *********************************************/
	public void log(String tag, String msg ){
		if( mLogFlg ){
			Log.e( tag, msg);
		}
	}

	/**********************************************
	 * viewを追加する。
	 * @param layoutContents
	 * @param context
	 *
	 *********************************************/
	public void addView(ViewGroup layoutContents, Context context, View view){

		mContext = context;
		// 引数チェック
		if( layoutContents == null ){
			log( LOG_TAG, "layoutContents is null." );
			return;
		}
		// layoutの読み込み
		mLayoutMain = view;

		LinearLayout.LayoutParams params = new LinearLayout.LayoutParams(
				ViewGroup.LayoutParams.MATCH_PARENT,
				ViewGroup.LayoutParams.MATCH_PARENT);
		mLayoutMain.setLayoutParams(params);

		// sampleViewを追加する。myRootViewに追加する。
		layoutContents.addView( mLayoutMain );

		// 紐付け
		findView( mLayoutMain );

		// 初期処理
		init();
	}

	/**********************************************************
	 * layoutのviewと紐付ける。
	 * @param v
	 *
	 **********************************************************/
	public void findView(View v){
		((MainActivity)mContext).init(v);
	}

	/**********************************************************
	 * 初期化処理
	 *
	 **********************************************************/
	public void init(){
		mHandler = new Handler();
		mMapVisibilityFlg = false;
	}

	/**********************************************************
	 *　表示、非表示の指示を行う。
	 * param flg　 true:表示  false:非表示
	 *
	 **********************************************************/
	public void mapContentVisibility( ){
		if( mLayoutMain == null ){
			return;
		}
		// このメソッドは
		// UIスレッドからこない場合もあるので（Pluginからの呼び出し）
		// Handlerを使って、処理する。

		new Thread(new Runnable() {
			@Override
			public void run() {

				if( mHandler != null ){
					mHandler.post(new Runnable() {
						@Override
						public void run() {
							try{
								if( mMapVisibilityFlg ){
									((MainActivity)mContext).mapingStart();
									Log.d(LOG_TAG, "表示");
									mLayoutMain.setVisibility(View.VISIBLE);
								}
								else{Log.d(LOG_TAG, "隠す");
									mLayoutMain.setVisibility(View.GONE);
								}
							}
							catch(Exception e){
								log( LOG_TAG, e.toString());
							}
						}
					});
				}
			}
		}).start();
	}

	/**********************************************************
	 * 画面が表示されたときの処理
	 *********************************************************/
	public void onResume(){
		mapContentVisibility();
	}

	/**********************************************************
	 * 画面がかくれた時の処理
	 *********************************************************/
	public void onPause(){
		mapContentVisibility();
	}

	/**********************************************************
	 * 画面が破棄された時の処理
	 *********************************************************/
	public void onDestroy(){
		mLayoutMain = null;
		mHandler    = null;
	}
}
