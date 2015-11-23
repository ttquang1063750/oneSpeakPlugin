package jp.co.matsuyafoods.officialapp.dis.map.mapview;


import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

import jp.co.matsuyafoods.officialapp.dis.R;
import jp.co.matsuyafoods.officialapp.dis.map.MyMapContent;
import jp.co.matsuyafoods.officialapp.dis.map.db.DBHelper;
import jp.co.matsuyafoods.officialapp.dis.map.db.DetailDAO;
import jp.co.matsuyafoods.officialapp.dis.map.db.StoreDAO;
import jp.co.matsuyafoods.officialapp.dis.map.entity.RequestRange;
import jp.co.matsuyafoods.officialapp.dis.map.entity.Shop;
import jp.co.matsuyafoods.officialapp.dis.map.entity.ShopDetail;
import jp.co.matsuyafoods.officialapp.dis.map.parser.FeedDetailParser;
import jp.co.matsuyafoods.officialapp.dis.map.parser.FeedParser;

import org.apache.cordova.CordovaWebView;
import org.apache.cordova.DroidGap;

import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
import android.database.sqlite.SQLiteDatabase;
import android.graphics.Paint;
import android.location.Address;
import android.location.Geocoder;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.Handler;
import android.preference.PreferenceManager;
import android.util.DisplayMetrics;
import android.util.Log;
import android.util.TypedValue;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewTreeObserver;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.FrameLayout;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.google.android.gms.common.GooglePlayServicesNotAvailableException;
import com.google.android.gms.maps.CameraUpdateFactory;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.GoogleMap.OnCameraChangeListener;
import com.google.android.gms.maps.GoogleMap.OnMapClickListener;
import com.google.android.gms.maps.GoogleMap.OnMyLocationChangeListener;
import com.google.android.gms.maps.MapView;
import com.google.android.gms.maps.MapsInitializer;
import com.google.android.gms.maps.UiSettings;
import com.google.android.gms.maps.model.CameraPosition;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.VisibleRegion;


/**
 * マップを表示から操作する。
 * DroidGapを継承することにより、
 * PhoneGapに対応しています。
 * @author sugi
 *
 */
public class MapMainActivity extends DroidGap implements OnClickListener, LocationListener, OnMyLocationChangeListener {

	private static final String TAG = "MapMainActivity";
	// ズームレベル
	private static final int ZOOM = 15;
	// ロケーションタイプ
	private static final String GPS     = "gps";
	private static final String NETWORK = "network";

	private MyMapContent           myMapCotnent = null;	// map領域の操作クラス
	private CordovaWebView         cordovaWebView = null;
	// ネットワーク接続不可通知View
	private LinearLayout mNetNotificationView;
	// マップ
	private MapView       mapView;
	private GoogleMap     mMap;
	private CreateMarker  createMarker;
	private LinearLayout  footer;
	private MapMenuDialog menuDialog;
	// ロケーション
	private LocationManager locationManager;
	// SharedPreferences
	private SharedPreferences sharedprf;
	// DB
	private DBHelper        dbHelper;
	private SQLiteDatabase  db;
	private DBfindAsyncTask dbFindAsyncTask;
	private boolean        isFast = true;
	// 吹き出しカウンター
	private  int ball = 0;
	// infoview関係
	private ShopInfoView   infoView;
	private LayoutInflater inflater;
	// マップの中心
	private LatLng lastCenter;
	// mainLayoutフラグ
	public boolean mainLayout;
	// 通信Dialog
	private ProgressDialog dialog;
	// 通過チェック
	private boolean isSetCheck = false;
	// 更新dateの保持
	private String mUpDate;
	// データ問い合わせタスク
	private UpdateCheckAsyncTask updateCheckAsyncTask;
	private LoadAsyncTask loadAsyncTask;
	private Handler mHandler = null;
	private boolean isLoadData = false;

	//----------------Viewを重ねる設定--------------------------------------------
	
	@Override
	public void onCreate(Bundle savedInstanceState) {
		// キーボード出現時レイアウトの指定
		this.getWindow().setSoftInputMode(android.view.WindowManager.LayoutParams.SOFT_INPUT_ADJUST_PAN);
		super.onCreate(savedInstanceState);
	}

