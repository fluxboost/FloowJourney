//
//  ViewJourneyViewController.swift
//  FloowJourney
//
//  Created by Harry Liddell on 21/02/2019.
//  Copyright © 2019 harryliddell. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

/**
ViewJourneyViewController displays the users previously saved journey. Dependency injection has been used rather than MVVM to keep the view controller concise. This view controller is static and requires the same data everytime and thus is a perfect candidate for dependency injection.
*/
class ViewJourneyViewController: UIViewController {

	@IBOutlet weak var labelStartDate: UILabel!
	@IBOutlet weak var labelEndDate: UILabel!
	@IBOutlet weak var mapView: MKMapView!
	
	var journey: Journey!
	var index: Int!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		setupDisplay()
    }
	
	/**
	Sets up the display and map with the journey data.
	*/
	func setupDisplay() {
		title = "Journey \(index + 1)"
		labelStartDate.text = "Start: \(FormatHelper.stringFromDate(journey.start))"
		labelEndDate.text = "End: \(FormatHelper.stringFromDate(journey.end))"
		
		loadMap()
	}
	
	
	/**
	Load the map with the user's journey route.
	*/
	private func loadMap() {
		let locations = journey.locations
		
		guard !locations.isEmpty, let region = mapRegion() else {
				let alert = UIAlertController(title: "Error",
											  message: "Sorry, this run has no locations saved",
											  preferredStyle: .alert)
				alert.addAction(UIAlertAction(title: "OK", style: .cancel))
				present(alert, animated: true)
				return
		}
		
		mapView.setRegion(region, animated: true)
		mapView.addOverlay(polyLine())
	}
	
	/**
	Calculates the map region that incapsulates all the journey points.
	
	- Returns: An MKCoordinateRegion object.
	*/
	private func mapRegion() -> MKCoordinateRegion? {
		let locations = journey.locations
		
		guard !journey.locations.isEmpty else { return nil }
		
		let latitudes = locations.map { location -> Double in
			let location = location
			return location.latitude
		}
		
		let longitudes = locations.map { location -> Double in
			let location = location
			return location.longitude
		}
		
		let maxLat = latitudes.max()!
		let minLat = latitudes.min()!
		let maxLong = longitudes.max()!
		let minLong = longitudes.min()!
		
		let center = CLLocationCoordinate2D(latitude: (minLat + maxLat) / 2,
											longitude: (minLong + maxLong) / 2)
		let span = MKCoordinateSpan(latitudeDelta: (maxLat - minLat) * 1.3,
									longitudeDelta: (maxLong - minLong) * 1.3)
		return MKCoordinateRegion(center: center, span: span)
	}
	
	/**
	Creates a polyline that follows all the coordinates of the 'locations' in the Journey object.
	
	- Returns: A polyline object.
	*/
	private func polyLine() -> MKPolyline {
		let locations = journey.locations
		
		guard !locations.isEmpty else { return MKPolyline() }
		
		let coords: [CLLocationCoordinate2D] = locations.map { location in
			let location = location
			return CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
		}
		return MKPolyline(coordinates: coords, count: coords.count)
	}
}

extension ViewJourneyViewController: MKMapViewDelegate {
	
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
		renderer.lineWidth = 3
		return renderer
	}
}
