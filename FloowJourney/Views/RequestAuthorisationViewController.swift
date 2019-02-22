//
//  RequestAuthorisationViewController.swift
//  FloowJourney
//
//  Created by Harry Liddell on 21/02/2019.
//  Copyright © 2019 harryliddell. All rights reserved.
//

import UIKit
import CoreLocation

class RequestAuthorisationViewController: UIViewController, CLLocationManagerDelegate {

	@IBOutlet weak var buttonRequestAuth: UIButton!
	
	var locationManager = LocationManager.shared
	
	override func viewDidLoad() {
        super.viewDidLoad()
		locationManager.delegate = self
    }
	
	override func viewDidAppear(_ animated: Bool) {
		if LocationManager.checkIfAuthorised() {
			self.performSegue(withIdentifier: "goToJourneyView", sender: self)
		} else {
			buttonRequestAuth.isHidden = false
		}
	}
	
	@IBAction func buttonRequestAuthPressed(_ sender: UIButton) {
		locationManager.requestAlwaysAuthorization()
	}
	
	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		if status == .denied || status == .notDetermined {
			// User selected Not authorized
			
		} else {
			performSegue(withIdentifier: "goToJourneyView", sender: self)
		}
	}
}
