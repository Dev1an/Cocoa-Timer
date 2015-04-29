//
//  Timer.swift
//  Timer
//
//  Created by Damiaan Dufaux on 29/04/15.
//  Copyright (c) 2015 Damiaan Dufaux. All rights reserved.
//

import Cocoa

class Timer: NSObject {
	var duration: NSTimeInterval
	var start: NSDate?
	
	var signalFunction: (() -> ())?
	var signalTimer: NSTimer?
	
	init(duration: NSTimeInterval) {
		self.duration = duration
		super.init()
	}
	
	func startTiming() {
		start = NSDate()
		signalTimer = NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(1), target: self, selector: "callSignalFunction", userInfo: nil, repeats: true)
	}
	
	func callSignalFunction() {
		signalFunction?()
	}

	func getTime() -> NSTimeInterval {
		if let start = start {
			return max(0, duration + start.timeIntervalSinceNow)
		} else {
			return duration
		}
	}
}
