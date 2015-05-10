//
//  Stopwatch.swift
//  Timer
//
//  Created by Damiaan Dufaux on 9/05/15.
//  Copyright (c) 2015 Damiaan Dufaux. All rights reserved.
//

import Cocoa

public class Stopwatch: NSObject {

	var startTime: NSDate?
	var pauseTime: NSDate?
	public var isTicking: Bool { return startTime != nil && pauseTime == nil }
	
	var calculateDuration: () -> NSTimeInterval = durationZero
	
	/// The current value of the stopwatch
	public var duration: NSTimeInterval {
		return calculateDuration()
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
	public var syncOffset: NSTimeInterval {
		return (startTime?.timeIntervalSinceReferenceDate ?? 0) % 1
	}
}