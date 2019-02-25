//
//  ViewController.swift
//  FloowJourney
//
//  Created by Harry Liddell on 20/02/2019.
//  Copyright © 2019 harryliddell. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class JourneyViewController: UIViewController {

	@IBOutlet weak var viewInterface: UIView!
	@IBOutlet weak var mapView: MKMapView!
	@IBOutlet weak var labelJourneyTime: UILabel!
	@IBOutlet weak var switchTracking: UISwitch!
	@IBOutlet weak var buttonViewJourneys: UIButton!
	
	private var userLocationManager = UserLocationManager.shared
	private var viewModel = JourneyViewModel()

	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupLocationManager()
		viewModel.delegate = self
	}
	
	/**
	Sets the location manager delegate and begins tracking the user.
	*/
	private func setupLocationManager() {
		userLocationManager.locationManager.delegate = self
		mapView.setUserTrackingMode(.follow, animated: true)
		applyUserRegionToMap()
	}

	/**
	UISwitch action to start and stop tracking the user's journey.
	*/
	@IBAction func switchTrackingPressed(_ sender: UISwitch) {
		(sender.isOn) ? startJourney() : stopJourney()
	}
	
	/**
	Clear the last journey from the map if one existed and begins tracking the user's next journey.
	Also hides the 'view journeys' button.
	*/
	private func startJourney() {
		mapView.removeOverlays(mapView.overlays)
		buttonViewJourneys.isHidden = true
		
		userLocationManager.startTracking()
		mapView.setUserTrackingMode(.follow, animated: true)
		
		viewModel.startJourney()
	}
	
	/**
	Stop tracking the user's journey and show the 'view journeys' button
	*/
	private func stopJourney() {
		buttonViewJourneys.isHidden = false
		
		userLocationManager.stopTracking()
		
		viewModel.stopJourney()
	}
	
	/**
	Sets the map's centre and zoom to the user's location
	*/
	private func applyUserRegionToMap() {
		let userLocation = mapView.userLocation
		let region = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: 100, longitudinalMeters: 100)
		mapView.setRegion(region, animated: false)
	}
}

// Journey View Model Delegate

extension JourneyViewController: JourneyViewModelDelegate {
	
	func didUpdateView(updatedViewModel: JourneyViewModel) {
		viewModel = updatedViewModel
		labelJourneyTime.text = viewModel.getDuration()
	}
}

// CLLocationManager Delegate

extension JourneyViewController: CLLocationManagerDelegate {
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		
		for newLocation in locations {
			
			// If statement forces the first location to be recorded.
			if locations.count > 1 {
				// Guard helps prevent messy journey lines
				let howRecent = newLocation.timestamp.timeIntervalSinceNow
				guard newLocation.horizontalAccuracy < 30 && abs(howRecent) < 10 else { continue }
			}
			
			// Get the two most recent locations, draw a polyline between them, and recentre the map.
			if let lastLocation = viewModel.getLastLocationFromList() {
				let coordinates = [lastLocation.coordinate, newLocation.coordinate]
				mapView.addOverlay(MKPolyline(coordinates: coordinates, count: 2))
				mapView.setUserTrackingMode(.follow, animated: true)
			}
			
			print("New location added: \(newLocation)")
			// Store the new location in the view model
			viewModel.addLocationToList(location: newLocation)
		}
	}
}

// MKMapView Delegate

extension JourneyViewController: MKMapViewDelegate {
	
	/**
	When a map overlay is added, this function is called.
	
	- Returns: A MKOverlayRenderer object that draws a black polyline.
	*/
	func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
		guard let polyline = overlay as? MKPolyline else {
			return MKOverlayRenderer(overlay: overlay)
		}
		let renderer = MKPolylineRenderer(polyline: polyline)
		renderer.strokeColor = .black
		renderer.lineWidth = 2
		return renderer
	}
	
	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
		if annotation.isEqual(mapView.userLocation) {
			let userLocationAnnotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "userLocation")
			userLocationAnnotationView.image = UIImage(named: "car")
			return userLocationAnnotationView
		}
		
		return nil
	}
}

