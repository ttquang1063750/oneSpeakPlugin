package com.plugin.gcm;

import android.content.Context;
import android.content.SharedPreferences;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.content.pm.PackageManager.NameNotFoundException;
import android.os.Bundle;

import net.isana.OneSpeak.OneSpeak;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.params.BasicHttpParams;
import org.apache.http.params.HttpConnectionParams;
import org.apache.http.params.HttpParams;
import org.apache.http.util.EntityUtils;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.UUID;

import jp.co.matsuyafoods.officialapp.dis.MainActivity;
import jp.co.matsuyafoods.officialapp.dis.R;
import jp.co.matsuyafoods.officialapp.dis.map.MyMapContent;
import jp.co.matsuyafoods.officialapp.dis.map.mapview.HttpConnectionsHelper;

public class OneSpeakPlugin extends CordovaPlugin {
    /**
     * SharedPreferencesキー：UUID
     */
    private static final String PREFERENCE_KEY_UUID = "uuid";
    private static final String VERSION = "version";
    /**
     * SharedPreferencesファイル名
     */
    private static final String PREFERENCE_NAME = "onespeak_plugin_preference";

    /**
     * API項目名:KEY
     */
    private static final String API_COLUMN_KEY = "key";
    /**
     * API項目名:リクエスト日時
     */
    private static final String API_COLUMN_DATE = "date";
    /**
     * API項目名:リクエスト
     */
    private static final String API_COLUMN_REQUEST = "request";
    /**
     * API項目名:更新タイプ
     */
    private static final String API_COLUMN_TYPE = "type";
    /**
     * API項目名:更新キー
     */
    private static final String API_COLUMN_KEYDATA = "key_data";
    /**
     * API項目名:更新データ
     */
    private static final String API_COLUMN_CUSTOM_DATA = "custom_data";
    /**
     * API項目名:応答コード
     */
    private static final String API_COLUMN_STATUS = "status";
    /**
     * API項目名:エラーメッセージ
     */
    private static final String API_COLUMN_ERRORS = "errors";

    /**
     * APIパス
     */
    private static final String PLUGIN_API_PATH = "/api/device/custom/update";
    /**
     * OneSpeakアカウントID取得キー
     */
    private static final String ONESPEAK_ACCOUNT = "net.isana.OneSpeak.accountID";

    /**
     * OKステータスコード
     */
    private static final int HTTP_STATUS_CODE_OK = 200;
    /**
     * ソケットタイムアウト時間
     */
    private static final int SOCKET_TIMEOUT = 30000;
    /**
     * コネクションタイムアウト時間
     */
    private static final int CONNECT_TIMEOUT = 30000;

    /**
     * 文字コード名：UTF-8
     */
    private static final String CHARSET_NAME_UTF8 = "UTF-8";

    /**
     * Atlas21 追加コード start
     */
    // //////////////////// プッシュ通知のオプション値保存用 //////////////////////////////////
    private static final String ONESPEAK_CUSTOMDATA = "onespeak_custom_data";
    private static final String ONESPEAK_CUSTOMID = "event_id";

    // 保存データ取得アクション定数
    private static final String GET_DATA = "loadCustomData";

    // 値が存在しない場合のメッセージ
    private static final String NO_DATA = "値がありません。";
    // 例外時のエラーメッセージ
//    private static final String EXCEPTION = "例外：";
    // 存在しないメソッド名が実行されようとした時のエラーメッセージ
//    private static final String ERR_MSG_UNKNOWN_METHOD = "unknown method.";


    public static final String ACTION_MAP_CONTROLLER = "mapController";
    public static final String MAP_ON = "map_on";
    public static final String MAP_OFF = "map_off";

    // 許可する場合のアクション定数
    private static final String PUSH_ALLOW = "push_allow";
    // 許可しない場合のアクション定数
    private static final String PUSH_FORBID = "push_forbid";
    // Push通知の設定を確認するアクション定数
    private static final String PUSH_CONFIRM = "push_confirm";
    private static final String FEED = "feed";

    // 各フラグ定数
    private static final String ONESPEAK_PREFERENCE_FILE = "couponapp_onespeak_pref";
    private static final String ONESPEAK_FLG = "onespeakflg";
    private static final int ONESPEAK_OK = 1;
    private static final int ONESPEAK_NG = 2;

