//
//  SyncedTimer.swift
//  Timer
//
//  Created by Damiaan Dufaux on 10/05/15.
//  Copyright (c) 2015 Damiaan Dufaux. All rights reserved.
//

import Foundation

public protocol Syncable {
	var syncOffset: NSTimeInterval { get }
}

/// A timer that runs in sync with another timer
public class SyncedTimer: UnsyncedTimer, Syncable {
	var syncedObject: Syncable
	public var syncOffset: NSTimeInterval {
		return syncedObject.syncOffset
	}
	
	public init(interval: NSTimeInterval, syncedObject: Syncable, callback: () -> ()) {
		self.syncedObject = syncedObject
		super.init(interval: interval, callback: callback)
	}
	
	public override func start() {
		let delay: NSTimeInterval
		let offsetNow: NSTimeInterval = NSDate().timeIntervalSinceReferenceDate % 1
		let offsetReference = syncedObject.syncOffset
		
		if offsetNow > offsetReference {
			delay = 1 - offsetNow + offsetReference
		} else {
			delay = offsetReference - offsetNow
		}
		
		NSTimer.scheduledTimerWithTimeInterval(delay, target: self, selector: "createTimer", userInfo: nil, repeats: false)
	}
	
}