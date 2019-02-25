//
//  JourneyManager.swift
//  FloowJourney
//
//  Created by Harry Liddell on 20/02/2019.
//  Copyright © 2019 harryliddell. All rights reserved.
//

import UIKit

/**
JourneyManager is a singleton used to store all journeys the user creates.
*/
class JourneyManager {
	
	static let shared = JourneyManager()
	
	// Private init prevents reinitialisation of singleton.
	private init(){}
	
	var journeys = [Journey]()
	
	/**
	Fetches all the current journeys from this session.
	*/
	func getJourneys() -> [Journey] {
		return journeys
	}
	
	/**
	Takes a Journey object and saves it to the JourneyManager singleton.
	*/
	func saveJourney(journey: Journey) {
		journeys.append(journey)
	}
}