	/**
	 * 表示されたとき
	 */
	@Override
	public void onResume(){

		mapView.onResume();
		super.onResume();

		if(CommonUtilities.SET_GPS){
			// リスナーのセット
			setLocation();
			// 自分の位置表示
			setMyLocation();
			CommonUtilities.SET_GPS = false;
			isFast = true;
		}

		if(myMapCotnent != null ){
			myMapCotnent.onResume();
		}
	}

	/**
	 * 隠れたとき
	 */
	@Override
	public void onPause(){
		
		if(mMap != null && locationManager != null){
			mMap.setMyLocationEnabled(true);
			locationManager.removeUpdates(this);
		}
		
		mapView.onPause();
		super.onPause();

		if(myMapCotnent != null ){
			myMapCotnent.onPause();
		}
	}

	/**
	 * システムの空きメモリが足りなくなったとき
	 */
	@Override
	public void onLowMemory() {
		mapView.onLowMemory();
		super.onLowMemory();
	}

	/**
	 * 破棄する時
	 */
	@Override
	public void onDestroy(){

		mapView.onDestroy();
		super.onDestroy();

		if(myMapCotnent != null ){
			myMapCotnent.onDestroy();
		}
	}

	/**
	 * 破棄されるケースでBundleにデータ保存されるとき
	 */
	@Override
	protected void onSaveInstanceState(Bundle outState) {
		mapView.onSaveInstanceState(outState);
	}

	@Override
	public boolean dispatchKeyEvent(KeyEvent event) {

		// Backボタン検知する
		if(event.getKeyCode() == KeyEvent.KEYCODE_BACK
				&& infoView.getView().getVisibility() == View.VISIBLE) {

			infoView.getView().setVisibility(View.GONE);
			footer.setVisibility(View.VISIBLE);
			return false;
		}
		// Backボタンに関わらないボタンが押された場合は、通常処理.
		return super.dispatchKeyEvent(event);
	}

	/**
	 * 初期画面をロード
	 * マップ表示領域の設定
	 * @param url
	 */
	public void loadUrl(String url, int i){
		// 初期画面をload
		super.loadUrl(url, i);

		//map領域の操作クラスのインスタンス化
		myMapCotnent = MyMapContent.getInstance();

		// RootとなるLayoutを読込
		RelativeLayout layoutContents = (RelativeLayout)this.getLayoutInflater().inflate(R.layout.root_view, null);
		// rootを書き換える。 rootView
		setContentView(layoutContents);
		// webViewをmyRootViewに追加する。
		layoutContents.addView(super.root);
		// viewの読み込み
		myMapCotnent.addView(this.getLayoutInflater(), layoutContents, this);

		// マップオブジェクトの生成
		try {
			MapsInitializer.initialize(this);
			mapView = (MapView)this.findViewById(R.id.mapview);
			mapView.onCreate(getIntent().getExtras());
			mMap = mapView.getMap();
			// UIset(デフォルトボタンの排除）
			UiSettings ui = mMap.getUiSettings();
			ui.setMyLocationButtonEnabled(false);
		} catch (GooglePlayServicesNotAvailableException e) {
			e.printStackTrace();
			Log.d(TAG+" MapsInitializer", e.toString(),e);
		}
		// cordovaWebViewの取得
		cordovaWebView = super.appView;
	}

	//----------------------------------------------------------------------------

