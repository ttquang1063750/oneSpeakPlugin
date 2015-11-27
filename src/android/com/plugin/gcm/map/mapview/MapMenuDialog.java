package com.plugin.gcm.map.mapview;

import android.app.Dialog;
import android.content.Context;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.EditText;

import jp.co.matsuyafoods.officialapp.dis.R;

import static com.plugin.gcm.map.mapview.CommonUtilities.URL_CUSTOM;
import static com.plugin.gcm.map.mapview.CommonUtilities.URL_USE_MAP;

/**
 * Dialogを拡張したクラスです。
 * @author sugi
 *
 */
public class MapMenuDialog extends Dialog implements OnClickListener{

	private Context context;

	/**
	 * コンストラクター
	 * レイアウトのセットをしています
	 * @param context
	 */
	public MapMenuDialog(Context context) {
		super(context);

		setContentView(R.layout.menu);
	}

	/**
	 * コンストラクター
	 * レイアウトのセットとリスナーの設定をしています。
	 * @param context
	 * @param theme
	 */
	public MapMenuDialog(Context context, int theme) {
		super(context, theme);
		this.context = context;
		setContentView(R.layout.menu);

		// ボタンの紐付
		Button btnSearch        = (Button)findViewById(R.id.btn_search);
		Button btnEnd           = (Button)findViewById(R.id.btn_menu_end);
		Button btnCustomSearch = (Button)findViewById(R.id.btn_custom_search);
		Button btnUseMap        = (Button)findViewById(R.id.btn_info_use_map);

		// リスナーセット
		btnSearch.setOnClickListener(this);
		btnEnd   .setOnClickListener(this);
		btnCustomSearch.setOnClickListener(this);
		btnUseMap.setOnClickListener(this);
	}

	@Override
	public void onClick(View v) {

		switch(v.getId()){

		case R.id.btn_search: // 検索ボタン
			EditText e = (EditText)findViewById(R.id.edi_address);

			if(!e.getText().toString().equals("")){

				String s = e.getText().toString();
				((MapMainActivity)context).toAddress(s);
				dismiss();
			}

			break;

		case R.id.btn_menu_end: // 閉じるボタン

			this.dismiss();
			break;

		case R.id.btn_custom_search: // カスタム検索ボタン

			// ブラウザ呼び出し(カスタム検索）
			((MapMainActivity)context).openLink(URL_CUSTOM);

			break;
			
		case R.id.btn_info_use_map:
			
			// ブラウザ呼び出し(マップの使い方)
			((MapMainActivity)context).openLink(URL_USE_MAP);
			
			break;
		}

	}

}
