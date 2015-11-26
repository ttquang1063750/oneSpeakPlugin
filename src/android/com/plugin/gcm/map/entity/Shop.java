package com.plugin.gcm.map.entity;

/**
 * 店舗データの geter seter クラス
 * @author sugi
 *
 */
public class Shop {

	private String  id;
	private String  shopname;
	private String  category;
	private String  shopinfo;
	private double latitude;
	private double longitude;
	private int     openinghours;
	private int     parking;
	private int     drivethrough;
	private int     tableseats;
	private int     foodpack;
	private int     eMoney;

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
	public String getCategory() {
		return category;
	}
	public void setCategory(String category) {
		this.category = category;
	}
	public String getShopinfo() {
		return shopinfo;
	}
	public void setShopinfo(String shopinfo) {
		this.shopinfo = shopinfo;
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
	public int getOpeninghours() {
		return openinghours;
	}
	public void setOpeninghours(int openinghours) {
		this.openinghours = openinghours;
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


}