	/**
	 * map初期準備
	 * @param v 親View
	 **/
	public void init(View v){

		FrameLayout frameLayout = (FrameLayout)v.findViewById(R.id.map_frame);
		mNetNotificationView = (LinearLayout)v.findViewById(R.id.net_notification);
		footer = (LinearLayout)v.findViewById(R.id.map_footer);

		Button btnHere      = (Button)v.findViewById(R.id.btn_here);
		Button btnMenu      = (Button)v.findViewById(R.id.map_menu);
		final Button btnWeb = (Button)v.findViewById(R.id.btn_web);
		Button btnBalloon   = (Button)v.findViewById(R.id.btn_balloon);
		TextView reloadView = (TextView)v.findViewById(R.id.reload_view);
		btnHere   .setOnClickListener(this);
		btnMenu   .setOnClickListener(this);
		btnWeb    .setOnClickListener(this);
		btnBalloon.setOnClickListener(this);
		reloadView.setOnClickListener(this);
		
		// 「新店・一時閉店」を端末解像度に応じるボタンサイズで表示を変更する
		ViewTreeObserver viewTreeObserver = btnWeb.getViewTreeObserver();
		viewTreeObserver.addOnGlobalLayoutListener(new ViewTreeObserver.OnGlobalLayoutListener() {
			@Override
			public void onGlobalLayout() {
				
				int width = btnWeb.getWidth();
				
				String text = btnWeb.getText().toString();
				Paint paint = new Paint();
				paint.setTextSize(btnWeb.getTextSize());
				float textWidth = paint.measureText(text);
				
				if (width < textWidth){
					btnWeb.setText("新店・ \n一時閉店");
				}
				else {
					btnWeb.setText(text);
				}
			}
		});

		// infoViewの追加
		inflater = this.getLayoutInflater();
		infoView = new ShopInfoView(this,inflater);
		frameLayout.addView(infoView.infoView);

		// SharedPreferencesの生成
		sharedprf = PreferenceManager.getDefaultSharedPreferences(this);
		// map設定
		setUpMapIfNeeded();
		// Layoutフラグ
		mainLayout = true;

	}

	/**
	 * map利用開始。
	 * キャッシュを確認し、更新する必要があればデータの更新を行う。
	 *
	 **/
	public void mapingStart(){
		
		// タスク処理されていたらキャンセルさせる
		if(updateCheckAsyncTask != null){
			if(updateCheckAsyncTask.getStatus() == AsyncTask.Status.PENDING ||
					updateCheckAsyncTask.getStatus() == AsyncTask.Status.RUNNING){
				updateCheckAsyncTask.cancel(true);
				updateCheckAsyncTask = null;
				
			}
		}
		
		if(dialog != null)dialog.dismiss();
		
		if (isLoadData == false){
			
			setProgressDialog();		
		}
		updateCheckAsyncTask = new UpdateCheckAsyncTask(this);
		updateCheckAsyncTask.execute();
	}
	
	/**
	 * アップデートチェックでの通信エラーで呼ばれます。
	 */
	public void loadError(){
		
		// 通信できない場合に表示するViewを表示
		mNetNotificationView.setVisibility(View.VISIBLE);
		
		if (dialog != null)dialog.dismiss();
		if (isLoadData == false)errorDialog();
		
		setLocations();
	}
	
	/**
	 * ロケーションのセットアップを行います。
	 */
	private void setLocations(){
		
		if(isSetCheck == false){
			isFast = true;
			// リスナーのセット
			setLocation();
			setMyLocation();
			// マーカー用セットクラス
			createMarker = new CreateMarker(this, inflater, mMap);
		}
		
		// GPSのチェック
		CommonUtilities.chkGpsService(this, locationManager);
		
		isSetCheck = true;
	}
	
	/**
	 * データ更新の問い合わせ後呼ばれます。
	 * @param upDateString 更新日
	 */
	public void loadSuccess(String upDateString){
		
		if (dialog != null)dialog.dismiss();
		mUpDate = upDateString;
		// 通信できない場合に表示するViewを非表示
		mNetNotificationView.setVisibility(View.GONE);
		
		if(CommonUtilities.checkFeed(sharedprf, upDateString)){
			isLoadData = true;
			setLocations();
		}
		else if (isLoadData == false) {
			
			loadTask();
		}
	}

	/**
	 * footer部のレイアウト取得
	 * @return LinearLayout
	 */
	public LinearLayout getFooterLayout(){
		return footer;
	}


	/**
	 * mapの紐付と初期uiの設定
	 *
	 */
	private void setUpMapIfNeeded() {
		// fragmentにmapがセットされてなかったらマップをセットする
		if (mMap == null) {

			mapView = (MapView)this.findViewById(R.id.mapview);
			mMap = mapView.getMap();
		}
	}

