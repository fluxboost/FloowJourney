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

class JourneyViewController: UIViewController, JourneyViewModelDelegate {

	@IBOutlet weak var viewInterface: UIView!
	@IBOutlet weak var mapView: MKMapView!
	@IBOutlet weak var labelJourneyTime: UILabel!
	@IBOutlet weak var switchTracking: UISwitch!
	@IBOutlet weak var buttonViewJourneys: UIButton!
	
	private var locationManager = LocationManager.shared
	private var viewModel = JourneyViewModel()

	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupLocationManager()
		viewModel.delegate = self
	}
	
	private func setupLocationManager() {
		locationManager.delegate = self
		locationManager.activityType = .automotiveNavigation
		locationManager.distanceFilter = kCLDistanceFilterNone
		locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
		
		mapView.setUserTrackingMode(.follow, animated: true)
		applyUserRegionToMap()
	}

	@IBAction func switchTrackingPressed(_ sender: UISwitch) {
		if sender.isOn {
			startJourney()
		} else {
			stopJourney()
		}
	}
	
	// View Model Delegates
	func updateView(updatedViewModel: JourneyViewModel) {
		viewModel = updatedViewModel
	}
	
	private func startJourney() {
		mapView.removeOverlays(mapView.overlays)
		buttonViewJourneys.isHidden = true
		
		locationManager.startUpdatingLocation()
		locationManager.allowsBackgroundLocationUpdates = true
		locationManager.pausesLocationUpdatesAutomatically = false
		
		//applyUserRegionToMap()
		
		viewModel.startJourney()
	}
	
	private func stopJourney() {
		buttonViewJourneys.isHidden = false
		
		locationManager.stopUpdatingLocation()
		locationManager.allowsBackgroundLocationUpdates = false
		locationManager.pausesLocationUpdatesAutomatically = true
		
		viewModel.stopJourney()
	}
	
	private func applyUserRegionToMap() {
		let userLocation = mapView.userLocation
		let region = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: 100, longitudinalMeters: 100)
		mapView.setRegion(region, animated: false)
	}
}

// CLLocationManager Delegate

extension JourneyViewController: CLLocationManagerDelegate {
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		for newLocation in locations {
			//let howRecent = newLocation.timestamp.timeIntervalSinceNow
			//guard newLocation.horizontalAccuracy < 30 && abs(howRecent) < 10 else { continue }
			
			if let lastLocation = viewModel.getLastLocationFromList() {
				let coordinates = [lastLocation.coordinate, newLocation.coordinate]
				mapView.addOverlay(MKPolyline(coordinates: coordinates, count: 2))
				
				applyUserRegionToMap()
			}
			
			print("New location added: \(newLocation)")
			viewModel.addLocationToList(location: newLocation)
		}
	}
}

// MKMapView Delegate

extension JourneyViewController: MKMapViewDelegate {
	
	func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
		guard let polyline = overlay as? MKPolyline else {
			return MKOverlayRenderer(overlay: overlay)
		}
		let renderer = MKPolylineRenderer(polyline: polyline)
		renderer.strokeColor = .black
		renderer.lineWidth = 3
		return renderer
	}
}

