//
//  FormatHelper.swift
//  FloowJourney
//
//  Created by Harry Liddell on 25/02/2019.
//  Copyright © 2019 harryliddell. All rights reserved.
//

import UIKit

struct FormatHelper {
	static func stringFromDate(_ date: Date?) -> String {
		guard let date = date as Date? else { return "" }
		let formatter = DateFormatter()
		formatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
		return formatter.string(from: date)
	}
	
	static func stringFromTimeInterval(timeInterval: TimeInterval) -> String {
		
		let time = Int(timeInterval)
		
		let seconds = time % 60
		let minutes = (time / 60) % 60
		let hours = (time / 3600)
		
		return String(format: "%0.2d:%0.2d:%0.2d",hours,minutes,seconds)
	}
}
