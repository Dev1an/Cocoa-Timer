//
//  UnsyncedTimer.swift
//  Timer
//
//  Created by Damiaan Dufaux on 10/05/15.
//  Copyright (c) 2015 Damiaan Dufaux. All rights reserved.
//

import Foundation

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
	
	public func start() {
		createTimer()
	}
	
	public func pause() {
		timer?.invalidate()
	}
}
