//
//  Timer.swift
//  Timer
//
//  Created by Damiaan Dufaux on 9/05/15.
//  Copyright (c) 2015 Damiaan Dufaux. All rights reserved.
//

import Foundation

public class Timer: NSObject {
	public var duration: NSTimeInterval {
		didSet {
			if start != nil {
				start = NSDate()
			}
		}
	}
	var start: NSDate?
	
	public var signalFunction: (() -> ())?
	var signalTimer: NSTimer?
	
	public init(duration: NSTimeInterval) {
		self.duration = duration
		super.init()
	}
	
	public func startTiming() {
		start = NSDate()
		signalTimer = NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(1), target: self, selector: "callSignalFunction", userInfo: nil, repeats: true)
	}
	
	public func pauseTiming() {
		signalTimer?.invalidate()
		callSignalFunction()
		duration = getTime()
		start = nil
	}
	
	func callSignalFunction() {
		signalFunction?()
	}
	
	public func getTime() -> NSTimeInterval {
		if let start = start {
			return max(0, duration + start.timeIntervalSinceNow)
		} else {
			return duration
		}
	}
}
