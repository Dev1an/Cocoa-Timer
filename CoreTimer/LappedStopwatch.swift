//
//  LappedStopwatch.swift
//  Timer
//
//  Created by Damiaan Dufaux on 10/05/15.
//  Copyright (c) 2015 Damiaan Dufaux. All rights reserved.
//

import Cocoa

public class LappedStopwatch: Stopwatch {
	
	public dynamic var laps = [NSTimeInterval]()
	var lastLapStart: NSDate?
	
	public func newLap() {
		if isTicking {
			if let reference = lastLapStart {
				laps.append(NSDate().timeIntervalSinceDate(reference))
			} else {
				laps.append(duration)
			}
		}
		
		lastLapStart = NSDate()
	}
}