    // 設定変更が完了したメッセージ
    private static final String SUCCESS_UPDATE_MESSAGE = "設定を変更しました。";
    // 例外時のエラーメッセージ
    private static final String EXCEPTION = "例外：";
    // 存在しないメソッド名が実行されようとした時のエラーメッセージ
    private static final String ERR_MSG_UNKNOWN_METHOD = "unknown method.";

    private static final String CHECK_OP_NO_THROW = "checkOpNoThrow";
    private static final String OP_POST_NOTIFICATION = "OP_POST_NOTIFICATION";

    /** Atlas21 追加コード end */

    /**
     * コンストラクタ
     */
    public OneSpeakPlugin() {
    }

    /**
     * {@inheritDoc}
     */
    private static JSONArray _args;
    private static CallbackContext _callbackContext;

    @Override
    public boolean execute(String action, final JSONArray args, final CallbackContext callbackContext) throws JSONException {

        OneSpeakPlugin._args = args;
        OneSpeakPlugin._callbackContext = callbackContext;
        System.out.println("======ONE_SPEAK====");
        if (action.equals("customDataUpdateWithCommand")) {
            // ユーザ属性更新用処理
            cordova.getThreadPool().execute(new Runnable() {
                @Override
                public void run() {
                    System.out.println("======customDataUpdateWithCommand====");
                    customDataUpdate(OneSpeakPlugin._args, OneSpeakPlugin._callbackContext);
                }
            });
            return true;
            // Atlas21 追加コード start
        } else if (GET_DATA.equals(action)) {
            // updatePreferenceValueメソッドの呼び出し
            System.out.println("======customDataUpdate====");
            JSONObject return_data = getPreferenceIntValue();
            if (return_data == null) {
                callbackContext.error(NO_DATA);
                System.out.println("======customDataUpdate:NO_DATA====");
            } else {
                callbackContext.success(return_data);
                System.out.println("======customDataUpdate:" + return_data + "====");
                removePreferenceIntValue();
            }
            return true;
        } else if (ACTION_MAP_CONTROLLER.equals(action)) {

            JSONObject mapParam = args.getJSONObject(0);
            String mapAction = mapParam.getString("map");

            MyMapContent mapContent = MyMapContent.getInstance();

            if (mapAction.equals(MAP_ON)) {
                // 表示非表示フラグをtrueに変更
                mapContent.setmMapVisibilityFlg(true);
            } else if (mapAction.equals(MAP_OFF)) {
                // 表示非表示フラグをfalseに変更
                mapContent.setmMapVisibilityFlg(false);
            }
            return true;
        } else if (PUSH_ALLOW.equals(action)) {

            // updatePreferenceValueメソッドの呼び出し
            updatePreferenceValue(ONESPEAK_FLG, ONESPEAK_OK);
            // OneSpeakサーバへの更新処理
            updatePushEnabled(true);
            callbackContext.success(SUCCESS_UPDATE_MESSAGE);

            return true;

        } else if (PUSH_FORBID.equals(action)) {
            // updatePreferenceValueメソッドの呼び出し
            updatePreferenceValue(ONESPEAK_FLG, ONESPEAK_NG);
            // OneSpeakサーバへの更新処理
            updatePushEnabled(false);
            callbackContext.success(SUCCESS_UPDATE_MESSAGE);
            return true;
        } else if (PUSH_CONFIRM.equals(action)) {
            Context ctx = MainActivity.getInstance();
            String pushFlag = String.valueOf(OneSpeak.getPushEnabled(ctx));
            callbackContext.success(pushFlag);
            return true;
        }else if (FEED.equals(action)){
            cordova.getThreadPool().execute(new Runnable() {
                @Override
                public void run() {
                    JSONObject mapParam = null;
                    try {
                        mapParam = OneSpeakPlugin._args.getJSONObject(0);
                        String URL = mapParam.getString("url");
                        HttpConnectionsHelper httpHelper = new HttpConnectionsHelper();

                        // Feedの取得
                        String feedXml = httpHelper.sendGet(URL);

                        // 正常取得できたらDetailを取得
                        if (feedXml != null && !feedXml.startsWith(HttpConnectionsHelper.ERROR)) {
                            OneSpeakPlugin._callbackContext.success(feedXml);
                        } else {
                            OneSpeakPlugin._callbackContext.error(HttpConnectionsHelper.ERROR);
                        }
                    } catch (JSONException e) {
                        e.printStackTrace();
                    }
                }
            });
            return true;
        }
        // Atlas21 追加コード end

        return false;
    }

