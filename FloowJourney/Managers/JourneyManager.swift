//
//  JourneyManager.swift
//  FloowJourney
//
//  Created by Harry Liddell on 20/02/2019.
//  Copyright © 2019 harryliddell. All rights reserved.
//

import UIKit

class JourneyManager {
	
	static let shared = JourneyManager()
	
	private init(){}
	
	var journeys = [Journey]()
	
	func saveJourney(journey: Journey) {
		journeys.append(journey)
	}
}
