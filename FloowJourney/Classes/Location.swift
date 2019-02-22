//
//  Location.swift
//  FloowJourney
//
//  Created by Harry Liddell on 20/02/2019.
//  Copyright © 2019 harryliddell. All rights reserved.
//

import UIKit

class Location: NSObject {

	var latitude: Double
	var longitude: Double
	var timestamp: Date
	
	init(latitude: Double, longitude: Double, timestamp: Date) {
		self.latitude = latitude
		self.longitude = longitude
		self.timestamp = timestamp
	}
}
