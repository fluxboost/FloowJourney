//
//  JourneysListViewModel.swift
//  FloowJourney
//
//  Created by Harry Liddell on 25/02/2019.
//  Copyright © 2019 harryliddell. All rights reserved.
//

import UIKit

class JourneysListViewModel {

	var journeys: [Journey] = []
	
	init() {
		// Upon creation of the view model, fetch the current journeys.
		journeys = JourneyManager.shared.getJourneys()
	}
	
	/**
	Gets the journey array count
	
	- Returns: An Int with the count of the journeys array.
	*/
	func numberOfJourneysInSection(section: Int) -> Int {
		return journeys.count
	}
	
	/**
	Gets the Journey object for the provided index path.
	
	- Returns: A Journey object
	*/
	func journeyForRowAtIndexPath(indexPath: IndexPath) -> Journey {
		return journeys[indexPath.row]
	}
}