    /**
     * ユーザ属性更新
     *
     * @param args            ユーザ属性更新用データ
     * @param callbackContext 処理結果通知用コールバッククラス
     */
    private void customDataUpdate(JSONArray args,
                                  CallbackContext callbackContext) {
        Context context = this.webView.getContext();
        // URL取得
        String url = getURL(context);
        // パラメータ生成
        Map<String, String> params = createParams(args);
        // 通信処理
        String result = doPost(url, params, callbackContext);

        if (nullOrEmpty(result)) {
            // nullか空文字の場合はエラーなので終了する。
            return;
        }

        try {
            // 取得した通信結果をJSONとして解析する
            JSONObject json = new JSONObject(result);
            // 応答コードを取得
            int status = json.getInt(API_COLUMN_STATUS);
            if (status != HTTP_STATUS_CODE_OK) {
                // エラーの場合、エラーメッセージを取得する
                JSONArray errors = json.getJSONArray(API_COLUMN_ERRORS);
                if (errors.length() > 0) {
                    // エラーメッセージが存在する場合は、1つ目のエラーメッセージを使用する
                    callbackContext.error(errors.getString(0));
                } else {
                    // エラーメッセージが存在しない場合は応答コードを返却する
                    callbackContext.error(Integer.toString(status));
                }
            }
            callbackContext.success();
        } catch (JSONException e) {
            e.printStackTrace();
        }
    }

    /**
     * POST通信処理
     *
     * @param url             URL
     * @param params          パラメータ
     * @param callbackContext 処理結果通知用コールバッククラス
     * @return 正常時はAPIからのレスポンス文字列、異常時はnull
     */
    private String doPost(String url, Map<String, String> params,
                          CallbackContext callbackContext) {

        // タイムアウトの設定を行う。
        HttpParams httpParams = new BasicHttpParams();
        HttpConnectionParams.setConnectionTimeout(httpParams, CONNECT_TIMEOUT);
        HttpConnectionParams.setSoTimeout(httpParams, SOCKET_TIMEOUT);

        HttpClient httpClient = new DefaultHttpClient(httpParams);

        // POST通信ようにパラメータを設定する
        HttpPost post = new HttpPost(url);
        List<NameValuePair> valuePairList = new ArrayList<NameValuePair>();
        for (Entry<String, String> e : params.entrySet()) {
            valuePairList.add(new BasicNameValuePair(e.getKey(), e.getValue()));
        }

        try {
            // 通信を行う。
            post.setEntity(new UrlEncodedFormEntity(valuePairList,
                    CHARSET_NAME_UTF8));
            HttpResponse res = httpClient.execute(post);

            if (res.getStatusLine().getStatusCode() != HTTP_STATUS_CODE_OK) {
                // エラーの場合、Web側にエラーを通知してnullを返却する。
                callbackContext.error(Integer.toString(res.getStatusLine()
                        .getStatusCode()));
                return null;
            }
            // 受信データを文字列として返却する。
            return new String(EntityUtils.toByteArray(res.getEntity()),
                    CHARSET_NAME_UTF8);
        } catch (UnsupportedEncodingException e1) {
            // エラー処理
            e1.printStackTrace();
            callbackContext.error("エラーが発生しました。");
        } catch (ClientProtocolException e1) {
            // エラー処理
            e1.printStackTrace();
            callbackContext.error("エラーが発生しました。");
        } catch (IOException e1) {
            // エラー処理
            e1.printStackTrace();
            callbackContext.error("エラーが発生しました。");
        }
        return null;
    }

    /**
     * パラメータを生成する。
     *
     * @param args ユーザ属性更新用データ
     * @return パラメータ
     */
    private Map<String, String> createParams(JSONArray args) {
        Context context = this.webView.getContext();

        // 更新タイプと更新データを取得する。
        String type = getString(args, 0);
        String customData = getString(args, 1);

        JSONObject customJson = null;
        try {
            // 更新データをJSONとして解析する
            customJson = new JSONObject(customData);
        } catch (JSONException e) {
            customJson = new JSONObject();
        }

        // リクエストをJSONとして作成する
        JSONObject json = new JSONObject();
        putString(json, API_COLUMN_TYPE, type);
        JSONObject keyData = new JSONObject();
        putString(keyData, PREFERENCE_KEY_UUID,
                loadString(context, PREFERENCE_KEY_UUID));
        putJSON(json, API_COLUMN_KEYDATA, keyData);
        putJSON(json, API_COLUMN_CUSTOM_DATA, customJson);

        // リクエストをJSON文字列に変換する
        String request = json.toString();
        // リクエスト時刻を取得する
        String requestTiem = getRequestTime();

        Map<String, String> params = new HashMap<String, String>();
        params.put(API_COLUMN_KEY, createApiKey(requestTiem, request));
        params.put(API_COLUMN_DATE, requestTiem);
        params.put(API_COLUMN_REQUEST, request);

        return params;
    }

