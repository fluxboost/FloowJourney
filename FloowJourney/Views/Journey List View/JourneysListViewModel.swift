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
		// Upon creation of the View Model fetch the current journeys
		journeys = JourneyManager.shared.getJourneys()
	}
	
	func numberOfJourneysInSection(section: Int) -> Int {
		return journeys.count
	}
	
	func journeyForRowAtIndexPath(indexPath: IndexPath) -> Journey {
		return journeys[indexPath.row]
	}
}
