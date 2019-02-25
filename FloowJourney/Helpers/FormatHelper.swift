//
//  FormatHelper.swift
//  FloowJourney
//
//  Created by Harry Liddell on 25/02/2019.
//  Copyright © 2019 harryliddell. All rights reserved.
//

import UIKit

struct FormatHelper {
	
	/**
	Takes a Date and formats it into a human readable string.
	
	- Returns: A string containing the inputted date.
	*/
	static func stringFromDate(_ date: Date?) -> String {
		guard let date = date as Date? else { return "" }
		let formatter = DateFormatter()
		formatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
		return formatter.string(from: date)
	}
	
	/**
	Takes a TimeInterval and formats it into a human readable string of hours, minutes, and seconds.
	
	- Returns: A string of HH:mm:ss.
	*/
	static func stringFromTimeInterval(timeInterval: TimeInterval) -> String {
		
		let time = Int(timeInterval)
		
		let seconds = time % 60
		let minutes = (time / 60) % 60
		let hours = (time / 3600)
		
		return String(format: "%0.2d:%0.2d:%0.2d",hours,minutes,seconds)
	}
}
