//
//  UnsyncedTimer.swift
//  Timer
//
//  Created by Damiaan Dufaux on 10/05/15.
//  Copyright (c) 2015 Damiaan Dufaux. All rights reserved.
//

import Foundation

/// A basic timer wich can be paused and resumed
public class UnsyncedTimer: NSObject {
	var timer: NSTimer?
	let interval: NSTimeInterval
	var signalFunction: () -> ()
	
	func callSignalFunction() {
		signalFunction()
	}
	
	public init(interval: NSTimeInterval, callback: () -> ()) {
		self.signalFunction = callback
		self.interval = interval
		super.init()
	}
	
	func createTimer() {
		timer?.invalidate()
		signalFunction()
		timer = NSTimer.scheduledTimerWithTimeInterval(interval, target: self, selector: "callSignalFunction", userInfo: nil, repeats: true)
	}
	
	/// Starts or resumes the timer
	public func start() {
		createTimer()
	}
	
	/// Pauses the timer
	public func pause() {
		timer?.invalidate()
	}
}
