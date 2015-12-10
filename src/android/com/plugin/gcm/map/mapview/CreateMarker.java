package jp.co.matsuyafoods.officialapp.dis.map.mapview;

import android.content.Context;
import android.os.Build;
import android.text.TextUtils.TruncateAt;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.GoogleMap.InfoWindowAdapter;
import com.google.android.gms.maps.GoogleMap.OnInfoWindowClickListener;
import com.google.android.gms.maps.GoogleMap.OnMarkerClickListener;
import com.google.android.gms.maps.model.BitmapDescriptorFactory;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.Marker;
import com.google.android.gms.maps.model.MarkerOptions;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import jp.co.matsuyafoods.officialapp.dis.MainActivity;
import jp.co.matsuyafoods.officialapp.dis.R;
import jp.co.matsuyafoods.officialapp.dis.map.entity.Shop;

/**
 * マップのマーカー（ピン）のイベント管理と作成、
 * 吹き出しのイベント管理と作成をするクラスです。
 * @author sugi
 *
 */
public class CreateMarker implements InfoWindowAdapter, OnInfoWindowClickListener, OnMarkerClickListener{

	private static final String TAG = "CreateMarker";
	
	private static final int ICON_VISIBLE = 1;

	private static final String MATSUYA   = "松屋";
	private static final String MATSUNOYA   = "松乃家";
	private static final String MATSUYA_FOR_YOURSELF   = "MATSUYA for yourself";
	private static final String SERORINOHANA   = "セロリの花";
	private static final String MATSUHATI   = "松八";
	private static final String SUSHIMARU   = "すし丸";
	private static final String SUSHIMATSU  = "すし松";
	private static final String TERRASSE_VERTE  = "カフェ テラス ヴェルト";
	private static final String CHIKINTEI = "チキン亭";
	private static final String FUKUMATSU = "福松";

	private GoogleMap map;
	private Context   context;
	private Shop      shop;

	// 吹き出しView
	private final View view;
	private final TextView    title;
	private final TextView    snippet;

	private ImageView icon1;
	private ImageView icon2;
	private ImageView icon3;
	private ImageView icon4;
	private ImageView icon5;
	private ImageView icon6;

	// 開口している吹き出し
	private Marker lastOpenned = null;
	private Shop   lastShopData = null;

	// 表示マーカーリスト
	private List<Marker> markers = new ArrayList<Marker>();
	// マーカー用データの確保
	private Map<String, Shop> shopList = new HashMap<String, Shop>();


	/**
	 * コンストラクター
	 *  リスナーの登録とオブジェクトの紐付
	 * @param context
	 * @param inflater
	 * @param map
	 */
	public CreateMarker(final Context context, LayoutInflater inflater, GoogleMap map){

		this.map     = map;
		this.context = context;
		view = inflater.inflate(R.layout.balloon_overlay, null);

		// リスナーの登録
		map.setInfoWindowAdapter(this);
		map.setOnInfoWindowClickListener(this);
		map.setOnMarkerClickListener(this);

		// 表示text
		title   = (TextView) view.findViewById(R.id.balloon_item_title);
		snippet = (TextView) view.findViewById(R.id.balloon_item_snippet);
		
		if(Build.VERSION.SDK_INT <= 13){
		     //APIレベル13以前の機種の場合の処理
		}else if(Build.VERSION.SDK_INT >= 14){
		     //APIレベル14以降の機種の場合の処理
			title.setEllipsize(TruncateAt.END);
			snippet.setEllipsize(TruncateAt.END);
		}

		// iconの紐付
		icon1 = (ImageView)view.findViewById(R.id.BalloonView_icon1);
		icon2 = (ImageView)view.findViewById(R.id.BalloonView_icon2);
		icon3 = (ImageView)view.findViewById(R.id.BalloonView_icon3);
		icon4 = (ImageView)view.findViewById(R.id.BalloonView_icon4);
		icon5 = (ImageView)view.findViewById(R.id.BalloonView_icon5);
		icon6 = (ImageView)view.findViewById(R.id.BalloonView_icon6);
	}