	/**
	 *  InAppBrowser でリンクを呼び出す
	 * @param url
	 */
	public void openLink(String url){

		cordovaWebView.loadUrl("javascript:window.open('"+ url +"','_blank','closebuttoncaption=戻る,EnableViewPortScale=yes')");
	}

	/**
	 * Daialogのセットと開始
	 */
	private void setProgressDialog(){
		
		dialog = new ProgressDialog(this);
		dialog.setProgressStyle(ProgressDialog.STYLE_SPINNER);
		dialog.setMessage("読み込み中...");
		dialog.setCancelable(false);
		
		dialog.show();
	}

	/**
	 * データ取得通信タスクの開始
	 */
	private void loadTask(){
		
		// タスク処理されていたらキャンセルさせる
		if(loadAsyncTask != null){
			if(loadAsyncTask.getStatus() == AsyncTask.Status.PENDING ||
					loadAsyncTask.getStatus() == AsyncTask.Status.RUNNING){
				loadAsyncTask.cancel(true);
				loadAsyncTask = null;
			}
		}
		
		// 通信タスク
		loadAsyncTask = new LoadAsyncTask(this);
		loadAsyncTask.execute();
	}

	@Override
	public void onClick(View v) {
		switch(v.getId()){

		case R.id.btn_here:
			// GPSのチェック
			CommonUtilities.chkGpsService(this, locationManager);

			if (mMap.getMyLocation() == null){

				Toast.makeText(this, "現在地を取得できませんでした。", Toast.LENGTH_LONG).show();
			}
			else {

				LatLng lastpoint = new LatLng(mMap.getMyLocation().getLatitude(), mMap.getMyLocation().getLongitude());
				mMap.moveCamera(CameraUpdateFactory.newLatLngZoom(lastpoint, ZOOM));
			}

			break;

		case R.id.map_menu:

			// 画面サイズの取得と横幅9割になるように設定
			DisplayMetrics metrics = getResources().getDisplayMetrics();
			int dialogWidth = (int) (metrics.widthPixels * 0.9);

			// ダイアログの生成
			menuDialog = new MapMenuDialog(this, R.style.Theme_InfoDialog);

			// 作成した画面サイズをダイアログにセット
			WindowManager.LayoutParams lp = menuDialog.getWindow().getAttributes();
			lp.width = dialogWidth;
			menuDialog.getWindow().setAttributes(lp);

			menuDialog.show();
			break;

		case R.id.btn_web:

			// 専用ブラウザでリンクを表示する
			openLink(CommonUtilities.URL_NEWSHOP);

			break;

		case R.id.btn_balloon:

			CommonUtilities.BALL_COUNT = true;

			if(ball == createMarker.getMarker().size()) ball = 0;

			if(createMarker.getMarker().size() > ball){

				createMarker.getMarker().get(ball).showInfoWindow();
				// カウンターの更新
				ball++;;

				// 吹き出し制御終了
				CommonUtilities.BALL_COUNT = false;
			}
			break;
			
		case R.id.reload_view:
			
			if(infoView.getView().getVisibility() == View.VISIBLE) {

				infoView.getView().setVisibility(View.GONE);
				footer.setVisibility(View.VISIBLE);
			}

			isLoadData = false;
			mapingStart();
			break;
		}
	}

	public void ballCountOff(){
		ball = 0;
	}

