package jp.co.matsuyafoods.officialapp.dis.map.mapview;

import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.text.util.Linkify;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ScrollView;
import android.widget.TextView;

import jp.co.matsuyafoods.officialapp.dis.MainActivity;
import jp.co.matsuyafoods.officialapp.dis.R;
import jp.co.matsuyafoods.officialapp.dis.map.entity.ShopDetail;

import static jp.co.matsuyafoods.officialapp.dis.map.mapview.CommonUtilities.URL_NAVITIME;

/**
 * 詳細表示画面を構成するクラスです。
 * @author sugi
 *
 */
public class ShopInfoView implements OnClickListener{

	private static final int OPEN = 1;

	public  LinearLayout infoView;
	private Context   context;
	private TextView  shopName;
	private TextView  address;
	private TextView  openingHours;
	private TextView  tel;

	private LinearLayout iconTopLine;
	private LinearLayout iconUnderLine;
	private ImageView    icon1;
	private ImageView    icon2;
	private ImageView    icon3;
	private ImageView    icon4;
	private ImageView    icon5;
	private ImageView    icon6;

	private ShopDetail shop;

	/**
	 * コンストラクター
	 * レイアウトの紐付をしています。
	 * @param context
	 * @param inflater
	 */
	public ShopInfoView(Context context, LayoutInflater inflater){

		this.context = context;
		infoView = (LinearLayout)inflater.inflate(R.layout.information, null);
		setInfoView();
	}
	/**
	 * Viewの紐付とリスナーの設定
	 * 初期状態の表示はGONEに指定しています。
	 */
	private void setInfoView(){


		shopName     = (TextView)infoView.findViewById(R.id.info_shopname);
		address      = (TextView)infoView.findViewById(R.id.info_address);
		openingHours = (TextView)infoView.findViewById(R.id.info_openingHours);
		tel          = (TextView)infoView.findViewById(R.id.info_tel);

		iconTopLine  = (LinearLayout)infoView.findViewById(R.id.info_icon_top_linear);
		iconUnderLine= (LinearLayout)infoView.findViewById(R.id.info_icon_under_linear);
		icon1        = (ImageView)infoView.findViewById(R.id.info_icon1);
		icon2        = (ImageView)infoView.findViewById(R.id.info_icon2);
		icon3        = (ImageView)infoView.findViewById(R.id.info_icon3);
		icon4        = (ImageView)infoView.findViewById(R.id.info_icon4);
		icon5        = (ImageView)infoView.findViewById(R.id.info_icon5);
		icon6        = (ImageView)infoView.findViewById(R.id.info_icon6);

		// ボタン
		Button btnInfo      = (Button)infoView.findViewById(R.id.btn_back_to_map);
		Button btnRoot      = (Button)infoView.findViewById(R.id.btn_root);
		Button btnRootToApp = (Button)infoView.findViewById(R.id.btn_root_app);
		btnInfo.setOnClickListener(this);
		btnRoot.setOnClickListener(this);
		btnRootToApp.setOnClickListener(this);

		infoView.setVisibility(View.GONE);

	}
	/**
	 * 渡された詳細情報から内容をセットしています。
	 * @param shop ShopDetail
	 */
	public void setItem(ShopDetail shop){
		this.shop = shop;

		iconTopLine  .setVisibility(View.VISIBLE);
		iconUnderLine.setVisibility(View.VISIBLE);

		// textアイテム
		shopName    .setText(shop.getShopname());
		address     .setText(shop.getAddress());
		openingHours.setText(shop.getOpeningHours());
		tel         .setText(shop.getTel());
		Linkify.addLinks(tel, Linkify.PHONE_NUMBERS);

		// 選択されたiconの数
		int i = 1;
		// iconアイテム
		if(shop.getOpen24h() == OPEN){

			setIconImage(i, R.drawable.icons_01);
			i++;
		}
		if(shop.getParking() == OPEN){

			setIconImage(i, R.drawable.icons_02);
			i++;
		}
		if(shop.getDrivethrough() == OPEN){

			setIconImage(i, R.drawable.icons_03);
			i++;
		}
		if(shop.getTableseats() == OPEN){

			setIconImage(i, R.drawable.icons_04);
			i++;
		}
		if(shop.getFoodpack() == OPEN){

			setIconImage(i, R.drawable.icons_05);
			i++;
		}
		if(shop.geteMoney() == OPEN){

			setIconImage(i, R.drawable.icons_06);
			i++;
		}
		// 後処理、使わないImageViewを隠す
		goneImage(i);
	}