	/**
	 * マーカーの作成とマップへの追加
	 * titleに店舗IDを記録することにより紐付ています。
	 * @param shop
	 */
	public void onSet(Shop shop){
		
		// 吹き出し表示されているマーカーと同じマーカーは作らせない
		if (lastShopData != null && shop.getId().equals(lastShopData.getId())){
			return;
		}

		// Optionの作成
		MarkerOptions options = new MarkerOptions();
		LatLng point = new LatLng(shop.getLatitude(), shop.getLongitude());
		// 緯度・経度
		options.position(point);
		// タイトル・スニペット(titleにIDを入れておき、後でshop情報との紐付をする)
		options.title(shop.getId());
		options.snippet(shop.getShopinfo());
		// アイコン(マップ上に表示されるピン)
//		options.icon(BitmapDescriptorFactory.defaultMarker(getCategoryIsIcon(shop)));
		options.icon(BitmapDescriptorFactory.fromResource(getCategoryIsIcon(shop)));

		// mapにマーカーの追加
		Marker marker = map.addMarker(options);
		// マーカーをリストに追加
		markers.add(marker);
		// shopデータの確保(shopIDをキーとして保管）
		shopList.put(shop.getId(), shop);
	}
	
	public void onSetEnd(){
		
		if (lastOpenned != null && lastShopData != null){

			// Optionの作成
			MarkerOptions options = new MarkerOptions();
			LatLng point = new LatLng(lastShopData.getLatitude(), lastShopData.getLongitude());
			// 緯度・経度
			options.position(point);
			// タイトル・スニペット(titleにIDを入れておき、後でshop情報との紐付をする)
			options.title(lastShopData.getId());
			options.snippet(lastShopData.getShopinfo());
			// アイコン(マップ上に表示されるピン)
			options.icon(BitmapDescriptorFactory.fromResource(getCategoryIsIcon(lastShopData)));

			// mapにマーカーの追加
			lastOpenned = map.addMarker(options);
			// マーカーをリストに追加
			markers.add(lastOpenned);
			// shopデータの確保(shopIDをキーとして保管）
			shopList.put(lastShopData.getId(), lastShopData);
			
			lastOpenned.showInfoWindow();
		}
	}

	/**
	 * マーカーのリストを返す
	 * @return List<Marker>
	 */
	public List<Marker> getMarker(){
		return this.markers;
	}

	/**
	 * 所持しているリストデータを消す
	 */
	public void clear(){
		
		for(Marker pin : markers){
			pin.remove();
		}
		
		markers.clear();
		shopList.clear();
	}
	
	public void markerCashClear(){
	
		lastOpenned = null;
		lastShopData = null;
	}
	
	public void maintainSelectMarker(){
		
		if (lastOpenned != null){
			lastOpenned.showInfoWindow();			
		}
	}

	// 吹き出しが呼び出される時のコールバック
	@Override
	public View getInfoWindow(Marker paramMarker) {
//		Log.d(TAG, "#getInfoWindow() call");

		if(!CommonUtilities.BALL_COUNT){
			((MainActivity)context).ballCountOff();
		}

		// 吹き出しView を作成
		render(paramMarker, view);
		return view;
	}

	@Override
	public View getInfoContents(Marker paramMarker) {
//		Log.d(TAG, "#getInfoContents() call title = "+paramMarker.getTitle());
		return null;
	}

	// 吹き出しがタップされた時の処理
	@Override
	public void onInfoWindowClick(Marker paramMarker) {
//		Log.d(TAG, "#onInfoWindowClick() call title = "+paramMarker.getTitle());

		((MainActivity)context).onInfoView(shop);
	}

	// markerクリックコールバック
	@Override
	public boolean onMarkerClick(Marker paramMarker) {

//		Log.d(TAG, "#onMarkerClick() call title = "+paramMarker.getTitle());

		// すでに開かれているマーカーがあるかチェック
		if (lastOpenned != null) {
			// 吹き出しを隠す
			lastOpenned.hideInfoWindow();

			// 吹き出しを消したマーカーがタップされたマーカーなのかチェック
			if (lastOpenned.equals(paramMarker)) {
				// 初期化
				markerCashClear();

				return true;
			}
		}

		// 開かれている吹き出しが存在しなかったら吹き出しを表示する
		paramMarker.showInfoWindow();

		return true;
	}

