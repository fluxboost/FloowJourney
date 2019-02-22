//
//  JourneyViewModel.swift
//  FloowJourney
//
//  Created by Harry Liddell on 21/02/2019.
//  Copyright © 2019 harryliddell. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation

protocol JourneyViewModelDelegate: class {
	func updateView(updatedViewModel: JourneyViewModel)
}

class JourneyViewModel {

	private var start: Date?
	private var end: Date?
	private var seconds = 0
	private var timer: Timer?
	private var distance = Measurement(value: 0, unit: UnitLength.meters)
	private var locationList: [CLLocation] = []
	
	weak var delegate: JourneyViewModelDelegate?
	
	init(){}
	
	func startJourney() {
		seconds = 0
		locationList.removeAll()
		timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in self.eachSecond() }
		start = Date()
	}
	
	func stopJourney() {
		timer?.invalidate()
		end = Date()
		saveJourney()
	}
	
	private func saveJourney() {
		
		let journey = Journey(distance: distance.value, duration: seconds, start: NSDate.distantFuture, end: NSDate.distantPast, locations: nil)
		var locations: [Location] = []
		
		for item in locationList {
			let location = Location(latitude: item.coordinate.latitude, longitude: item.coordinate.longitude, timestamp: item.timestamp)
			locations.append(location)
		}
		
		journey.locations = locations
		
		JourneyManager.shared.saveJourney(journey: journey)
	}
	
	func addLocationToList(location: CLLocation) {
		locationList.append(location)
	}
	
	func eachSecond() {
		seconds += 1
		updateView()
	}
	
	func updateView() {
		
	}
	
	func getLocationList() -> [CLLocation] {
		return locationList
	}
	
	func getLastLocationFromList() -> CLLocation? {
		if !getLocationList().isEmpty {
			return getLocationList().last
		} else {
			return nil
		}
	}
}
