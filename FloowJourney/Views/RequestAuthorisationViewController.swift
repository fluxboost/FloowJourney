//
//  RequestAuthorisationViewController.swift
//  FloowJourney
//
//  Created by Harry Liddell on 21/02/2019.
//  Copyright © 2019 harryliddell. All rights reserved.
//

import UIKit
import CoreLocation

class RequestAuthorisationViewController: UIViewController {

	@IBOutlet weak var buttonRequestAuth: UIButton!
	
	var userLocationManager = UserLocationManager.shared
	
	override func viewDidLoad() {
        super.viewDidLoad()
		userLocationManager.locationManager.delegate = self
    }
	
	override func viewDidAppear(_ animated: Bool) {
		// Check if the user has enabled location services, if they have move to journey view. If not, show the request authorisation button.
		if userLocationManager.checkIfAuthorised() {
			self.performSegue(withIdentifier: "goToJourneyView", sender: self)
		} else {
			buttonRequestAuth.isHidden = false
		}
	}
	
	/**
	UIButton action that checks if the user has made a decision on location services.
	If they haven't made a decision yet, it requests authorisation.
	If they have denied access, it asks them to enable location services in the Settings app.
	*/
	@IBAction func buttonRequestAuthPressed(_ sender: UIButton) {
		(!userLocationManager.checkIfUserHasDecidedAuthorisation()) ? userLocationManager.requestAlwaysAuthorization() : showOpenSettingsAppAlert()
	}
	
	/**
	Shows an alert to the user asking them if they want to go to the Settings app so they can enable location
	services.
	*/
	func showOpenSettingsAppAlert() {
		let alert = UIAlertController(title: "Location Services", message: "The app requires location services to be enabled to work correctly. Please go to Settings and allow access.", preferredStyle: .alert)
		
		alert.addAction(UIAlertAction(title: "Go to Settings", style: .default, handler: { (UIAlertAction) in
			guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {	return }
			if UIApplication.shared.canOpenURL(settingsUrl) {
				UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
					print("Settings opened: \(success)")
				})
			}
		}))
		
		alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
		
		show(alert, sender: self)
	}
}

extension RequestAuthorisationViewController: CLLocationManagerDelegate {
	
	/**
	Checks if the user has enabled location services, and if they have, it pushes them to the journey view.
	*/
	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		if status != .denied && status != .notDetermined {
			performSegue(withIdentifier: "goToJourneyView", sender: self)
		}
	}
}
