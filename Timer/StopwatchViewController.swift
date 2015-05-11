//
//  StopwatchViewController.swift
//  Timer
//
//  Created by Damiaan Dufaux on 9/05/15.
//  Copyright (c) 2015 Damiaan Dufaux. All rights reserved.
//

import Cocoa
import CoreTimer

class StopwatchViewController: NSViewController {
	
	@IBOutlet var timeLabel: NSTextField!
	@IBOutlet var startButton: NSButton!
	var formatter = TimedIntervalFormatter()
	var stopwatch = LappedStopwatch()
	var timer: UnsyncedTimer!
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		timer = SyncedTimer(interval: 0.1, syncedObject: stopwatch, callback: timerCallback)
		if let savedStopwatch = NSUserDefaults(suiteName: "group.devian.timer")!.objectForKey("Saved stopwatch") as? NSData {
			stopwatch = NSKeyedUnarchiver.unarchiveObjectWithData(savedStopwatch) as! LappedStopwatch
		}
	}
	
	// MARK: Button actions
	@IBAction func stop(sender: AnyObject) {
		stopwatch.reset()
		timer.pause()
		startButton.title = "Start"
		timerCallback()
	}
	@IBAction func startPause(sender: NSButton) {
		stopwatch.toggleState()
		if stopwatch.isTicking {
			timer.start()
			sender.title = "Pause"
		} else {
			timer.pause()
			sender.title = "Start"
		}
		timerCallback()
	}
	@IBAction func newLap(sender: AnyObject) {
		stopwatch.newLap()
	}
	
	func timerCallback() {
		timeLabel.stringValue = formatter.stringFromTimeInterval(stopwatch.duration)!
	}

	// MARK: View lifecycle
	var observer: NSObjectProtocol?
	
	override func viewWillAppear() {
		timerCallback()
	}
	
	override func viewDidAppear() {
		if stopwatch.isTicking { timer.start() }
		observer = NSNotificationCenter.defaultCenter().addObserverForName(NSWindowDidChangeOcclusionStateNotification, object: view.window!, queue: NSOperationQueue.mainQueue()) {
			notification in
			if self.view.window!.occlusionState.rawValue & NSWindowOcclusionState.Visible.rawValue == NSWindowOcclusionState.Visible.rawValue {
				self.timer.start()
			} else {
				self.timer.pause()
			}
		}
	}
	
	override func viewWillDisappear() {
		timer.pause()
			NSNotificationCenter.defaultCenter().removeObserver(observer!)
	}
	
	override func viewDidLoad() {
	}
}

@objc(TimeTransformer) class TimeTransformer: NSValueTransformer {
	
	var formatter = TimedIntervalFormatter()
	
	override class func transformedValueClass() -> AnyClass {
		return NSString.self
	}
	
	override class func allowsReverseTransformation() -> Bool {
		return false
	}
	
	override func transformedValue(value: AnyObject?) -> AnyObject? {
		if let ti = value as? NSTimeInterval {
			return formatter.stringFromTimeInterval(ti)
		} else {
			return nil
		}
	}
}