	/**
	 * Icon画像をセットしています。
	 *
	 * @param i
	 * @param id
	 */
	private void setIconImage(int i, int id){

		switch(i){
		case 1:
			icon1.setVisibility(View.VISIBLE);
			icon1.setImageResource(id);
			break;
		case 2:
			icon2.setVisibility(View.VISIBLE);
			icon2.setImageResource(id);
			break;
		case 3:
			icon3.setVisibility(View.VISIBLE);
			icon3.setImageResource(id);
			break;
		case 4:
			icon4.setVisibility(View.VISIBLE);
			icon4.setImageResource(id);
			break;
		case 5:
			icon5.setVisibility(View.VISIBLE);
			icon5.setImageResource(id);
			break;
		case 6:
			icon6.setVisibility(View.VISIBLE);
			icon6.setImageResource(id);
			break;

		}
	}

	/**
	 *  使用しなかったImageViewをINVISIBLEにしています。
	 * @param n
	 */

	private void goneImage(int n){



		for(int i=n; i<=6; i++){

			switch(i){
			case 1:
				icon1.setVisibility(View.INVISIBLE);
				iconTopLine.setVisibility(View.GONE);
				break;
			case 2:
				icon2.setVisibility(View.INVISIBLE);
				break;
			case 3:
				icon3.setVisibility(View.INVISIBLE);
				break;
			case 4:
				icon4.setVisibility(View.INVISIBLE);
				iconUnderLine.setVisibility(View.GONE);
				break;
			case 5:
				icon5.setVisibility(View.INVISIBLE);
				break;
			case 6:
				icon6.setVisibility(View.INVISIBLE);
				break;

			}
		}
	}

	/**
	 * 現在地から選択された店舗位置へのルート検索を開始します。
	 */
	private void searchRoot(){

		// 店舗のAddress取得
		String address = shop.getAddress();

		// 徒歩でのルート検索
		Intent intent = new Intent();
		intent.setAction(Intent.ACTION_VIEW);
		intent.setClassName("com.google.android.apps.maps","com.google.android.maps.MapsActivity");
		intent.setData(Uri.parse("http://maps.google.com/maps?daddr="+address+"&dirflg=w"));
		context.startActivity(intent);
	}
	// クリックリスナー
	@Override
	public void onClick(View v) {

		switch (v.getId()) {

		case R.id.btn_back_to_map:

			// infoViewを不可視にする
			infoView.setVisibility(View.GONE);
			ScrollView scroll= (ScrollView)infoView.findViewById(R.id.info_scroll);
			scroll.scrollTo(0, 0);
			// メインレイアウトの表示
			if(((MainActivity)context).mainLayout == false){

				((MainActivity)context).getFooterLayout().setVisibility(View.VISIBLE);
				((MainActivity)context).mainLayout = true;
			}
			break;

		case R.id.btn_root:

			// URL作成
			String url = URL_NAVITIME + shop.getNavitimeId();
			// ブラウザ呼び出し(カスタム検索）
			((MainActivity)context).openLink(url);
			break;
			
		case R.id.btn_root_app:
			
			searchRoot();
			break;
		}
	}

	/**
	 * Viewの取得
	 * @return LinearLayout
	 */
	public LinearLayout getView(){
		return infoView;
	}
}
