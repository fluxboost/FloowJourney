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
	func didUpdateView(updatedViewModel: JourneyViewModel)
}

class JourneyViewModel {

	private var start: Date?
	private var end: Date?
	private var seconds = 0
	private var timer: Timer?
	private var locationList: [CLLocation] = []
	
	private var journeyManager = JourneyManager.shared
	weak var delegate: JourneyViewModelDelegate?
	
	init(){}
	
	/**
	Resets all the journey variables and starts updating for a new journey.
	*/
	func startJourney() {
		seconds = 0
		locationList.removeAll()
		timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in self.eachSecond() }
		start = Date()
	}
	
	/**
	Stops journey tracking variables and saves the journey to the JourneyManager.
	*/
	func stopJourney() {
		timer?.invalidate()
		end = Date()
		saveJourney()
	}
	
	/**
	Format the journey data and save to JourneyManager.
	*/
	private func saveJourney() {
		
		let journey = Journey(duration: seconds, start: start!, end: end!, locations: [])
		var locations: [Location] = []
		
		for item in locationList {
			let location = Location(latitude: item.coordinate.latitude, longitude: item.coordinate.longitude, timestamp: item.timestamp)
			locations.append(location)
		}
		
		journey.locations = locations
		
		journeyManager.saveJourney(journey: journey)
	}
	
	func addLocationToList(location: CLLocation) {
		locationList.append(location)
	}
	
	/**
	Called every second in order to update the view.
	*/
	func eachSecond() {
		seconds += 1
		updateView()
	}
	
	/**
	Sends the updated view model to the view.
	*/
	func updateView() {
		delegate?.didUpdateView(updatedViewModel: self)
	}
	
	/**
	Calculates the duration of the current journey.
	
	- Returns: A string containing the total duration of the current journey in HH:mm:ss.
	*/
	func getDuration() -> String {
		let timeintervalSinceStart = Date().timeIntervalSince(start!)
		return FormatHelper.stringFromTimeInterval(timeInterval: timeintervalSinceStart)
	}
	
	/**
	Gets the array of locations.
	
	- Returns: An array containing all the locations recorded so far on the current journey.
	*/
	private func getLocationList() -> [CLLocation] {
		return locationList
	}
	
	/**
	Gets the last CLLocation from the array of locations
	
	- Returns: A CLLocation object
	*/
	func getLastLocationFromList() -> CLLocation? {
		if !getLocationList().isEmpty {
			return getLocationList().last
		} else {
			return nil
		}
	}
}
