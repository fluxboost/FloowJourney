//
//  LocationManager.swift
//  FloowJourney
//
//  Created by Harry Liddell on 21/02/2019.
//  Copyright © 2019 harryliddell. All rights reserved.
//

import CoreLocation

class LocationManager {
	
	static let shared = CLLocationManager()
	
	// Private init prevents reinitialisation of singleton
	private init(){
		
	}
	
	static func checkIfAuthorised() -> Bool {
		if CLLocationManager.locationServicesEnabled() {
			switch CLLocationManager.authorizationStatus() {
			case .notDetermined, .restricted, .denied:
				print("No access to location services")
				return false
			case .authorizedAlways, .authorizedWhenInUse:
				print("Access to location services")
				return true
			}
		} else {
			print("Location services are not enabled")
			return false
		}
	}
}
