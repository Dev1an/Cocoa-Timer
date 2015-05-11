//
//  SyncedTimer.swift
//  Timer
//
//  Created by Damiaan Dufaux on 10/05/15.
//  Copyright (c) 2015 Damiaan Dufaux. All rights reserved.
//

import Foundation

public protocol Syncable {
	var referenceDate: NSDate { get }
}

/// A timer that runs in sync with another timer
public class SyncedTimer: UnsyncedTimer, Syncable {
	var syncedObject: Syncable
	public var referenceDate: NSDate {
		return syncedObject.referenceDate
	}
	
	public init(interval: NSTimeInterval, syncedObject: Syncable, callback: () -> ()) {
		self.syncedObject = syncedObject
		super.init(interval: interval, callback: callback)
	}
	
	public override func start() {
		let delay: NSTimeInterval
		let offsetNow: NSTimeInterval = NSDate().timeIntervalSinceReferenceDate % interval
		let offsetReference = syncedObject.referenceDate.timeIntervalSinceReferenceDate % interval
		
		if offsetNow > offsetReference {
			delay = interval - offsetNow + offsetReference
		} else {
			delay = offsetReference - offsetNow
		}
		
		NSTimer.scheduledTimerWithTimeInterval(delay, target: self, selector: "createTimer", userInfo: nil, repeats: false)
	}
	
}