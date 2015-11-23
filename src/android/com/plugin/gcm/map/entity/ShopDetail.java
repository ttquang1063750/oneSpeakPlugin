package jp.co.matsuyafoods.officialapp.dis.map.entity;

/**
 * 詳細データの geter seterクラス
 * @author sugi
 *
 */
public class ShopDetail {

	private String id;
	private String shopname;
	private String openingHours;
	private String address;
	private String tel;
	private double latitude;
	private double longitude;
	private String navitimeId;
	private int    open24h;
	private int    parking;
	private int    drivethrough;
	private int    tableseats;
	private int    foodpack;
	private int    eMoney;

	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getShopname() {
		return shopname;
	}
	public void setShopname(String shopname) {
		this.shopname = shopname;
	}
	public String getOpeningHours() {
		return openingHours;
	}
	public void setOpeningHours(String openingHours) {
		this.openingHours = openingHours;
	}
	public String getAddress() {
		return address;
	}
	public void setAddress(String address) {
		this.address = address;
	}
	public String getTel() {
		return tel;
	}
	public void setTel(String tel) {
		this.tel = tel;
	}
	public double getLatitude() {
		return latitude;
	}
	public void setLatitude(double latitude) {
		this.latitude = latitude;
	}
	public double getLongitude() {
		return longitude;
	}
	public void setLongitude(double longitude) {
		this.longitude = longitude;
	}
	public int getParking() {
		return parking;
	}
	public void setParking(int parking) {
		this.parking = parking;
	}
	public int getDrivethrough() {
		return drivethrough;
	}
	public void setDrivethrough(int drivethrough) {
		this.drivethrough = drivethrough;
	}
	public int getTableseats() {
		return tableseats;
	}
	public void setTableseats(int tableseats) {
		this.tableseats = tableseats;
	}
	public int getFoodpack() {
		return foodpack;
	}
	public void setFoodpack(int foodpack) {
		this.foodpack = foodpack;
	}
	public int geteMoney() {
		return eMoney;
	}
	public void seteMoney(int eMoney) {
		this.eMoney = eMoney;
	}
	public int getOpen24h() {
		return open24h;
	}
	public void setOpen24h(int h24) {
		this.open24h = h24;
	}
	public String getNavitimeId() {
		return navitimeId;
	}
	public void setNavitimeId(String navitimeId) {
		this.navitimeId = navitimeId;
	}


}
