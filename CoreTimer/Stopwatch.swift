//
//  Stopwatch.swift
//  Timer
//
//  Created by Damiaan Dufaux on 9/05/15.
//  Copyright (c) 2015 Damiaan Dufaux. All rights reserved.
//

import Foundation

public class Stopwatch: NSObject {

	var startTime: NSDate?
	var pauseTime: NSDate?
	public var isTicking: Bool { return startTime != nil && pauseTime == nil }
	
	var calculateDuration: () -> NSTimeInterval = durationZero
	
	override public init() {
		super.init()
	}
	
	required public init(coder aDecoder: NSCoder) {
		super.init()
		startTime = aDecoder.decodeObjectForKey("Start time") as? NSDate
		pauseTime = aDecoder.decodeObjectForKey("Pause time") as? NSDate
		if startTime != nil && pauseTime == nil {
			calculateDuration = durationWhenTicking
		} else if startTime == nil {
			calculateDuration = Stopwatch.durationZero
		} else {
			calculateDuration = durationWhenPaused
		}
	}
	
	/// The current value of the stopwatch
	public var duration: NSTimeInterval {
		return calculateDuration()
	}
	
	public func getStart() -> NSDate? {
		return startTime
	}
	
	/// Start counting
	public func start() {
		if let pauseTime = pauseTime {
			startTime = startTime!.dateByAddingTimeInterval(NSDate().timeIntervalSinceDate(pauseTime))
			self.pauseTime = nil
		} else {
			startTime = NSDate()
		}
		calculateDuration = durationWhenTicking
	}
	
	/// Pauses the stopwatch. When paused the duration will be hold until start() is called again
	public func pause() {
		pauseTime = NSDate()
		calculateDuration = durationWhenPaused
	}
	
	public func toggleState() {
		if startTime == nil || pauseTime != nil {
			start()
		} else {
			pause()
		}
	}
	
	/// Resets the duration of the stopwatch
	public func reset() {
		pauseTime = nil
		startTime = nil
		calculateDuration = Stopwatch.durationZero
	}

	
	// MARK: Duration helpers
	static let durationZero = { NSTimeInterval(0) }
	
	func durationWhenTicking() -> NSTimeInterval {
		return NSDate().timeIntervalSinceDate(startTime!)
	}

	func durationWhenPaused() -> NSTimeInterval {
		return pauseTime!.timeIntervalSinceDate(startTime!)
	}
}

extension Stopwatch: Syncable {
	public var referenceDate: NSDate {
		return startTime ?? NSDate()
	}
}

extension Stopwatch: NSCoding {
	public func encodeWithCoder(aCoder: NSCoder) {
		aCoder.encodeObject(startTime, forKey: "Start time")
		aCoder.encodeObject(pauseTime, forKey: "Pause time")
	}
	
}