	/**
	 * ロケーションマネージャーの設定
	 * 使用するプロバイダーの履歴が取れない時、
	 * 初期位置に三鷹を表示します。
	 * 履歴取得で前回位置を教示します。
	 */
	private void setLocation(){

		Location locate = null;

		locationManager = (LocationManager) getSystemService(Context.LOCATION_SERVICE);

		// ロケーションマネージャーのセット
		locationManager.removeUpdates(this);
		List<String> providers = locationManager.getProviders(true);

		for (String provider : providers) {
			if(provider.equals(GPS)){
				
				locationManager.requestLocationUpdates(provider, 0, 0, this);
				locate = locationManager.getLastKnownLocation(provider);
				break;
			}else if(provider.equals(NETWORK)){
				
				locationManager.requestLocationUpdates(provider, 0, 0, this);
				locate = locationManager.getLastKnownLocation(provider);
				break;
			}
		}

		// 位置情報を取得できない場合三鷹駅を中心に表示する
		if(locate == null){

			/***********************************
			 * 三鷹駅（東京） (三鷹駅)
			 * 座標: 35.702708, 139.560831
			 ***********************************/
			mMap.moveCamera(CameraUpdateFactory.newLatLngZoom(CommonUtilities.MITAKA, ZOOM));

		}else {

			// 前回取得位置の表示
			LatLng lastpoint = new LatLng(locate.getLatitude(), locate.getLongitude());
			mMap.moveCamera(CameraUpdateFactory.newLatLngZoom(lastpoint, ZOOM));
			lastpoint = null;
		}
	}

	@Override
	public void onMyLocationChange(Location location) {
		setFastLocation(location);
	}

	@Override
	public void onLocationChanged(Location location) {
		setFastLocation(location);
		locationManager.removeUpdates(this);
	}
	/**
	 * 初回GPS取得で位置を表示
	 * @param location
	 */
	private void setFastLocation(Location location){

		if(isFast){

			LatLng p = new LatLng(location.getLatitude(), location.getLongitude());
			mMap.moveCamera(CameraUpdateFactory.newLatLngZoom(p, ZOOM));
			getCorners();

			isFast = false;
			p = null;
		}
	}
	@Override
	public void onProviderDisabled(String provider) {}

	@Override
	public void onProviderEnabled(String provid){}

	@Override
	public void onStatusChanged(String provider, int status, Bundle extras) {}

	/**
	 * myLocationのセットとリスナーの設定
	 *
	 */
	private void setMyLocation(){

		// マップがセットされていたらマイロケーションuiをつける
		if(mMap != null){

			mMap.setMyLocationEnabled(true);
			mMap.setOnMyLocationChangeListener(this);
		}

		// リスナーのセット(カメラ位置が変わったら）
		mMap.setOnCameraChangeListener(new OnCameraChangeListener() {

			@Override
			public void onCameraChange(CameraPosition position) {

				if(!mMap.getCameraPosition().target.equals(lastCenter)){
					
					if (mHandler == null){
						
						mHandler = new Handler();
						mHandler.postDelayed(new Runnable() {
							
							@Override
							public void run() {
								
								getCorners();
							}
						}, 300);
					}
					
				}
			}
		});

		// リスナーのセット（マップがタップされたら）
		mMap.setOnMapClickListener(new OnMapClickListener() {

			@Override
			public void onMapClick(LatLng arg0) {
				// mapの中心座標の取得
				lastCenter = mMap.getCameraPosition().target;
				// 吹き出しカウンターの初期化
				ball = 0;
				// 吹き出し表示されていればそれを維持
				createMarker.maintainSelectMarker();
			}
		});
	}

	/**
	 *  四隅の座標と現在地を取得してDBアクセス
	 */
	private void getCorners(){
		mHandler = null;
		VisibleRegion vr = mMap.getProjection().getVisibleRegion();

		// 位置データ受け渡しオブジェクト
		RequestRange range = new RequestRange();

		range.setWestLat(vr.latLngBounds.southwest.latitude);
		range.setEastLat(vr.latLngBounds.northeast.latitude);
		range.setSouthLng(vr.latLngBounds.southwest.longitude);
		range.setNorthLng(vr.latLngBounds.northeast.longitude);

		double cLatitude  = 0;
		double cLongitude = 0;
		
		if (mMap != null){
			
			LatLng latLng = mMap.getCameraPosition().target;
			cLatitude = latLng.latitude;
			cLongitude = latLng.longitude;
		}

		range.setcLatitude(cLatitude);
		range.setcLongitude(cLongitude);

		// タスク処理されていたらキャンセルさせる
		if(dbFindAsyncTask != null){
			if(dbFindAsyncTask.getStatus() == AsyncTask.Status.PENDING ||
					dbFindAsyncTask.getStatus() == AsyncTask.Status.RUNNING){
				dbFindAsyncTask.cancel(true);
				dbFindAsyncTask = null;
			}
		}

		dbFindAsyncTask = new DBfindAsyncTask (this, range);
		dbFindAsyncTask.execute();
	}