	/**
	 * マーカータイトルから指定した店舗IDを取得して紐付たデータを取得
	 * 取得したデータをViewに書き込みます。
	 * @param marker
	 * @param view
	 */
	private void render(Marker marker, View view) {
		
		// 履歴を残す
		lastOpenned = marker;
		lastShopData = shopList.get(marker.getTitle());

		// ここでどの Marker がタップされたか判別する
		shop = shopList.get(marker.getTitle());

		Log.d(TAG, "#render() shop＠ = "+ shop);
		if (shop != null) {

			if(shop.getShopname() != null && !"".equals(shop.getShopname())){
				
				title.setText(shop.getShopname());
			}
			
			if(shop.getShopinfo() != null && !"".equals(shop.getShopinfo())){

				snippet.setText(shop.getShopinfo());
				snippet.setVisibility(View.VISIBLE);
			}
			else {
				snippet.setVisibility(View.GONE);
				title.setLines(2);
			}
			
			setIconViews(shop);
		}
	}

	/**
	 * shopデータから表示するアイコンを選別する。
	 * @param s
	 */
	private void setIconViews(Shop s){

		if(s.getOpeninghours() == ICON_VISIBLE){
			icon1.setVisibility(View.VISIBLE);
		}else {
			icon1.setVisibility(View.GONE);
		}
		if(s.getParking() == ICON_VISIBLE){
			icon2.setVisibility(View.VISIBLE);
		}else {
			icon2.setVisibility(View.GONE);
		}
		if(s.getDrivethrough() == ICON_VISIBLE){
			icon3.setVisibility(View.VISIBLE);
		}else {
			icon3.setVisibility(View.GONE);
		}
		if(s.getTableseats() == ICON_VISIBLE){
			icon4.setVisibility(View.VISIBLE);
		}else {
			icon4.setVisibility(View.GONE);
		}
		if(s.getFoodpack() == ICON_VISIBLE){
			icon5.setVisibility(View.VISIBLE);
		}else {
			icon5.setVisibility(View.GONE);
		}
		if(s.geteMoney() == ICON_VISIBLE){
			icon6.setVisibility(View.VISIBLE);
		}else {
			icon6.setVisibility(View.GONE);
		}

	}

	/**
	 * カテゴリー別にマーカー表示画像を選択しています。
	 * @param s
	 * @return int R.id
	 */
	private int getCategoryIsIcon(Shop s){
		String str = s.getCategory();
		int iconRId = 0;
		// カテゴリー（松屋）
		if(MATSUYA.equals(str)){
			iconRId = R.drawable.map_pin_shadow_01;
			return iconRId;
		}
		// カテゴリー（松乃家）
		if(MATSUNOYA.equals(str)){
			iconRId = R.drawable.map_pin_shadow_02;
			return iconRId;
		}
		// カテゴリー（MATSUYA for yourself）
		else if(MATSUYA_FOR_YOURSELF.equals(str)){
			iconRId = R.drawable.map_pin_shadow_03;
			return iconRId;
		}
		// カテゴリー（セロリの花）
		else if(SERORINOHANA.equals(str)){
			iconRId = R.drawable.map_pin_shadow_04;
			return iconRId;
		}
		// カテゴリー（松八）
		else if(MATSUHATI.equals(str)){
			iconRId = R.drawable.map_pin_shadow_05;
			return iconRId;
		}
		// カテゴリー（すし丸）
		else if(SUSHIMARU.equals(str)){
			iconRId = R.drawable.map_pin_shadow_06;
			return iconRId;
		}
		// カテゴリー（すし松）
		else if(SUSHIMATSU.equals(str)){
			iconRId = R.drawable.map_pin_shadow_07;
			return iconRId;
		}
		// カテゴリー（cafe terrasse verte）
		else if(TERRASSE_VERTE.equals(str)){
			iconRId = R.drawable.map_pin_shadow_08;
			return iconRId;
		}
		// カテゴリー（チキン亭）
		else if(CHIKINTEI.equals(str)){
			iconRId = R.drawable.map_pin_shadow_09;
			return iconRId;
		}
		// カテゴリー（福松）
		else if(FUKUMATSU.equals(str)){
			iconRId = R.drawable.map_pin_shadow_10;
			return iconRId;
		}

		return iconRId;

	}



}

