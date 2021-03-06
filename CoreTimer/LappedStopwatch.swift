//
//  LappedStopwatch.swift
//  Timer
//
//  Created by Damiaan Dufaux on 10/05/15.
//  Copyright (c) 2015 Damiaan Dufaux. All rights reserved.
//

import Foundation

/// A stopwatch with the ablility to save lap times
public class LappedStopwatch: Stopwatch {
	
	/// The different lap times
	public dynamic var laps = [NSTimeInterval]()
	var lastLapStart: NSDate?
	
	/// Start a new lap
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
	
	public override func reset() {
		laps.removeAll(keepCapacity: true)
		super.reset()
	}
	
	override public init() {
		super.init()
	}

	public required init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		laps = aDecoder.decodeObjectForKey("Laps") as? [NSTimeInterval] ?? [NSTimeInterval]()
	}
	
	public override func encodeWithCoder(aCoder: NSCoder) {
		super.encodeWithCoder(aCoder)
		aCoder.encodeObject(laps, forKey: "Laps")
	}
}