	/**
	 * マップ上にピンの追加
	 * @param shops shopのリスト
	 */
	public void putOverLay(List<Shop> shops){
		// 既存データの初期化
		createMarker.clear();
		ball = 0;

		int	listCount = shops.size();
		List<Shop> newList = new ArrayList<Shop>();
		if(listCount > 100){
			
			float val = (float)listCount/100;
			BigDecimal rate = new BigDecimal(val);
			
			int num = 0;
	        for (int k = 0; k < 100 ; k++) {
	            
	            if (listCount > num) {
	                
	            	newList.add(shops.get(num));
	            }
	            else {
	                break;
	            }
	          
	            num += rate.setScale(0, BigDecimal.ROUND_HALF_UP).doubleValue();
	        }
		}
		
		int flag = 0;
		for(Shop shop : (listCount > 100) ? newList : shops){

			createMarker.onSet(shop);

			flag++;
			if(flag > 100)break;
		}
		
		createMarker.onSetEnd();
	}

	/**
	 * 指定住所から位置の取得とカメラ移動
	 * @param s 入力テキスト
	 */
	public void toAddress(String s){
		
		Geocoder geocoder = new Geocoder(this, Locale.JAPAN);
		List<Address> list = null;
		try {
			list = geocoder.getFromLocationName(s, 1);

			if(list.size() < 1){

				// ダイアログで通知
				new AlertDialog.Builder(this)
				.setTitle("エラー")
				.setMessage("指定された場所は見つかりませんでした")
				.setPositiveButton(
						"OK",
						new DialogInterface.OnClickListener() {
							@Override
							public void onClick(DialogInterface dialog, int which) {
								dialog.dismiss();
							}
						}).show();
				return;
			}

			Address address   = list.get(0);
			double latitude  = address.getLatitude();
			double longitude = address.getLongitude();

			LatLng lastpoint = new LatLng(latitude, longitude);
			mMap.moveCamera(CameraUpdateFactory.newLatLngZoom(lastpoint, ZOOM));

			menuDialog = null;

		} catch (IOException e) {

			Toast.makeText(this,"取得に失敗しました。", Toast.LENGTH_SHORT).show();

			Log.e("IOException",e.toString(),e);
		}

	}

	/**
	 * 店舗詳細画面表示
	 * @param shop Shop
	 */
	public void onInfoView(Shop shop){

		if(mainLayout == true){

			footer.setVisibility(View.GONE);
			mainLayout = false;
		}
		// dbHelper準備
		dbHelper = DBHelper.createDBHelper(this);
		// DBマネージャー
		db = dbHelper.getWritableDatabase();
		// DAO
		DetailDAO dao = new DetailDAO(db);
		// 詳細の取得
		ShopDetail s = dao.findShopDetail(shop.getId());
		db.close();
		dbHelper = null;
		dao      = null;

		infoView.infoView.setVisibility(View.VISIBLE);
		
		if (s != null){
			
			infoView.setItem(s);	
		}
	}

	/**
	 * FeedとDetailのデータ取得
	 *  取得後更新日の記録とmapの初期準備
	 *  取得失敗時ダイアログで通知
	 * @author sugi
	 *
	 */
	private class LoadAsyncTask extends AsyncTask<Void, Void, String>{

		private StoreDAO storeDAO;
		private DetailDAO detailDAO;
		private String feedXml;
		private String detailXml;
		private List<Shop> list;
		private List<ShopDetail> detailList;
		private Context c;

		// DBアクセス制御
		private boolean success;

		/**
		 * コンストラクター
		 * @param c Context
		 */
		public LoadAsyncTask(Context c){
			this.c = c;
			success = true;
		}