    /**
     * JSONArrayから文字列を取得する
     *
     * @param array JSONArray
     * @param index インデックス
     * @return
     */
    private String getString(JSONArray array, int index) {
        try {
            return array.getString(index);
        } catch (JSONException e) {
            // エラーの場合は空文字を返却する
            return "";
        }
    }

    /**
     * JSONObjectに文字列を設定する
     *
     * @param json  JSONObject
     * @param key   キー
     * @param value 値
     */
    private void putString(JSONObject json, String key, String value) {
        try {
            json.put(key, value);
        } catch (JSONException e) {
            // エラーの場合は何もしない
        }
    }

    /**
     * JSONObjectにJSONObjectを設定する
     *
     * @param json  JSONObject
     * @param key   キー
     * @param value 値
     */
    private void putJSON(JSONObject json, String key, JSONObject value) {
        try {
            json.put(key, value);
        } catch (JSONException e) {
            // エラーの場合は何もしない
        }
    }

    /**
     * APIのURLを生成する
     *
     * @param context Context
     * @return URL
     */
    private String getURL(Context context) {
        ApplicationInfo appInfo = null;
        try {
            // アプリケーションのメタ情報からOnespeakのアカウントを取得する
            appInfo = context.getPackageManager().getApplicationInfo(
                    context.getPackageName(), PackageManager.GET_META_DATA);
        } catch (NameNotFoundException e) {
        }
        return String.format("%s%s%s",
                context.getString(R.string.onespeak_plugin_base_url),
                appInfo.metaData.getString(ONESPEAK_ACCOUNT), PLUGIN_API_PATH);
    }

    /**
     * APIキーを生成する
     *
     * @param requestTime リクエスト日時
     * @param request     リクエスト
     * @return APIキー
     */
    private String createApiKey(String requestTime, String request) {
        String apiKey = this.webView.getContext().getString(
                R.string.onespeak_plugin_api_key);
        return getMD5DigestString(String.format("%s%s%s", requestTime, request,
                apiKey));
    }

    /**
     * リクエスト日時を取得する
     *
     * @return リクエスト日時
     */
    private String getRequestTime() {
        SimpleDateFormat fmt = new SimpleDateFormat("yyyy/MM/dd hh:mm:ss");
        return fmt.format(new Date());
    }

    /**
     * MD5Digest文字列を取得する。(大文字)
     *
     * @param str 対象文字列
     * @return 変換後文字列
     */
    private String getMD5DigestString(String str) {
        return digestToString(getMD5Digest(str));
    }

    /**
     * MD5Digestを取得する
     *
     * @param str 対象文字列
     * @return MD5Digest
     */
    private static byte[] getMD5Digest(String str) {
        MessageDigest md;
        try {
            md = MessageDigest.getInstance("MD5");
            return md.digest(str.getBytes("UTF-8"));
        } catch (NoSuchAlgorithmException e) {
            // 取得できない場合は何も行わない。

        } catch (UnsupportedEncodingException e) {
            // 取得できない場合は何も行わない。

        }
        // 取得できない場合は何も行わない。
        return new byte[0];
    }

