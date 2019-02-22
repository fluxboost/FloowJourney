//
//  Journey.swift
//  FloowJourney
//
//  Created by Harry Liddell on 20/02/2019.
//  Copyright © 2019 harryliddell. All rights reserved.
//

import UIKit

class Journey: NSObject {
	
	var distance: Double
	var duration: Int
	var start: Date
	var end: Date
	var locations: [Location]?
	
	init(distance: Double, duration: Int, start: Date, end: Date, locations: [Location]?) {
		self.distance = distance
		self.duration = duration
		self.start = start
		self.end = end
		
		if locations != nil {
			self.locations = locations
		}
	}
}