		@Override
		protected void onPreExecute() {
			super.onPreExecute();
			// ダイアログ開始
			setProgressDialog();

			// dbHelper準備
			dbHelper = DBHelper.createDBHelper(c);
			// DBマネージャー
			db = dbHelper.getWritableDatabase();

			// storeDAO
			storeDAO = new StoreDAO(db);
			detailDAO = new DetailDAO(db);
			// 既存テーブルデータの削除
			db.beginTransaction();
			try {

				storeDAO.deleteAll();
				detailDAO.deleteInfoAll();
				db.setTransactionSuccessful();
				success = true;
			}
			catch (Exception e) {
				e.printStackTrace();
				success = false;
			}
			finally{
				db.endTransaction();
			}
		}

		@Override
		protected String doInBackground(Void... arg0) {

			HttpConnectionsHelper httpHelper = new HttpConnectionsHelper();

			// delete失敗の場合処理をしない
			if (success == false) return "";

			// Feedの取得
			feedXml = httpHelper.sendGet(CommonUtilities.URL_FEED);

			// 正常取得できたらDetailを取得
			if (feedXml != null && !feedXml.startsWith(HttpConnectionsHelper.ERROR)){
				// Detailの取得
				detailXml = httpHelper.sendGet(CommonUtilities.URL_FEED_DETAIL);
			}
			else {
				return feedXml;
			}

			if(detailXml != null && detailXml.startsWith(HttpConnectionsHelper.ERROR)) return detailXml;

			FeedParser parser = new FeedParser(feedXml);
			FeedDetailParser detailParser = new FeedDetailParser(detailXml);


			if(parser.init() == true && detailParser.init() == true 
					&& parser.getList().size() > 0 && detailParser.getList().size() > 0){
				
				list = parser.getList();
				detailList = detailParser.getList();

				db.beginTransaction();
				try {

					for(Shop shop : list){

						if(storeDAO.insert(shop) == StoreDAO.ERROR){
							success = false;
							break;
						}
						else {
							success = true;
						}
					}

					for(ShopDetail shop : detailList){

						if(success == false || detailDAO.insertInfo(shop) == DetailDAO.ERROR){
							success = false;
							break;
						}
						else {
							success = true;
						}
					}

					if(success){
						db.setTransactionSuccessful();
					}
				} catch (Exception e) {
					e.printStackTrace();
					success = false;
				} finally{
					db.endTransaction();
				}

			}
			else {
				success = false;
			}
			return null;
		}

		@Override
		protected void onPostExecute(String result) {
			db.close();
			dbHelper = null;
			dialog.dismiss();
			Editor e = sharedprf.edit();

			// DBエラー、通信エラーが起きた時
			if(success == false || feedXml.startsWith(HttpConnectionsHelper.ERROR) || detailXml.startsWith(HttpConnectionsHelper.ERROR)){
				errorDialog();
				mNetNotificationView.setVisibility(View.VISIBLE);
			}
			else {
				// 更新した時間を記録
				e.putString(CommonUtilities.SHAREDPREF_FEED_UP_DATE, mUpDate);
				e.commit();
				isLoadData = true;
				mNetNotificationView.setVisibility(View.GONE);
				
				// マップのリロード
				if (mMap != null && createMarker != null){
					Log.d(TAG, "tesuto");
					createMarker.markerCashClear();
					getCorners();
				}
			}
			isFast = false;
			
			// ロケーションリスナーのセット
			setLocations();
		}
	}
	
	/**
	 * 通信エラーダイアログの表示
	 * 再試行で再度読み込み
	 */
	private void errorDialog(){
		// 通信失敗時のダイアログ
		new AlertDialog.Builder(MapMainActivity.this)
		.setTitle("インターネット接続不可")
		.setMessage("インターネット接続がありません。\nネットワークのよい環境でお試しください。")
		.setPositiveButton(
				"再試行",
				new DialogInterface.OnClickListener() {
					@Override
					public void onClick(DialogInterface dialog, int which) {
						mapingStart();
					}
				})
				.setNegativeButton(
						"キャンセル",
						new DialogInterface.OnClickListener() {
							@Override
							public void onClick(DialogInterface dialog, int paramInt) {
								dialog.dismiss();
							}
						}).show();
	}
}
