package com.plugin.gcm.map.entity;

/**
 * ピン取得の為、DBリクエストするための要素クラス
 * @author sugi
 *
 */
public class RequestRange {

	private double westLat;
	private double eastLat;
	private double southLng;
	private double northLng;
	private double cLatitude;
	private double cLongitude;



	public double getWestLat() {
		return westLat;
	}
	public void setWestLat(double westLat) {
		this.westLat = westLat;
	}
	public double getEastLat() {
		return eastLat;
	}
	public void setEastLat(double eastLat) {
		this.eastLat = eastLat;
	}
	public double getSouthLng() {
		return southLng;
	}
	public void setSouthLng(double southLng) {
		this.southLng = southLng;
	}
	public double getNorthLng() {
		return northLng;
	}
	public void setNorthLng(double northLng) {
		this.northLng = northLng;
	}
	public double getcLatitude() {
		return cLatitude;
	}
	public void setcLatitude(double cLatitude) {
		this.cLatitude = cLatitude;
	}
	public double getcLongitude() {
		return cLongitude;
	}
	public void setcLongitude(double cLongitude) {
		this.cLongitude = cLongitude;
	}



}
