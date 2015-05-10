//
//  TimedIntervalFormatter.swift
//  Timer
//
//  Created by Damiaan Dufaux on 10/05/15.
//  Copyright (c) 2015 Damiaan Dufaux. All rights reserved.
//

import Foundation

public class TimedIntervalFormatter: NSDateComponentsFormatter {
	public var allowTenthSeconds = true
	
	override public func stringFromTimeInterval(time: NSTimeInterval) -> String? {
		if allowTenthSeconds {
			let fPart = Int((time%1)*100 + 0.5)
			return super.stringFromTimeInterval(time)! + (NSString(format: ".%.2d", fPart) as String)
		} else {
			return super.stringFromTimeInterval(time)
		}
	
	}
}