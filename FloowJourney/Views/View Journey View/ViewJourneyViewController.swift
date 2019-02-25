//
//  ViewJourneyViewController.swift
//  FloowJourney
//
//  Created by Harry Liddell on 21/02/2019.
//  Copyright © 2019 harryliddell. All rights reserved.
//

import UIKit

class ViewJourneyViewController: UIViewController {

	@IBOutlet weak var labelStartDate: UILabel!
	@IBOutlet weak var labelEndDate: UILabel!
	
	var journey: Journey!
	var index: Int!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		setupDisplay()
    }
	
	func setupDisplay() {
		title = "Journey \(index + 1)"
		labelStartDate.text = "Start: \(FormatHelper.stringFromDate(journey.start))"
		labelEndDate.text = "End: \(FormatHelper.stringFromDate(journey.end))"
	}
}