    /**
     * MD5Digestのbyte配列を16進数の文字列に変換する。
     *
     * @param digest MD5Digest
     * @return 変換後文字列
     */
    private String digestToString(byte[] digest) {// ダイジェストを16進数で表示する
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < digest.length; i++) {
            int d = digest[i];
            if (d < 0) {// byte型では128〜255が負値になっているので補正
                d += 256;
            }
            if (d < 16) {// 0〜15は16進数で1けたになるので、2けたになるよう頭に0を追加
                sb.append("0");
            }
            sb.append(Integer.toString(d, 16));// ダイジェスト値の1バイトを16進数2けたで表示
        }
        return sb.toString();
    }

    /**
     * UUIDを作成済みかチェックを行う。未作成の場合は作成する。
     *
     * @param context Context
     */
    public static void checkUUID(Context context) {
        // 既にUUIDが存在しているか確認を行う。
        String uuid = loadString(context, PREFERENCE_KEY_UUID);
        System.out.println("GET UUID:" + uuid);
        if (nullOrEmpty(uuid)) {
            // UUIDが存在しなければ生成して保存する。
            storeString(context, PREFERENCE_KEY_UUID, UUID.randomUUID()
                    .toString());
        }
    }

    /**
     * CustomDataに値を追加する。
     *
     * @param context    Context
     * @param customData カスタムデータ
     */
    public static void setUpCustomData(Context context, Bundle customData) {
        String uuid = loadString(context, PREFERENCE_KEY_UUID);
        String version = getVersionName(context);
        customData.putString(PREFERENCE_KEY_UUID, uuid);
        customData.putString(VERSION, version);
    }

    /**
     * バージョン名を取得する
     *
     * @param context
     * @return
     */
    public static String getVersionName(Context context) {
        PackageManager pm = context.getPackageManager();
        String versionName = "";
        try {
            PackageInfo packageInfo = pm.getPackageInfo(context.getPackageName(), 0);
            versionName = packageInfo.versionName;
        } catch (NameNotFoundException e) {
            e.printStackTrace();
        }
        return versionName;
    }

    /**
     * SharedPreferencesに登録されている値を取得する。
     *
     * @param context Context
     * @param key     キー
     * @return 値
     */
    private static String loadString(Context context, String key) {
        SharedPreferences sp = context.getSharedPreferences(PREFERENCE_NAME,
                Context.MODE_PRIVATE);
        return sp.getString(key, "");
    }

    /**
     * 文字列が null か空文字か判定を行う。
     *
     * @param str 文字列
     * @return true:nullか空文字/false:以外
     */
    private static boolean nullOrEmpty(String str) {
        return str == null || str.equals("");
    }

    /**
     * SharedPreferencesに値を保存する。
     *
     * @param context Context
     * @param key     キー
     * @param value
     */
    private static void storeString(Context context, String key, String value) {
        SharedPreferences sp = context.getSharedPreferences(PREFERENCE_NAME,
                Context.MODE_PRIVATE);
        SharedPreferences.Editor editor = sp.edit();
        editor.putString(key, value);
        editor.commit();
    }

    // Atlas21 追加コード start

    /**
     * SharedPreferencesに保存されているプッシュ通知のCustomID（アナリティクス用event_id）を取得する。
     *
     * @return　JSONObject return json
     */
    private JSONObject getPreferenceIntValue() {
        Context ctx = MainActivity.getInstance();
        // 端末から値を取得します。
        SharedPreferences preferences = ctx.getSharedPreferences(ONESPEAK_CUSTOMDATA, Context.MODE_PRIVATE);
        // 項目が登録されていない場合は、デフォルト値としてONESPEAK_NOT_CHECKEDを返却します。
        String tmp = preferences.getString(ONESPEAK_CUSTOMID, null);
        // データがなかった場合の処理
        if (tmp == null) {
            return null;
        }
        try {
            JSONObject json = new JSONObject();
            json.putOpt(ONESPEAK_CUSTOMID, tmp);
            return json;
        } catch (JSONException e) {
            e.printStackTrace();
            return null;
        }
    }

    /**
     * SharedPreferencesに保存されているプッシュ通知のCustomID（アナリティクス用event_id）を削除する。
     *
     * @author m.iwamori
     */
    private void removePreferenceIntValue() {
        Context ctx = MainActivity.getInstance();
        // 端末から値を削除します。
        SharedPreferences preferences = ctx.getSharedPreferences(ONESPEAK_CUSTOMDATA, Context.MODE_PRIVATE);
        SharedPreferences.Editor editor = preferences.edit();
        editor.remove(ONESPEAK_CUSTOMID);
        editor.commit();
    }

    // SharedPreferencesの更新処理
    private void updatePreferenceValue(String key, int value) {
        Context ctx = MainActivity.getInstance();
        // 端末に値を保存します。
        SharedPreferences preferences = ctx.getSharedPreferences(
                ONESPEAK_PREFERENCE_FILE, Context.MODE_PRIVATE);
        SharedPreferences.Editor editor = preferences.edit();
        editor.putInt(key, value);
        editor.commit();
    }

    // OneSpeakサーバへ通知設定の更新処理
    private void updatePushEnabled(boolean flag) {
        Context ctx = MainActivity.getInstance();
        // 端末に値を保存します。
        OneSpeak.setPushEnabled(ctx, flag);
    }
}
